---
title: "Claude Code 整合 MCP Servers 實測紀錄"
description: "實際測試 Chrome DevTools、Figma、GitHub 與 Atlassian 的 MCP 整合：哪些能用、哪些會壞、哪些有潛力"
tags:
  - tools
  - architecture
---

# Claude Code 整合 MCP Servers 實測紀錄

最近把 MCP（Model Context Protocol）servers 整合進 Claude Code 工作流程，這是我的測試筆記，記錄哪些有效、哪些有問題，以及哪些值得繼續探索。

![[Pasted image 20250930140312.png]]

## MCP 能做什麼？

MCP 的核心概念是讓 AI 直接連接外部工具與資料來源。理論上聽起來很強大，實際使用後發現有一些有趣的限制，也有更有趣的可能性。

以下是我測試過的幾個整合：

### Chrome DevTools MCP

這個真的有用。Claude 可以直接分析網頁效能、檢查 console 錯誤、捕捉網路請求，不再需要截圖後貼到對話裡。

**這讓以下事情成為可能：**
- 不切換視窗直接 debug
- 效能分析後立即產出程式碼建議
- 自動化無障礙稽核
- 檢查 API debug 的網路請求

當你可以直接說「查一下這個頁面為什麼慢」然後 Claude 真的能看到效能數據，工作流程會順暢非常多。

### Figma MCP — 有趣但有限

我花最多時間測試這個，結果好壞參半，但很說明問題。

**運作良好的部分：**
- 擷取設計 token（顏色、字型、間距）
- 基本版面資訊與元件設定
- 簡單的結構層級

**會壞掉的地方：**
- 複雜的漸層邊框 → **完全錯誤**
- 深入調查後發現是 Figma 本身的 export 參數有問題
- MCP 忠實地把錯誤資料傳給 Claude
- 導致 CSS 樣式與設計稿不符

這揭示了一件事：MCP 的品質上限取決於資料來源。簡單的設計轉程式碼可以用，複雜效果還是需要人工細調。

**但潛力確實存在：** 想像一個自訂的 MCP server，在資料傳給 Claude 之前先後處理、修正這些已知問題，或是強制套用設計系統的約束。

### GitHub MCP — 強大但權限要求高

從 Claude 直接存取 repo、建 issue、管理 PR，整合流程很順暢。

**安全性考量：**
所需的 GitHub token 需要完整 repo 存取權，這意味著：
- 讀取所有私人 repo
- 推送程式碼
- 修改設定

個人專案可以接受。公司專案就是個嚴重的安全隱患。這也指出了一個有趣的研究方向：能不能建一個代理 MCP server，實作細粒度的權限控制？

### Atlassian MCP（Jira／Confluence）

建票與查詢都很順暢，token 權限的問題與 GitHub 類似。

**我在探索的有趣用例：** 自動化文件更新。當程式碼變更時，能不能自動更新相關的 Confluence 頁面？整合接口已經有了，工作流程模式還需要打磨。

## 設定方式
```bash
claude mcp add chrome-devtools npx chrome-devtools-mcp@latest
```

```json
{
  "mcpServers": {
    "chrome-devtools": {
      "command": "npx",
      "args": ["chrome-devtools-mcp@latest"]
    },
    "figma": {
      "type": "sse",
      "url": "http://127.0.0.1:3845/sse"
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_xxxxx"
      }
    }
  }
}
```

備註：Figma 需要在桌面應用的偏好設定中啟用「Dev Mode MCP Server」。

## 測試後的心得

MCP 的方向是對的，目前實作還有粗糙的地方，但這些粗糙之處正好揭示了機會。

**優勢：**
- 無縫整合減少上下文切換
- Chrome DevTools 整合確實提升生產力
- 協定本身設計完善且可擴展
- 開啟了全新的工作流程（設計 → 程式碼 → 部署 → 監控，在同一個對話裡完成）

**目前的限制：**
- 第三方資料品質參差不齊（Figma 的漸層問題只是其中一例）
- 權限模型粒度太粗
- 協定層面沒有內建資料過濾或壓縮
- 使用大型資料來源時 token 消耗可觀

## 值得繼續探索的方向

### 1. 自訂 MCP Servers

協定是開放的，這意味著我們可以為特定場景建立專用 server：

- **內部設計系統：** 預處理、驗證過的設計資料
- **API 文件：** 帶有使用範例的情境感知 API 參考
- **測試資料庫：** 根據 schema 生成真實的測試資料
- **Build 系統：** 即時 build 輸出與錯誤分析
- **數據分析平台：** 將開發決策連結到使用者行為數據

關鍵洞察：控制資料管道，就控制了品質。

### 2. 智慧資料過濾

MCP server 可以實作聰明的過濾策略：

- 在送給 Claude 前先摘要大型資料集
- 快取頻繁請求的資料
- 漸進式載入（先送概覽，細節按需求載入）
- 感知 schema 的壓縮

對大型 codebase 或龐大設計系統來說尤其重要。

### 3. 工作流程編排

組合多個 MCP server 可以實現複雜流程：

**範例：設計審查自動化**
1. Figma MCP → 擷取設計變更
2. GitHub MCP → 與現有元件比對
3. 自訂元件庫 MCP → 建議可重用替代方案
4. Atlassian MCP → 生成附有比對結果的設計審查票

**範例：效能退化偵測**
1. GitHub MCP → 偵測程式碼變更
2. Chrome DevTools MCP → 執行效能稽核
3. 自訂指標 MCP → 與基準線比對
4. Slack MCP（假設存在）→ 偵測到退化時通知團隊

### 4. 細粒度安全模型

目前基於 token 的驗證是全有或全無。更細緻的做法：

- 使用 GitHub Apps 取代個人存取 token（可限制範圍）
- 代理 MCP server 實作基於角色的存取控制
- 所有 MCP 操作的稽核日誌
- 臨時性、操作特定的 token

這樣才能讓 MCP 在企業環境中真正可行。

### 5. 資料品質層

針對 Figma 這類有問題的整合：

- 建立後處理 MCP 代理
- 已知問題（如漸層邊框）在傳給 Claude 前就先修正
- 強制套用設計系統約束
- 根據 schema 驗證資料

本質上是在原始 API 和 MCP 之間建立一個「智慧轉接層」。

## 觀察

MCP 最有趣的地方不在於個別整合，而在於**可組合性**。每個 MCP server 都在增加脈絡，Claude 可以跨所有來源進行綜合推理。

這把問題從「AI 能寫程式嗎？」轉移到「AI 需要什麼脈絡才能做出好決策？」

協定還年輕，那些粗糙的地方（資料品質、token 用量、安全性）都是可以解決的工程問題。核心想法——讓 AI 以結構化方式存取開發者使用的工具——感覺是正確的抽象層次。

我最好奇的是：當脈絡不再是限制，新的開發模式會長什麼樣子。

![[Pasted image 20250930142154.png]]

---

*這些筆記會隨著持續實驗而更新。如果你也在探索 MCP，歡迎交流心得。*
