# 前端不需要 Bundler，直到你開始寫真實的應用

瀏覽器只認識 HTML、CSS 和 ES5 JavaScript。現代前端工程師用 TypeScript、JSX、SCSS、ESM——Bundler 的工作是把這個鴻溝填平，同時把程式碼整理成真正適合生產環境的形式。

## 四個核心職責

**1. 編譯**

瀏覽器看不懂 JSX、TypeScript、SCSS。Webpack、Vite、esbuild 在你打包的時候把這些轉成瀏覽器能執行的語法：

- `tsx` → 標準 JavaScript
- `ts` → 移除型別，降級語法（視 target 設定）
- `scss` → `css`
- 新語法（Optional chaining、nullish coalescing）→ 有 polyfill 的舊語法

**2. 依賴打包**

`node_modules` 裡有成千上萬個檔案，瀏覽器不能直接 `require('lodash')`。Bundler 分析 `import` 依賴圖，把所有模組按照依賴順序合併成靜態資源。

CommonJS、AMD、ESM 的模塊語法不一樣——Bundler 統一輸出成瀏覽器或 Node.js 能理解的格式。

**3. 效能優化**

打包不只是合併，還要讓產出的資源適合線上使用：

- **Tree-shaking**：只打包實際被 `import` 的函數，移除 dead code
- **Code splitting**：按路由切分 chunk，避免首頁載入整個應用
- **Uglify / Minify**：移除空白、縮短變數名，壓縮 bundle size
- **移除 source map**：避免生產環境暴露原始碼

**4. 開發體驗**

Bundler 在開發階段提供的工具讓開發效率大幅提升：

- **HMR（Hot Module Replacement）**：改動單個模組，頁面不刷新就看到結果
- **Dev proxy**：把 `/api` 請求轉發到後端，解決本地開發的 CORS 問題
- **Sourcemap**：讓 Chrome DevTools 顯示原始碼而不是壓縮後的 bundle
- **環境變數注入**：`import.meta.env.VITE_API_URL` 在 build 時替換成實際值

## 為什麼不直接用瀏覽器 ESM

現代瀏覽器支援 `<script type="module">`，理論上可以不用 Bundler 直接跑 ESM。問題在於生產環境：

- 一個頁面可能有幾百個 `import`，HTTP/2 多工再好也比不上一個合併的 bundle
- Tree-shaking 需要靜態分析，瀏覽器執行時做不到
- 第三方套件不一定是純 ESM，需要轉換

Vite 在開發時用瀏覽器 ESM 達到接近零等待的 HMR，但 build 時仍然用 Rollup 打包——這是目前的最佳平衡點。

Bundler 不是選配，是現代前端工程的基礎設施。選哪個工具是實現細節；理解它在做什麼，是你 debug build 問題的前提。
