---
title: "開發 Chrome Extension：從想法到 Chrome Web Store"
description: "完整記錄從開發到上架一個 Chrome Extension 的過程——整合 PDF／YouTube 內容與 AI 服務"
tags:
  - tools
  - architecture
---

## 問題的起點

十年前準備國家考試時，我花了無數小時收集 PDF 練習卷、手寫筆記、整理考材。整個過程既繁瑣又耗時。
https://wwwq.moex.gov.tw/exam/wHandExamQandA_File.ashx?t=Q&code=114080&c=236&s=1102&q=1

如果有一個工具能自動把 PDF 上傳到 AI 頁面，即時生成模擬答案，那不是很好？

## 解決方案

我建了 [chrome-pdf-ai](https://github.com/kero13ro/chrome-pdf-ai)，一個 Chrome Extension，把 PDF 內容傳給 Claude AI 或 ChatGPT 來生成考題模擬答案。

### 核心工作流程

1. 點擊 Extension 按鈕
2. 下載 PDF 至剪貼簿
3. 跳轉至 Claude／ChatGPT 頁面
4. 自動貼上 PDF 內容並附上自訂 prompt

我加了設定頁面讓使用者自訂 prompt 和切換 AI 服務。測試後發現 ChatGPT 在研究導向的題目上表現更好。

## 技術挑戰

### 圖示設計
生成好看的圖示比想像中困難。大多數專業工具需要付費，免費選項看起來很業餘。測試過各種 AI 生成器（它們常常誤解需求）後，我找到了 [icon.kitchen](https://icon.kitchen/)——簡潔、乾淨，非常適合 Chrome Extension。

### 上架的坑
Chrome Web Store 有幾個意外的限制：
- **Extension 名稱送審後無法修改**——我的變成了「Test Bro - Web Test Assistant」
- 行銷截圖必須剛好是 1280×800px
- 每次上傳都需要手動 ZIP 壓縮

我用 Makefile 自動化打包流程，排除截圖與本地設定檔，大幅加快迭代速度。

## 開發時程

使用 Claude Code，大約 3 小時後達到 token 上限：
- 約 2 小時：核心功能
- 約 1 小時：準備上架與送審

**重要心得**：非程式碼任務（文件、行銷文案）用 ChatGPT，省下 Claude Code 的 token。

## 上架結果與後續計畫

Chrome Web Store 審核在第三天通過了！
https://chromewebstore.google.com/detail/ngknkcnhfkfjhbajoeoekiefmhnjjlpl
![[Pasted image 20251010164040.png]]

### 後續規劃
- 自動化截圖生成工具（正確的尺寸與格式）
- 擴展 YouTube 字幕功能
- 熱重載開發設定（目前需要在 `chrome://extensions/` 手動重新整理）

---
## 擴展到 YouTube

PDF 功能成功上線後，我意識到同樣的工作流程可以套用到影片內容。很多教學資源在 YouTube 上，但要提取關鍵資訊就得看完整部影片或手動做筆記。

我把 Extension 擴展成支援 YouTube 字幕擷取：

### YouTube 工作流程

1. 進入任何 YouTube 影片
2. 點擊 Extension 按鈕
3. Extension 擷取影片字幕
4. 連同自訂 prompt 傳給 Claude／ChatGPT
5. AI 即時生成摘要、問答或學習筆記

### 技術實作

**Extension 架構：**

Extension 遵循 Chrome 的 Manifest V3 架構，關注點分離清楚：

```
manifest.json
├── background.js          # Service worker：負責訊息協調
├── content-pdf.js         # Content script：PDF 頁面偵測與擷取
├── content-youtube.js     # Content script：YouTube 字幕擷取
├── popup/                 # Extension popup UI
│   ├── popup.html
│   └── popup.js           # 偵測當前 tab 的內容類型
└── settings/              # API key 與 prompt 的設定頁面
    ├── settings.html
    └── settings.js
```

**Manifest V3 關鍵權限：**

```json
{
  "permissions": ["activeTab", "scripting", "storage", "clipboardWrite"],
  "host_permissions": ["https://www.youtube.com/*", "https://*.moex.gov.tw/*"],
  "content_scripts": [
    {
      "matches": ["https://www.youtube.com/watch*"],
      "js": ["content-youtube.js"]
    }
  ]
}
```

設計決策：
- 使用 `activeTab` 而非廣泛的 `<all_urls>`，縮小權限範圍——使用者只在點擊 Extension 時才授予存取權
- `clipboardWrite` 讓自動貼上工作流程成立，不需要對 AI 服務網站要求完整頁面存取
- Content script 僅限於特定 URL 模式，而非全域注入

**YouTube 字幕擷取：**

YouTube 把字幕資料存在 player 的 `ytInitialPlayerResponse` 物件中。Content script 透過以下方式存取：

```javascript
// 從 YouTube 的嵌入 player 資料中擷取
const playerResponse = document.querySelector('script')
  ?.textContent.match(/ytInitialPlayerResponse\s*=\s*({.+?});/)?.[1];

const captions = JSON.parse(playerResponse)
  ?.captions?.playerCaptionsTracklistRenderer?.captionTracks;

// 取得實際字幕 XML 並解析
const transcriptUrl = captions?.[0]?.baseUrl;
const response = await fetch(transcriptUrl);
const xml = await response.text();
```

這個方法不需要 YouTube API key 或 OAuth——讀取的是 YouTube 自己的 player 使用的相同資料。

**API Key 安全性考量：**

API key 存在 `chrome.storage.local`，它是按 Extension 沙盒化的，網頁無法存取。但這不是加密——key 在 DevTools 中可見。對服務大量使用者的生產環境 Extension 來說，後端代理會更安全。對這個個人工具的使用情境，本地儲存是可接受的取捨。

**Build 自動化（Makefile）：**

```makefile
EXTENSION_NAME = chrome-pdf-ai
EXCLUDE = screenshots/ .git/ .env *.md Makefile

build:
	@rm -f $(EXTENSION_NAME).zip
	@zip -r $(EXTENSION_NAME).zip . $(addprefix -x ,$(EXCLUDE))
	@echo "Built $(EXTENSION_NAME).zip"
```

Extension 現在有兩個用途：從 PDF 準備考試，以及從影片學習。名稱也演進為 **「[YouTube & PDF to AI Assistant](https://chromewebstore.google.com/detail/youtube-pdf-to-ai-assista/aoladgbnahppfdlneiocoapeikgflgmm)」**。

![[Pasted image 20251018180327.png]]
