---
title: "軟體開發生命週期"
description: "端到端 SDLC 概覽，涵蓋從規劃到監控的 11 個階段，含工具推薦與部署策略"
tags:
  - process
---

# 軟體開發生命週期

## 概覽

軟體開發生命週期（SDLC）確保產品從需求到上線的過程系統化且高品質。

## 工作流程階段

```mermaid
graph TD
    subgraph Plan[" 規劃 "]
        PO[Product Owner]
        Stories[1\. 用戶故事]
        Backlog[Product Backlog]
        PO --> Stories --> Backlog
    end

    subgraph Refine[" Refinement "]
        Review[2\. Refinement]
        DoR[Definition of Ready]
        Review --> DoR
    end

    subgraph Design[" 設計 "]
        Arch[3\. 架構]
        Specs[技術規格]
        Arch --> Specs
    end

    subgraph Development[" 開發 "]
        Dev[4\. 撰寫程式碼]
        Test[5\. 本地測試]
        Dev --> Test
    end

    subgraph Build[" CI/CD "]
        CI[6\. 自動化建置]
        AutoTest[7\. 自動化測試]
        CI --> AutoTest
    end

    subgraph TestEnv[" QA "]
        QA[8\. QA 測試]
        UAT[9\. UAT]
        QA --> UAT
    end

    subgraph Release[" 正式環境 "]
        Deploy[10\. 部署]
        Monitor[11\. 監控]
        Deploy --> Monitor
    end

    Backlog --> Review
    DoR --> Arch
    Specs --> Dev
    Test --> CI
    AutoTest --> QA
    UAT --> Deploy
    Monitor -.回饋.-> Backlog

    style Plan fill:#d4f1d4
    style Refine fill:#fce4ec
    style Design fill:#e8f4f8
    style Development fill:#fff4cc
    style Build fill:#ffd4e5
    style TestEnv fill:#d4e5ff
    style Release fill:#e5d4ff
```

## 核心階段

### 1. 規劃
建立用戶故事、定義驗收標準、排定 backlog 優先順序。

### 2. Refinement
審查項目、評估可行性、估算工作量、確認 Definition of Ready。
*詳情請見 [Refinement Process](blog/Software%20development%20process/2-2%20Refinement%20Process.md)*

### 3. 架構設計
設計系統架構、選擇技術棧、定義需求規格。

**工具**：Figma、Excalidraw、Miro、Lucidchart、FigJam、Draw.io

### 4. 開發
撰寫程式碼、本地測試、程式碼審查、版本控制。

**工具**：Git（GitHub、GitLab、Bitbucket）、VSCode、IntelliJ、Cursor  
**AI**：Copilot、Claude Code、Cursor AI  
**API Mocking**：MSW、JSON Placeholder、JSON Server

### 5. 持續整合
自動化建置、測試套件、程式碼覆蓋率、靜態分析。

**CI**：Jenkins、CircleCI、GitLab CI、Travis CI、Buildkite  
**品質**：SonarQube、CodeClimate

### 6. 測試環境

**QA**：執行測試、驗證需求、回歸測試  
**UAT**：關係人驗收、類正式環境測試

**工具**：Playwright、Cypress、Selenium、Percy、Chromatic、Lighthouse  
**跨瀏覽器**：BrowserStack、LambdaTest

### 7. 部署
漸進式發布、功能開關、藍綠/金絲雀部署、煙霧測試。

**策略**：
- Feature Toggles：控制功能可見性
- Canary：漸進式發布（5% → 100%）
- Blue-Green：零停機部署

**平台**：Vercel、Netlify、Railway、Render、DigitalOcean

### 8. 監控
錯誤追蹤、效能指標、用戶分析、告警通知。

| 類別 | 工具 |
|------|------|
| 錯誤 | Sentry、Rollbar、Bugsnag |
| 效能 | Datadog、New Relic、Grafana |
| 日誌 | ELK Stack、Splunk、Loki |
| 用戶分析 | PostHog、Google Analytics |

## 應避免的反模式

- 手動部署、長生命週期功能分支
- 跳過程式碼審查、沒有自動化測試
- 忽略監控告警
