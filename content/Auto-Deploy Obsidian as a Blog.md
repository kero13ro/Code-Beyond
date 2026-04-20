---
title: "將 Obsidian 自動部署為部落格"
draft: true
tags:
  - tools
---

我一直有在 Notion 寫 blog 的習慣。編輯後即時同步很方便，但缺點也不少：持續同步造成開啟或更新檔案時明顯延遲，客製化選項有限，也無法整合其他 AI 工具。

詳細比較請見 [[Obsidian vs Notion]]

最近我開始探索 Obsidian——它和 Notion 最大的不同，在於本地優先、以 markdown 為核心。

要用 Obsidian 發布 blog，官方提供了 Publish 服務，每月 $10 美元：
https://obsidian.md/publish

不過身為工程師，我想先研究免費部署的方案。

Obsidian 官方文件推薦使用 Quartz 來部署靜態網站。它類似 Docusaurus，能將 markdown 檔案轉換成多頁應用程式（MPA）靜態網站，支援佈景主題、元件設定與 SEO 配置，非常適合文件導向的站台。
https://docusaurus.io/

Quartz 最吸引我的地方，是原生支援 Obsidian 的核心功能：雙向連結、圖譜視圖，以及 vault 的目錄結構。
https://quartz.jzhao.xyz/

使用 Quartz 的流程相當順暢：只要在專案的 `content` 資料夾中編輯 markdown 檔案，推送至 GitHub，CI/CD pipeline 就會自動部署：
https://kero13ro.github.io/Code-Beyond/Obsidian-vs-Notion

但有一個不便之處：我得同時維護兩個 Obsidian 視窗——一個給 blog 文章，一個給個人筆記——以及兩個 Claude Code 視窗分別編輯不同資料夾。

解法是：只從單一 Obsidian vault 自動部署，只需將 `/blog` 資料夾同步至 GitHub Pages 即可。

## 用 Raycast 實現自動部署

我寫了一個 shell script，流程如下：

1. 同步檔案：將 `/blog` 的內容複製到 Quartz 專案的 `/content` 資料夾
2. 檢查是否有變更
3. Commit 並推送至遠端 repository

將 script 加入 Raycast 後，只需一個指令就能即時更新 blog：
![[Raycast 2025-10-10 at 16.24.11.png]]
