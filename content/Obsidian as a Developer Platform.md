---
title: "Obsidian 作為開發者平台"
description: "一位資深前端工程師深入剖析 Obsidian 的 Plugin 架構與自動化模式——以及從這套系統學到的軟體設計原則"
tags:
  - tools
  - architecture
---

大多數開發者把筆記應用程式當作被動容器——一個存放會議紀錄和書籤的地方。在使用 Notion 五年並完整遷移到 Obsidian 之後，我有了不同的看法。Obsidian 不只是一個筆記應用程式，它是一個 local-first 的開發者平台，擁有 TypeScript Plugin 架構、查詢引擎，以及一個 URL 協定，讓它成為可程式化的資料儲存庫。

本文將介紹讓這一切成為可能的架構，並探討從中學到的系統設計原則。

---

## 1. 為什麼選 Obsidian——工程師的視角

### Local-First 架構

Obsidian 將所有內容以純 Markdown 檔案儲存在本地檔案系統。沒有專有資料庫、沒有雲端依賴、沒有 API 速率限制。你的 Vault 就只是一個資料夾：

```
remote-1/                          # Vault 根目錄（透過 iCloud 同步）
├── 00 -Execution/                 # 目標、Sprint、任務追蹤
│   ├── Todo List.md
│   ├── 2025.md
│   └── Sprint/
├── 01 - weekly/                   # 週回顧
├── blog/                          # 技術部落格草稿
├── finance/                       # 財務追蹤（案例研究）
├── note/                          # 技術筆記與深度研究
│   └── deeper/
├── work/                          # SOP、日誌/週誌
├── .obsidian/                     # App 設定與 Plugin 資料
│   └── plugins/                   # 14 個社群 Plugin
└── CLAUDE.md                      # AI Agent 指示
```

這個結構有一個關鍵優勢：**Markdown 是通用介面**。同樣的檔案可以被 GitHub、VS Code、靜態網站生成器（Quartz、Hugo、Astro），以及像 Claude Code 這樣的 AI 編碼 Agent 讀取。我的 Vault 根目錄中的 `CLAUDE.md` 給了 Claude Code 完整的專案結構、慣例與檔案位置上下文——這是專有格式無法做到的事。

### 遷移故事

我每天使用 Notion 長達五年。臨界點逐漸累積：

| 服務 | 月費 | 年費 | 你能得到什麼 |
|------|------|------|-------------|
| Notion Basic | $10 | $120 | 基本功能，5MB 上傳限制 |
| Notion + AI | $20 | $240 | AI 輔助、協作工具 |
| **Obsidian** | **$0** | **$0** | **完整功能、本地儲存** |
| iCloud 50GB | $1 | $12 | 跨裝置 Vault 同步 |
| Claude Pro | $20 | $240 | 透過 Claude Code 在任何檔案上進行 AI 編輯 |

數字很清楚，但費用不是唯一原因。三個工程考量才是驅動力：

1. **廠商鎖定**：Notion 使用專有的 Block 格式，匯出成 Markdown 會失去結構。Obsidian 的檔案本來就是 Markdown——沒有什麼需要匯出。
2. **AI 整合**：Claude Code 直接在我的 Vault 檔案系統上運行，讀取 `CLAUDE.md` 作為上下文，編輯任何 `.md` 檔案。Notion 的 API 需要 OAuth Token 和分頁 Block 解析。
3. **自動化上限**：Notion 的自動化僅限於其內建觸發器。Obsidian 的 Plugin 系統是一個完整的 TypeScript Runtime，擁有檔案系統存取、URL 協定處理器和生命週期 Hooks。

### Plugin 架構一覽

Obsidian Plugin 遵循一個對 VS Code 擴充套件或 Chrome Extension 開發者來說很熟悉的模式：

- **`manifest.json`** — 元資料：id、名稱、版本、最低 App 版本
- **`main.js`** — 入口點：一個繼承 `Plugin` 的 class，帶有 `onload()` / `onunload()` 生命週期 hooks
- **`data.json`** — 持久化設定、使用者設定

`Plugin` 基底 class 提供用於註冊命令、新增 UI 元素、存取 Vault 檔案系統，以及掛鉤編輯器事件的 API。Plugin 在 Electron Renderer Process 中運行，擁有完整的 Node.js 能力——讀寫檔案、發出 HTTP 請求、啟動進程，能做任何桌面應用程式能做的事。

---

## 2. 深入理解 Plugin 架構

三個 Plugin 構成了我所建構一切的骨幹。理解它們的架構，就能解釋為什麼 Obsidian 不只是一個筆記編輯器。

### Dataview：Schema-on-Read 查詢引擎

Dataview 將你的 Vault 視為資料庫。你不需要預先定義 Schema（像 SQL 表或 Notion 資料庫那樣），而是使用 **Inline Fields** 直接在 Markdown 中嵌入結構化資料：

```markdown
- 午餐便當 (d:: 02-08) (c:: 食物) (a:: 200)
```

`(key:: value)` 語法創建了可查詢的欄位，同時不破壞 Markdown 的可讀性。這是一個 **Schema-on-Read** 模型——類似於 MongoDB 等文件資料庫的工作方式。你寫自由格式的內容加上可選的結構，查詢引擎在讀取時提取含義。

Dataview 同時提供宣告式查詢語言（DQL，類似 SQL）和完整的 JavaScript API：

```javascript
// 查詢財務頁面，提取清單項目，計算總計
const page = dv.page("finance/2026-02");
const items = page.file.lists.values;
for (const item of items) {
  const amt = Number(item.a);  // 存取 inline field 'a'
  const cat = item.c;          // 存取 inline field 'c'
}
```

### QuickAdd：宣告式自動化引擎

QuickAdd 是一個具有捕獲管道的巨集系統：**輸入 → 格式化 → 路由 → 持久化**。每個巨集是一個宣告式設定，定義了：

1. **要問使用者什麼** — 帶有可選預定義選項的輸入提示
2. **如何格式化資料** — 帶有日期/值插值的模板字串
3. **寫入何處** — 目標檔案（支援動態路徑）、目標標題、不存在時創建

### Advanced URI：跨進程通訊協定

`obsidian://adv-uri` 協定處理器將 Obsidian 變成一個任何外部程式都可以呼叫的 API 端點。它支援的操作包括：

- 在特定標題下**附加資料到檔案**
- **開啟檔案**至特定行
- **執行任何 Plugin 註冊的命令**

這在架構上與行動應用中的 Deep Linking 或桌面應用中的自訂 URL 協定完全相同。任何能開啟 URL 的程式——Shell Script、iOS Shortcut、Raycast 命令——都可以將結構化資料寫入你的 Vault。

三個 Plugin 之間的資料流：

```
使用者輸入 → QuickAdd 格式字串 → .md 中的 Inline Fields → Dataview JS → Dashboard
```

---

## 3. Plugin 棧——按架構層組織

與其按字母順序列出 Plugin，不如看看 14 個已安裝的 Plugin 如何對應到系統架構層：

| 層級 | Plugin | 工程類比 |
|------|--------|---------|
| **資料輸入** | QuickAdd、Advanced URI、Natural Language Dates | 表單處理器、API 端點、輸入解析器 |
| **組織** | Periodic Notes、Calendar、Custom Attachment Location、Excalidraw | Cron 排程器、資產管道、圖表工具 |
| **查詢與展示** | Dataview、Columns、Style Settings | 客戶端資料庫、CSS Grid、設計 Token |
| **品質與自動化** | LanguageTool、Keep the Rhythm、Copilot、Date Inserter | ESLint、CI 指標、AI 配對程式設計 |

關鍵洞察：**價值來自於組合，而非單個功能**。QuickAdd 單獨只是一個表單。Dataview 單獨只是一個查詢工具。Advanced URI 單獨只是一個 URL 處理器。但組合在一起，它們形成了一個資料管道，能媲美專門建構的應用程式——零基礎設施成本，完全離線。

這與 Unix 哲學相同：小而專注的工具通過通用介面連接（Unix 是文字流，Obsidian 是 Markdown 檔案）。

→ 實際應用案例見 [[Obsidian 個人財務追蹤系統]]。

---

## 6. 從這套系統學到的系統設計

在筆記應用程式內建立這個系統，強化了幾個遠超個人生產力工具範疇的架構原則。

### 可組合性勝於巨石架構

每個 Plugin 只做一件事。QuickAdd 捕獲輸入。Dataview 查詢資料。Advanced URI 處理外部通訊。它們從未被設計為協同工作——它們通過 Markdown 檔案的共用介面組合在一起。這與微服務的工作方式相同：獨立服務通過定義明確的協定溝通。

### Schema-on-Read vs Schema-on-Write

Inline Field 方式（`(key:: value)`）在寫入時不強制結構。你可以在某些記錄上新增 `(n:: note)` 欄位，其他不加。Dataview 優雅地處理缺失——`item.n` 只是 undefined。這是文件資料庫的取捨：你以失去一致性保證為代價，換得靈活性和迭代速度。對個人財務追蹤器來說，這是正確的取捨。對銀行系統來說，則不然。

### Local-First 架構

整個系統離線運作。資料儲存在裝置上，透過 iCloud 同步，無需網路存取即可查詢。沒有伺服器要維護，沒有 API 要監控，沒有訂閱要管理。運營成本實際上是零。隨著邊緣運算和 local-first 軟體日益受到重視，這是一個越來越相關的模式——同樣的原則適用於 CRDT、SQLite 等 local-first 資料庫，以及離線能力的 PWA。

### 為自己建造工具

最強的作品集專案不是 Todo App 或天氣儀表板，而是解決你真實問題的系統。限制是真實的，設計決策是真誠的，成果是你每天都在使用的東西。如果你在找一個能在面試中展示系統思維的 Side Project，從一個你真正在乎的問題開始。真實性是看得出來的。
