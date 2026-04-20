---
title: "大規模前端架構"
description: "前端專案規模化的實務指南——Monorepo 策略、Micro Frontend、Design System 工程，以及跨團隊協作模式"
draft: true
tags:
  - architecture
---

# 大規模前端架構：來自真實專案的經驗

在規模化的情境下，微小的架構決策會加乘成龐大的技術債，或帶來顯著的效率提升。走訪 7 家公司——從新創 MVP 到企業級平台——以下是我實際驗證過有效的做法。

## 1. Monorepo 策略

### Monorepo 適用時機
- 多個應用共享 UI 元件（例如：客戶入口網站 + 後台管理儀表板）
- Design System 與使用它的應用並行維護
- 共享工具函式、API 客戶端與型別定義
- 團隊規模 > 5 位開發者、協作開發相互關聯的功能

### 工具比較
| 工具 | 建構系統 | 套件管理 | 學習曲線 |
|------|-------------|-------------------|----------------|
| **Nx** | 自訂（高效） | npm/yarn/pnpm | 高 |
| **Turborepo** | 內容雜湊快取 | npm/yarn/pnpm | 中 |
| **pnpm workspaces** | 無（自行整合） | pnpm 原生 | 低 |
| **Lerna** | 已過時的模型 | npm/yarn | 低（但已落伍） |

### 關鍵架構決策
- **Package 邊界**：如何拆分套件（按功能 vs 按類型）
- **相依性管理**：內部與外部相依性的版本控制策略
- **建構快取**：遠端快取設定（Nx Cloud、Turborepo Remote Cache）
- **CI 優化**：僅測試受影響的範圍、平行化 Pipeline
- **程式碼所有權**：CODEOWNERS 文件、套件層級的審查要求

### 實務範例
- 典型 Monorepo 的目錄結構
- 共享 TypeScript 設定模式
- 相依關係圖視覺化

## 2. Micro Frontends

### 架構模式
1. **建構期組合**：npm 套件，簡單但部署週期耦合
2. **執行期透過 Module Federation 組合**：Webpack 5/Rspack，可獨立部署
3. **伺服器端組合**：Tailor/Podium，支援 SSR 但複雜度高
4. **基於 iframe**：最高隔離性，但使用者體驗最差（除非有舊系統限制，否則避免使用）

### Module Federation 深度解析
- Host/remote 設定
- 共享相依性協商（singleton vs 版本範圍）
- 遠端載入失敗時的執行期錯誤邊界
- 版本策略：團隊間的語意化版本合約

### 不適合使用 Micro Frontends 的情境
- 整個前端由單一團隊負責
- 應用程式 < 50k 行程式碼
- 沒有獨立部署的需求
- 對效能要求嚴苛的應用（額外開銷確實存在）

### 通訊模式
- Custom Events 實現鬆耦合
- 透過 URL/query params 共享狀態
- PostMessage 用於 iframe 邊界
- 共享 Redux store（高度耦合，通常避免使用）

## 3. Design System 工程

### 超越元件庫
Design System 不只是元件庫，它是一種組織工具，包含：
- **Design tokens**：顏色、間距、字體排版，以平台無關的值表示
- **元件 API 合約**：Props 介面、無障礙需求、行為規格
- **文件**：使用指南、正反範例、遷移指南
- **治理**：貢獻流程、破壞性變更政策、棄用生命週期

### 實作架構
```
design-system/
├── tokens/           # Design tokens (JSON/YAML → CSS/JS/iOS/Android)
├── primitives/       # Base components (Button, Input, Text)
├── patterns/         # Composed patterns (Form, Card, Dialog)
├── recipes/          # Page-level compositions (LoginForm, DataTable)
├── docs/             # Storybook + usage documentation
└── tools/            # CLI for scaffolding, linting rules
```

### 技術決策
- **Headless vs 帶樣式**：Radix/Headless UI 基礎 + 自訂樣式 vs 完整樣式（Material UI）
- **樣式方案**：CSS Modules、Tailwind、CSS-in-JS（Vanilla Extract）、CSS custom properties
- **版本控制**：獨立元件版本 vs 單體式版本
- **測試**：視覺回歸測試（Chromatic）、無障礙測試（axe-core）、互動測試（Testing Library）
- **多框架支援**：Web Components 包裝器、框架專屬套件

### Token Pipeline
- Figma → Style Dictionary → CSS Custom Properties / Tailwind config / iOS / Android
- 透過 Figma API 或 Tokens Studio 自動同步

## 4. 大規模狀態管理

### 決策框架
| 情境 | 推薦方案 |
|----------|---------------------|
| 伺服器狀態（API 資料） | React Query / SWR / Apollo |
| 簡單 UI 狀態 | useState / useReducer |
| 跨元件 UI 狀態 | Zustand / Jotai |
| 複雜業務邏輯 | Redux Toolkit（搭配 RTK Query） |
| 表單狀態 | React Hook Form / Formik |
| URL 狀態 | URL search params（nuqs） |

### 規模化的反模式
- 將 Global store 用於所有事情（把 Redux 當資料庫）
- 衍生狀態未記憶化（每次渲染重新計算）
- Prop drilling 超過 3 層卻未重構為組合模式
- 在同一個 store 中混用伺服器狀態與客戶端狀態

### 架構模式：功能導向狀態
```
features/
├── auth/
│   ├── hooks/useAuth.ts        # Feature-specific hooks
│   ├── store/authStore.ts      # Zustand slice
│   └── api/authApi.ts          # React Query hooks
├── dashboard/
│   ├── hooks/useDashboard.ts
│   └── api/dashboardApi.ts     # No local store needed
```

## 5. 跨團隊協作模式

### API 合約管理
- **OpenAPI/Swagger**：Schema 優先的 API 設計，自動生成 TypeScript 型別
- **GraphQL code generation**：從 Schema 產生型別安全的 query 與 mutation
- **Mock Service Worker (MSW)**：前端開發不依賴後端是否就緒
- **Contract testing**：使用 Pact 或類似工具驗證 API 相容性

### 規模化的程式碼審查
- 重大決策使用 Architectural Decision Records（ADRs）
- 跨團隊變更採用 RFC 流程
- 自動化檢查：Bundle 大小限制、無障礙分數、型別覆蓋率

### 文件即程式碼
- 架構圖以 Mermaid 撰寫（納入版本控制）
- 元件文件置於 Storybook（活文件）
- 決策記錄採用 ADR 格式
- 生產事故的 Runbook

## 6. 效能預算與監控

### 設定效能預算
- JavaScript 預算：初始載入 gzip 後 < 300KB
- LCP 目標：3G 網路下 < 2.5 秒
- CLS 目標：< 0.1
- INP 目標：< 200ms

### 自動化執行
- Webpack/Vite bundle size 外掛
- PR 檢查中的 Lighthouse CI
- Real User Monitoring（RUM）儀表板
- 效能衰退警報（衰退 > 10%）

---

*架構不是選擇「最佳」技術——而是做出團隊能夠長期維護與演進的決策。*
