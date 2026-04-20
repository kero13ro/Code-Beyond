---
title: "前端效能監控系統"
description: "打造生產級效能監控系統——Web Vitals 收集、錯誤追蹤、告警管線與效能預算"
draft: true
tags:
  - performance
  - architecture
---

# 前端效能監控系統：從指標到可行動的洞察

不量測就無從優化。以下說明如何建立真正能驅動改善的監控機制——從收集正確指標，到發出真正有意義的告警。

## 1. Core Web Vitals：超越基礎

### 三大支柱
| 指標 | 目標值 | 衡量什麼 | 常見原因 |
|--------|--------|-----------------|---------------|
| **LCP** | < 2.5s | 最大可見內容的渲染時間 | 伺服器慢、阻塞渲染的資源、大圖片 |
| **INP** | < 200ms | 對使用者互動的響應速度 | 長任務、大量 JS、主執行緒阻塞 |
| **CLS** | < 0.1 | 頁面載入過程的視覺穩定性 | 動態內容注入、網頁字型、無尺寸圖片 |

### 常見的量測錯誤
- **只在實驗室量測**：Lighthouse 分數 ≠ 真實使用者體驗，第 75 百分位的田野資料才是關鍵
- **只看平均值**：P50 會掩蓋長尾問題，應分別監控 P75 與 P95
- **忽略 INP**：2024 年已取代 FID，但許多團隊仍未追蹤互動響應速度
- **CLS 歸因**：`LayoutShift.sources` API 能告訴你確切是哪些元素移位了

### 值得追蹤的進階指標
- **TTFB**：伺服器響應時間（目標 < 800ms）
- **FCP**：First Contentful Paint——感知載入速度
- **TBT**：Total Blocking Time——實驗室中對 INP 的代理指標
- **Long Animation Frames（LoAF）**：識別造成卡頓的腳本，附帶歸因資訊

## 2. 埋點架構

### 客戶端收集

```javascript
// 整合 web-vitals 函式庫
import { onLCP, onINP, onCLS, onFCP, onTTFB } from 'web-vitals';

function sendMetric(metric) {
  const payload = {
    name: metric.name,
    value: metric.value,
    rating: metric.rating,        // 'good' | 'needs-improvement' | 'poor'
    delta: metric.delta,
    id: metric.id,
    attribution: metric.attribution, // 根本原因資料
    navigationType: metric.navigationType,
    // 情境資訊
    url: location.href,
    route: getCurrentRoute(),       // SPA 路由
    userAgent: navigator.userAgent,
    connection: navigator.connection?.effectiveType,
    deviceMemory: navigator.deviceMemory,
    timestamp: Date.now(),
  };

  // 頁面卸載時用 sendBeacon 確保資料不丟失
  navigator.sendBeacon('/api/metrics', JSON.stringify(payload));
}

onLCP(sendMetric);
onINP(sendMetric);
onCLS(sendMetric);
```

### 關鍵設計決策
- **取樣率**：staging 收集 100%，正式環境收集 10–25%（平衡成本與準確性）
- **緩衝**：客戶端批次累積指標，每 5 秒或在 `visibilitychange` 時發送
- **歸因**：永遠包含 `attribution`——它告訴你指標為什麼差，而不只是差多少
- **情境豐富化**：網路類型、裝置記憶體、SPA 路由、A/B 測試版本

### 資料管線

```
瀏覽器 → sendBeacon → Edge Function（豐富化 + 驗證）
                                ↓
                        訊息佇列（Kafka/SQS）
                                ↓
                    ┌───────────┴───────────┐
                    ↓                       ↓
            時序資料庫                  分析資料庫
            (InfluxDB/Prometheus)   (BigQuery/ClickHouse)
                    ↓                       ↓
            即時儀表板                  Ad-hoc 分析
            + 告警                      + 報表
```

## 3. 錯誤追蹤整合

### 錯誤分類
1. **JavaScript 執行期錯誤**：未捕獲的例外、Promise rejection
2. **資源載入錯誤**：腳本、圖片、CSS 載入失敗
3. **API 錯誤**：4xx/5xx 響應、逾時、網路失敗
4. **自定義業務錯誤**：付款失敗、表單驗證、狀態不一致

### 實作模式

```javascript
// 全域錯誤處理，附帶情境資訊
window.addEventListener('error', (event) => {
  reportError({
    type: 'runtime',
    message: event.message,
    stack: event.error?.stack,
    filename: event.filename,
    lineno: event.lineno,
    colno: event.colno,
    // 關聯資訊
    sessionId: getSessionId(),
    breadcrumbs: getBreadcrumbs(), // 最近 N 個使用者操作
    performanceMetrics: getLatestMetrics(),
  });
});

// 資源載入錯誤
window.addEventListener('error', (event) => {
  if (event.target !== window) {
    reportError({
      type: 'resource',
      tagName: event.target.tagName,
      src: event.target.src || event.target.href,
    });
  }
}, true); // 資源錯誤需要 capture phase
```

### Source Map 管理
- 在 CI/CD 過程中將 source maps 上傳至錯誤追蹤服務（絕不暴露於正式環境）
- 以 build hash 為 source maps 加上版本號
- 至少保留 90 天以供除錯歷史錯誤

### 工具比較
| 工具 | 優勢 | 計費模式 |
|------|-----------|---------------|
| **Sentry** | 最佳錯誤分組、session replay、效能監控 | 以事件數計費 |
| **Datadog RUM** | 基礎設施 + 前端統一監控 | 以 host + session 計費 |
| **LogRocket** | 專注 session replay，支援 Redux 整合 | 以 session 計費 |
| **Self-hosted（Sentry）** | 完全掌控、符合合規要求 | 以基礎設施成本計費 |

## 4. 告警策略

### 告警層級
```
P1（緊急）→ PagerDuty / 電話
├── 錯誤率 > 5%，持續 5 分鐘
├── LCP P75 > 4s，持續 10 分鐘
└── JavaScript 錯誤突增（3 倍基準線）

P2（警告）→ Slack 頻道
├── LCP P75 > 2.5s，持續 30 分鐘
├── CLS P75 > 0.1，持續 30 分鐘
├── INP P75 > 200ms，持續 30 分鐘
└── 出現從未見過的新錯誤類型

P3（資訊）→ 只在儀表板顯示
├── Bundle 大小增加 > 5%
├── CI 中超出效能預算
└── 第三方腳本性能退化
```

### 避免告警疲勞
- **用異常偵測取代靜態閾值**：使用滾動基準線（例如對比上週同一時段）
- **只發可行動的告警**：每個告警必須有明確的負責人與處理程序
- **告警聚合**：將相關告警分組（例如 LCP + TTFB 同時退化 = 可能是伺服器問題）
- **非工作時間靜音 + 升級機制**：非緊急告警在離峰時間批次累積

## 5. 效能預算執行

### 整合至 CI/CD

```yaml
# GitHub Actions 範例
- name: Lighthouse CI
  uses: treosh/lighthouse-ci-action@v11
  with:
    budgetPath: ./budget.json
    uploadArtifacts: true

- name: Bundle Size Check
  run: |
    npx bundlesize --config bundlesize.config.json
```

### 預算設定

```json
{
  "budgets": [
    {
      "path": "/",
      "resourceSizes": [
        { "resourceType": "script", "budget": 300 },
        { "resourceType": "stylesheet", "budget": 50 },
        { "resourceType": "image", "budget": 500 }
      ],
      "timings": [
        { "metric": "largest-contentful-paint", "budget": 2500 },
        { "metric": "total-blocking-time", "budget": 300 }
      ]
    }
  ]
}
```

### 工作流程
1. **PR 檢查**：Lighthouse CI 對比預算，超出則阻擋合併
2. **合併後**：對 staging 環境執行完整的合成監控
3. **正式環境**：RUM 資料與預算對比，退化時告警
4. **每週回顧**：與團隊共享效能報告，分析趨勢

## 6. 儀表板設計

### 必要視圖
1. **管理層儀表板**：CWV 各頁面分數、時間趨勢、通過/未通過狀態
2. **工程師儀表板**：錯誤率、API 延遲、bundle 大小、部署標記
3. **事故視圖**：將部署與指標變化、錯誤突增、使用者影響關聯起來
4. **探索視圖**：按裝置類型、網路、地區、A/B 版本篩選

### 推薦技術棧
- **Grafana** + Prometheus/InfluxDB 用於時序指標
- **BigQuery/ClickHouse** 用於 ad-hoc 分析（例如「哪些路由在行動裝置的 INP 最差？」）
- **Sentry** 用於錯誤追蹤與 session replay
- **自定義儀表板** 用於團隊特定的 KPI

## 7. 第三方腳本監控

### 隱形的效能稅
第三方腳本（分析工具、廣告、客服聊天、A/B 測試）往往佔頁面總重的 50% 以上。

### 監控策略
- 使用 **PerformanceObserver** 追蹤第三方網域的資源載入時間
- 設定 **Content Security Policy（CSP）** 報告，偵測未授權腳本
- **定期稽核**：每季審查所有第三方腳本，逐一確認必要性或移除
- **載入策略**：使用 `async`/`defer`、使用者互動後才動態 import、透過 Partytown 移至 Web Worker

---

*效能監控不是一次性的建置——它是持續的實踐。目標不是零錯誤或完美分數，而是建立回饋循環：效能退化能被快速偵測、準確歸因、系統性地修復。這個循環能否運轉，決定了監控有沒有真正的價值。*
