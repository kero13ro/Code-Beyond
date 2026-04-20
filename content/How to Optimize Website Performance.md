---
title: "如何優化網站效能"
description: "前端效能優化完整指南，涵蓋程式碼分割、資源優先級、快取策略與感知效能"
tags:
  - performance
  - architecture
---

Frontend performance comes down to one thing: how fast your users see results. 在策略規劃與架構決策完成後（見 [[What Excellent Product Developers Know]]），這篇文章聚焦在**技術實作層**——真正的效能增益就發生在這裡。

---

## 背景：效能優化的三個層次

效能優化在三個相互連動的層次上運作：

1. **策略層（功能必要性）：** 這個功能真的需要嗎？隱性成本是什麼？
2. **架構層（系統設計）：** 選哪種渲染策略（SSG/SSR/CSR）？CDN 快取？部署區域？
3. **技術層（前端實作）：** 程式碼分割、bundling、快取、執行期優化 ← **本文範圍**

第 1、2 層的背景可參考「What Excellent Product Developers Know」。

---

## A. 減少初始載入量：聰明的 Lazy Loading

效能優化的基礎是「只在需要時載入需要的東西」。

**以路由為單位的 Code Splitting**
- 按路由切割 bundle，每個頁面有獨立的 bundle
- 使用 lazy-loaded routes，導航時才載入
- 搭配 dynamic imports 做元件層級的 code splitting

**按需載入**
- 使用者捲動時才載入內容，到達底部才抓取下一批資源
- 分頁或無限捲動都要把效能納入設計考量

**資源優先級控制**
```html
<!-- 背景圖片給低優先級 -->
<img src="background.jpg" fetchpriority="low" />

<!-- 捲動區域以下的圖片延遲載入 -->
<img src="image.jpg" loading="lazy" />

<!-- 預載關鍵資源 -->
<link rel="preload" href="critical.js" />
```

響應式圖片的詳細做法，參考 [Web.dev 響應式圖片指南](https://web.dev/articles/responsive-images)。

---

## B. 智慧的 Bundling 策略

**靜態內容網站：**
- 使用 SSG 預渲染頁面
- 實作 Service Workers 與 PWA 模式，支援離線功能與資源快取

**縮小 Bundle 體積：**
- **Tree Shaking：** 移除未使用的程式碼與 CSS
  - 遷移至 Tailwind CSS 消除閒置樣式
  - 確認 bundler（Webpack、Vite）已啟用 tree-shaking
- **壓縮：** 壓縮 JavaScript、CSS、HTML
- **Source Maps：** 正式環境移除 source maps
- **Chunk 大小限制：** 設定合適的 chunk 大小閾值，平衡並行載入與快取效益

---

## C. JavaScript 快取與記憶體管理

效能不只是 bundling 的問題，執行期效率同樣關鍵。

**減少不必要的計算**
- 善用 Vue 3 的 `computed` 搭配響應式依賴
- 頻繁切換的元素優先用 `v-show` 取代 `v-if`
- 使用 `KeepAlive` 保存元件狀態
- 透過 Pinia 或類似的狀態管理快取計算結果

**記憶體優化**
- 對不可變資料使用 `Object.freeze()`，讓編譯器得以優化
- 使用事件委派，避免對每個元素單獨附加 listener
- 適當釋放不再使用的 closure 與參考，防止記憶體洩漏
- 在效能剖析時監控垃圾回收行為

**處理大量資料**
- 面對海量資料時，注意時間複雜度
- 將大問題分解為更小、可快取的子問題
- 頻繁插入／刪除操作改用 **Map** 取代一般物件——Map 在這類場景有更好的效能特性

**卸載繁重運算**
- 使用 **Web Workers** 把 CPU 密集型任務移到獨立執行緒
- 避免阻塞主執行緒，保持 UI 響應

---

## D. 圖片優化

圖片通常佔頁面總重的 50–80%，這裡的優化回報最直接。

**虛擬捲動**
- 大型資料清單只渲染視窗內可見的項目，可使用 [vue-virtual-scroller](https://github.com/Akryum/vue-virtual-scroller)
- 防止 DOM 膨脹，記憶體用量不隨清單大小增長

**響應式圖片**
- 用 `srcset` 根據設備提供適當大小的圖片：
  ```html
  <img srcset="480w.jpg 480w, 800w.jpg 800w, 1200w.jpg 1200w"
       alt="響應式圖片範例" />
  ```
- 根據[裝置像素比](https://web.dev/articles/codelab-density-descriptors)提供不同解析度

**格式選擇**
- **SVG：** 圖示與向量圖優先用 SVG，可縮放且通常比 PNG 小
- **WebP：** 相片類內容使用 WebP，並保留 PNG 作為 fallback
- **壓縮：** 使用 [TinyPNG](https://tinypng.com/) 等無損壓縮工具合併相同色塊

---

## E. 使用者體驗優化：感知效能

有時候最快的頁面，不一定是「感覺」最快的頁面。策略性的 UX 設計能顯著改變感知效能。

**漸進式圖片載入**
- 先載入模糊縮圖，再逐步呈現高解析度版本
- 讓使用者感覺載入速度更快

**Skeleton Screen**
- 內容載入中時顯示骨架佔位 UI
- 減少版面位移與視覺跳動，讓過渡更流暢
- 改善 CLS（Cumulative Layout Shift）指標

**資源預載**
- 預載下一頁可能需要的關鍵資源
- 次要資源使用 `<link rel="prefetch">`

---

## F. 部署與快取策略

效能不止於部署，智慧的快取架構同樣不可或缺。

**多層快取**
- **CDN 快取：** 在全球邊緣節點快取靜態資源
- **Redis／記憶體快取：** 快取常用資料與計算結果
- **伺服器端快取：** 設定適當 TTL 的 HTTP 快取標頭
- 深入理解可參考 [A Crash Course in Caching](https://blog.bytebytego.com/p/a-crash-course-in-caching-part-1)

**快取失效**
- 靜態資源使用內容雜湊，支援激進的長期快取
- 更新資源時實作適當的 cache busting

---

## G. 後端優化：減少請求量

前端效能高度依賴後端效率。

**合併請求**
- 將多個 API 呼叫合併為單一請求
- 使用 GraphQL 精確抓取所需資料，消除 over-fetching

**最小化 Cookie 開銷**
- 縮減 cookie 大小——大型 cookie 每次請求都會攜帶
- 適當使用 sessionStorage 或 localStorage 儲存客戶端資料
- 按網域隔離 cookie，減少不必要的資料傳輸

**資料精簡**
- API endpoint 只回傳必要欄位
- 大型結果集改用分頁，不要一次回傳所有資料
- 壓縮 response payload

---

## 小結

None of this matters if you're shipping the wrong features. Start with strategy.

---

## 推薦資源

- [Web.dev Performance Guide](https://web.dev/performance)
- [Web Vitals Metrics](https://web.dev/vitals)
- [MDN Responsive Images](https://developer.mozilla.org/en-US/docs/Learn/HTML/Multimedia_and_embedding/Responsive_images)
- [Virtual Scrolling Implementation](https://dev.to/adamklein/build-your-own-virtual-scroll-part-i-11ib)
