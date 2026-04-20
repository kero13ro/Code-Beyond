---
title: "用 Chrome MCP 優化網站效能"
description: "以 Chrome MCP 進行實際效能分析的案例研究——LCP 拆解、圖片優化，以及第三方腳本稽核的可量化結果"
tags:
  - performance
  - tools
---

### 網站效能優化是什麼？

網站效能優化有三個層次：

#### 第一層：策略評估
- 評估功能是否真有必要
- 向利害關係人溝通隱性成本與取捨
- 防止功能膨脹侵蝕效能
- **核心觀點：** 不是每個功能都讓產品更好；有些只會讓它更慢、更難維護

#### 第二層：架構決策
- 根據產品類型選擇合適的渲染策略（SSG、SSR、CSR）
- 規劃多層快取（CDN、Redis、伺服器端）
- 選擇部署區域以降低延遲
- 決定元件共用、monorepo 結構、build 快取策略
- **核心觀點：** 架構決策會乘數放大到所有後續工作，影響是指數級的

#### 第三層：技術實作
- 優化個別程式碼路徑、縮減 JavaScript bundle 大小
- 消除 layout thrashing 與強制 reflow
- 實作高效率的資源傳輸與壓縮
- 優化渲染與執行效能

更深入的背景可參考 [[What Excellent Product Developers Know]] 與 [[How to Optimize Website Performance]]。

本文聚焦於使用 Chrome MCP 示範第三層的實際優化技術，並呈現可量化的改善幅度。

### 什麼是 Chrome MCP？

Chrome MCP（Model Context Protocol）是整合進 Claude Code 的強大除錯工具，提供詳細的效能分析與洞察。它能夠：

- 擷取含 Core Web Vitals 資料的完整效能追蹤
- 分析資源載入瀑布圖與依賴鏈
- 找出關鍵渲染路徑的瓶頸
- 提供具體可行的效能改善建議
- 即時量測優化效果

Chrome MCP 將 Chrome DevTools 直接連接至 AI 分析——得到的是根本原因，而不只是 Lighthouse 分數。

### 案例研究：分析 Appier.com

我透過分析 [Appier](https://www.appier.com/en/) 來示範 Chrome MCP 稽核的實際樣貌。

#### 互動效能問題
快速在頂部導覽列的選單項目間 hover 時，使用者會感受到約 500ms 的延遲。這是 forced reflow 與 layout thrashing 的典型症狀——詳細說明見 [Optimize Browser Reflow & Repaint]。

**資源大小分析：**
初始頁面載入需要 120 MB 的資源——這個數字本身就是優化機會的訊號。主要問題是 2400 × 1350 解析度的 GIF 檔案。

將這些 GIF 轉換為 AVIF 格式後，檔案大小降至 **21 MB**。
再套用響應式圖片原則，使用 1200px 解析度取代 2400px，總量進一步降至 **2.9 MB**。

頁面總大小從 120 MB 降至約 50 MB——減少 58%，下載與渲染速度提升一倍。
![[Pasted image 20251108162150.png]]


### Core Web Vitals 指標

我們不依賴傳統的 Lighthouse 稽核，而是直接用 Chrome MCP 與 Claude Code 深入調查這些效能問題的根本原因。

| 指標 | 數值 | 狀態 |
| ------------------------------ | -------- | -------------------- |
| LCP（Largest Contentful Paint）| 1,288 ms | ⚠️ 需要改善 |
| CLS（Cumulative Layout Shift） | 0.00 | ✅ 優秀 |
| TTFB（Time to First Byte） | 36 ms | ✅ 優秀 |
| 關鍵路徑延遲 | 609 ms | ⚠️ 過長 |

#### 發現的主要效能問題

**1. LCP 元素載入延遲（1,288 ms）**

LCP 元素是一個影片檔（Header_EN_0909.mp4，3.2 MB），延遲分為三部分：

- **Load Delay：473 ms（36.7%）** — 發現並請求資源所花的時間
- **Render Delay：524 ms（40.7%）** — 渲染開始前的等待時間（延遲最大的來源）
- **Load Duration：256 ms（19.9%）** — 資源實際下載時間

**How to fix LCP：**
- ❌ 缺少 `fetchpriority="high"` 屬性——應立即加上
- 將影片替換為優化過的靜態圖片（影片的載入開銷更高）
- 將影片從 3.2 MB 壓縮至 500 KB 以內
- **預期改善：減少 200–300 ms**

**2. 第三方腳本開銷（288 kB + 159 ms 主執行緒時間）**

網站載入了多個第三方依賴：

- **Unpkg（Swiper）：** 151.5 kB + 114 ms 主執行緒時間 ⚠️ 問題最嚴重
- **HubSpot：** 108.3 kB + 42 ms 主執行緒時間
- **Google Fonts：** 79.5 kB
- **YouTube Embed：** 31 kB + 3 ms

**How to fix third-party scripts：**
- 延遲載入 HubSpot 腳本（非關鍵路徑）
- 自行托管 Swiper，不從 Unpkg CDN 載入
- Google Fonts 加上 `font-display: swap`，防止阻塞渲染
- **預期改善：總計減少 100–150 ms**

**3. 過長的關鍵路徑鏈（609 ms）**

依賴鏈問題如下：

```
Index HTML (140 ms) →
  template_global.min.js (609 ms) →
    其他 JS 檔案（序列載入）
```

所有 JavaScript 檔案序列載入而非平行載入，造成不必要的長關鍵路徑。

**How to fix the critical path：**
- 將 JavaScript 拆分為可平行載入的小 chunk
- 為關鍵資源加上 `<link rel="preload">`
- 為 CDN 資源實作 `preconnect`
- **預期改善：減少 150–200 ms**

**4. Forced Reflow 問題**

`template_global.min.js` 造成 21 ms 的 forced reflow，總 reflow 時間 46 ms。這與前面觀察到的導覽選單 hover 延遲直接對應。

**How to fix forced reflows：**
- 稽核 `template_global.js` 中的 DOM 查詢模式
- 避免在 DOM 修改後立即讀取 layout 屬性
- 使用 `requestAnimationFrame` 批次處理 layout 更新
- **預期改善：減少 20–30 ms**

#### 優化優先順序

**優先級 1（立即執行）**
1. 為 LCP 影片加上 `fetchpriority="high"`
2. 延遲非關鍵第三方腳本（HubSpot）
3. 將 3.2 MB 影片替換為優化圖片

**優先級 2（短期改善）**
1. 將 JavaScript 依賴鏈改為平行載入
2. 修復 `template_global.js` 中的 forced reflow
3. 自行托管 Swiper

**優先級 3（長期策略）**
1. 實作積極的 code splitting
2. 遷離 HubSpot 生成的模板

#### 預期成果
完成優先級 1 與 2 的優化後：
- **LCP：** 1,288 ms → 約 800–900 ms（改善 30–40%）
- **關鍵路徑：** 609 ms → 約 450–500 ms
- **整體使用者體驗：** 內容可見速度明顯提升

#### 現有優勢
儘管有上述問題，Appier.com 也有幾個值得肯定之處：
- ✅ TTFB 極佳（36 ms）
- ✅ CLS 完美（0.00，無版面位移）
- ✅ 已預設 preconnect 至 Google Fonts
- ✅ CDN 配置完善（CloudFront + Cloudflare）

即使是成熟的公司，也常留下可觀的效能空間沒有利用。Chrome MCP 讓你能在一個下午找到並量化這些機會，而不是花整個 sprint。
