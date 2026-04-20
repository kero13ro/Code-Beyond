---
title: "Web 開發術語表"
description: "前端術語全面詞彙表——動畫、3D、版面配置、UI 元件、視覺效果與互動模式，附實用 AI 提示範例"
tags:
  - career
  - tools
---

# Web 開發術語表：開發者視覺辭典

## 為什麼這很重要

身為資深前端開發者，我們每天與設計師、產品經理和跨國團隊協作。使用精確的英文術語不只是翻譯問題——更關乎清晰的溝通與高效的協作。

本指南聚焦於設計交付、Code Review 和技術討論中常見的術語。每個術語都附有情境說明，幫助你理解它的含義以及實際使用方式。

## Animation 術語

| 英文術語 | 情境翻譯 | 說明 |
| -------------------- | ---------- | ----------------------------------------------------------------------------------- |
| **Confetti** | 彩帶動畫 | 慶祝用的彩色粒子飄落動畫，常用於成功狀態 |
| **Blob** | 泡泡動畫/流體動畫 | 有機的變形形狀，用於現代 UI 背景 |
| **Morph** | 變形動畫 | 從一個形狀平滑轉換到另一個形狀 |
| **Sprite** | 影格動畫/圖片序列 | 利用 Sprite Sheet 的連續圖片製作動畫 |
| **Tween** | 補間動畫 | "in-between" 的縮寫，自動產生關鍵影格之間的過渡影格 |
| **Ken Burns Effect** | 平移和縮放 | 靜態圖片上的緩慢平移與縮放效果 |
| **Parallax** | 視差滾動 | 背景移動速度慢於前景，製造深度感 |
| **Easing** | 緩動函數 | 動畫時間函數（ease-in、ease-out 等） |
| **Keyframe** | 關鍵影格 | 動畫時間軸上的特定時間點 |
| **Ripple** | 水波紋效果 | Material Design 的觸控回饋動畫 |
| **Skeleton** | 骨架屏/加載佔位 | 顯示內容結構的載入佔位符 |
| **Fade** | 淡入淡出 | 透明度過渡效果 |
| **Slide** | 滑入滑出 | 基於位置的過渡 |
| **Bounce** | 彈跳效果 | 帶有過沖的彈簧式動畫 |
| **Stagger** | 錯開動畫 | 帶有延遲的連續動畫 |
| **Cubic Bezier** | 貝茲曲線 | 由控制點定義的自訂緩動曲線 |
| **Spring Animation** | 彈簧動畫 | 具有自然動量的物理基礎動畫 |
| **FLIP** | FLIP 動畫 | First、Last、Invert、Play——高效能動畫技術 |
| **Motion Path** | 運動路徑 | 沿著定義路徑或曲線的動畫 |
| **Lottie** | Lottie 動畫 | 來自 After Effects 的 JSON 動畫格式 |
| **Inertia** | 慣性滾動 | 使用者停止拖曳後的持續運動 |
| **Overshoot** | 過沖效果 | 動畫短暫超出目標值後才穩定 |

## 3D 與 WebGL 術語

| 英文術語 | 情境翻譯 | 說明 |
| ------------------------- | ---------- | ------------------------------------------------------ |
| **Scene** | 場景 | 容納所有 3D 物件、光源和相機的容器 |
| **Camera** | 相機/視角 | 渲染 3D 場景的觀察點 |
| **Renderer** | 渲染器 | 將 3D 場景繪製到 Canvas 的引擎 |
| **Mesh** | 網格模型 | 結合幾何形狀與材質的 3D 物件 |
| **Geometry** | 幾何體 | 3D 物件的形狀與結構 |
| **Material** | 材質 | 表面屬性（顏色、貼圖、反射率） |
| **Texture** | 貼圖/紋理 | 映射到 3D 表面的圖片 |
| **Light** | 光源 | 3D 場景中的照明（環境光、平行光、點光源） |
| **Polygon** | 多邊形 | 構成 3D 模型的平面 |
| **Vertex** | 頂點 | 3D 空間中的點，即多邊形的角 |
| **Normal** | 法線 | 垂直於表面的向量，定義光照方式 |
| **UV Mapping** | UV 映射 | 2D 貼圖如何包裹到 3D 表面 |
| **Shader** | 著色器 | 計算像素顏色的程式 |
| **Ray Casting** | 射線投射 | 偵測物件交叉的技術 |
| **Bounding Box** | 包圍盒 | 包圍物件的隱形方框，用於碰撞偵測 |
| **LOD (Level of Detail)** | 細節層級 | 為遠處物件使用較低品質的模型 |
| **Culling** | 剔除 | 不渲染相機視野外的物件 |
| **Frustum** | 視錐體 | 相機在 3D 空間中的可見體積 |
| **Instancing** | 實例化 | 高效率地渲染大量相同物件的複本 |

## Layout 術語

| 英文術語 | 情境翻譯 | 說明 |
| ------------------ | ---------- | ----------------------------------------- |
| **Masonry** | 瀑布流布局 | Pinterest 風格的不等高網格 |
| **Grid** | 網格布局 | CSS Grid 版面系統 |
| **Flexbox** | 彈性布局 | CSS Flexible Box 版面 |
| **Sticky** | 吸頂/固定 | 捲動經過時元素會固定停留 |
| **Fixed** | 固定定位 | 固定於視窗，不隨頁面捲動 |
| **Absolute** | 絕對定位 | 相對於父元素定位 |
| **Relative** | 相對定位 | 相對於正常位置定位 |
| **Z-index** | 層級/堆疊順序 | 重疊元素的堆疊順序 |
| **Viewport** | 可視區域 | 網頁的可見區域 |
| **Gutter** | 間距/欄間距 | 網格欄位之間的空隙 |
| **Breakpoint** | 響應式斷點 | 版面改變的螢幕尺寸 |
| **Container** | 容器/包裹器 | 包裹內容的外層元素 |
| **Hero Section** | 首屏大圖區 | 頁面頂部顯眼的大型區塊 |
| **Above the Fold** | 首屏可見區 | 不需捲動即可看到的內容 |
| **Sidebar** | 側邊欄 | 用於導覽或內容的側邊面板 |

## UI 元件

| 英文術語 | 情境翻譯 | 說明 |
| -------------- | ---------- | ----------------------------------------- |
| **Carousel** | 輪播/走馬燈 | 旋轉式內容展示 |
| **Accordion** | 手風琴/摺疊面板 | 可展開/收合的內容區段 |
| **Breadcrumb** | 麵包屑導航 | 顯示目前位置的導覽路徑 |
| **Tooltip** | 提示框/氣泡提示 | 滑鼠懸停時顯示的資訊框 |
| **Modal** | 模態框/彈窗 | 需要使用者互動的覆蓋式對話框 |
| **Drawer** | 抽屜/側滑菜單 | 從螢幕邊緣滑出的面板 |
| **Toast** | 消息提示/輕提示 | 短暫的通知訊息 |
| **Snackbar** | 底部提示條 | 底部通知列（Material Design） |
| **Badge** | 徽標/標記 | 小型的計數或狀態指示器 |
| **Chip** | 標籤/膠囊 | 用於標籤或篩選的緊湊元素 |
| **Avatar** | 頭像 | 使用者個人資料圖片 |
| **Dropdown** | 下拉選單 | 可展開的選擇選單 |
| **Toggle** | 開關/切換按鈕 | 開/關切換控制項 |
| **Slider** | 滑動條 | 範圍輸入控制項 |
| **Stepper** | 步驟條/計數器 | 多步驟流程指示器 |
| **Pagination** | 分頁器 | 頁面導覽控制項 |
| **Tab** | 標籤頁/選項卡 | 內容組織用的頁籤 |
| **Divider** | 分隔線 | 內容之間的視覺分隔符 |

## 視覺效果

| 英文術語 | 情境翻譯 | 說明 |
| --------------------- | ---------- | ---------------------------------------------- |
| **Backdrop** | 背景遮罩/模糊遮罩 | Modal 後方的模糊/暗化背景 |
| **Vignette** | 暈影效果/邊緣暗角 | 圖片邊緣變暗的效果 |
| **Blur** | 模糊效果 | 高斯或其他模糊效果 |
| **Gradient** | 漸層/漸變 | 顏色過渡效果 |
| **Shadow** | 陰影/投影 | Drop shadow 或 Box shadow |
| **Glassmorphism** | 毛玻璃效果 | 磨砂玻璃視覺風格 |
| **Neumorphism** | 新擬物風格 | 帶有細膩陰影的柔和 UI |
| **Overlay** | 遮罩層 | 內容上方的半透明層 |
| **Mask** | 遮罩/蒙版 | 裁切內容的形狀 |
| **Clip Path** | 裁切路徑 | 裁切元素的 CSS 屬性 |
| **Filter** | 濾鏡 | CSS 濾鏡（brightness、contrast 等） |
| **Opacity** | 透明度 | 元素的透明程度 |
| **Reflection** | 倒影/鏡像 | 元素的鏡射效果 |
| **Bloom** | 泛光效果 | 亮部周圍的發光效果 |
| **Depth of Field** | 景深效果 | 根據距焦點遠近產生的模糊 |
| **Motion Blur** | 動態模糊 | 移動物件上的模糊，增加真實感 |
| **Ambient Occlusion** | 環境光遮蔽 | 縫隙與角落的陰影 |
| **Post-processing** | 後處理效果 | 主要渲染後套用的效果 |
| **Normal Map** | 法線貼圖 | 不需增加幾何形狀即可新增表面細節的貼圖 |

## Canvas 與圖形術語

| 英文術語 | 情境翻譯 | 說明 |
| ----------------------- | ---------- | ------------------------------------- |
| **Canvas** | 畫布 | 用於 2D/3D 圖形的 HTML 元素 |
| **Context** | 上下文 | 在 Canvas 上繪圖的 API（2d、webgl） |
| **Path** | 路徑 | 由連接的點與曲線組成的序列 |
| **Stroke** | 描邊 | 形狀的輪廓線 |
| **Fill** | 填充 | 形狀內部的顏色 |
| **Composite Operation** | 合成操作 | 重疊形狀的混合方式 |
| **Image Data** | 圖像數據 | Canvas 的原始像素資料 |
| **SVG** | 可縮放向量圖形 | 基於 XML 的向量圖片格式 |
| **Viewbox** | 視圖框 | SVG 座標系統定義 |
| **Path Data** | 路徑數據 | 定義 SVG 形狀的指令 |
| **Transform** | 變換 | 位移、旋轉、縮放操作 |
| **Buffer** | 緩衝區 | WebGL 的資料儲存空間 |
| **Attribute** | 屬性 | Shader 中的逐頂點資料 |
| **Uniform** | 統一變量 | Shader 的全域變數 |
| **Fragment Shader** | 片段著色器 | 計算像素顏色的 Shader |
| **Vertex Shader** | 頂點著色器 | 定位頂點的 Shader |
| **Texture Unit** | 紋理單元 | Shader 中載入貼圖的插槽 |

## 互動術語

| 英文術語 | 情境翻譯 | 說明 |
| ------------------- | ---------- | ------------------------------------ |
| **Drag and Drop** | 拖放/拖拽 | 移動項目的滑鼠/觸控手勢 |
| **Swipe** | 滑動/滑移 | 在螢幕上滑動的觸控手勢 |
| **Pinch** | 捏合縮放 | 雙指縮放手勢 |
| **Hover** | 懸浮/滑過 | 滑鼠移至元素上方的狀態 |
| **Focus** | 焦點狀態 | 作用中的輸入/鍵盤導覽 |
| **Active** | 激活/按下狀態 | 按鈕被按下的狀態 |
| **Disabled** | 禁用/不可用 | 無法互動的狀態 |
| **Loading** | 加載中/載入中 | 內容擷取中的狀態 |
| **Throttle** | 節流 | 限制函式執行頻率 |
| **Debounce** | 防抖/去抖 | 延遲函式執行直到停止觸發 |
| **Lazy Load** | 延遲加載 | 需要時才載入內容 |
| **Infinite Scroll** | 無限滾動 | 持續載入內容 |
| **Pull to Refresh** | 下拉刷新 | 重新載入內容的行動裝置手勢 |
| **Click** | 點擊 | 滑鼠點擊事件 |
| **Tap** | 點按/輕觸 | 觸控螢幕點擊 |

## 響應式設計

| 英文術語 | 情境翻譯 | 說明 |
| ----------------- | ---------- | -------------------------------------- |
| **Mobile-first** | 移動優先 | 先為行動裝置設計，再向上擴展 |
| **Desktop-first** | 桌面優先 | 先為桌面設計，再向下縮減 |
| **Media Query** | 媒體查詢 | 針對不同螢幕尺寸的 CSS 規則 |
| **Fluid Layout** | 流式布局 | 按比例縮放的版面 |
| **Adaptive** | 自適應 | 針對特定斷點的固定版面 |
| **Responsive** | 響應式 | 適應任何螢幕尺寸的彈性版面 |
| **Retina** | 高清屏/視網膜屏 | 高 DPI 顯示器 |

## 善用術語的技巧

### 在 AI 設計工具中提示（Figma AI、Midjourney、v0 等）

身為資深開發者，我們越來越常使用 AI 設計工具。使用精確的英文術語能獲得更好的結果：

✅ **好的做法**：「Create a hero section with **parallax effect** and **glassmorphism** cards」
- AI 能精確理解你想要的視覺風格
- 結果符合現代設計趨勢

❌ **不佳的做法**：「做一個有那種滾動動畫和透明效果的區塊」
- 模糊的描述導致不一致的結果
- 可能遺漏特定的設計模式

✅ **好的做法**：「Add **neumorphism** style to buttons with **subtle shadow** and **backdrop blur**」
- 精確術語 = 可預期的輸出
- 更容易迭代和精修

### 在 AI 程式工具中提示（Claude、ChatGPT、Copilot、Cursor 等）

精確的術語有助於 AI 生成更好的程式碼：

✅ **好的做法**：「Implement a **carousel** with **lazy loading**, **swipe gestures**, and **throttled** scroll events」
- AI 生成完整、生產可用的程式碼
- 包含效能優化

❌ **不佳的做法**：「做一個圖片輪播可以滑動的」
- 可能得到缺乏優化的基本實作
- 缺少無障礙功能

✅ **好的做法**：「Add **debounced** search with **skeleton** loading state and **infinite scroll**」
- AI 理解效能模式
- 包含適當的載入狀態

### 搜尋技術文件

使用英文術語能解鎖全球資源：

✅ **好的做法**：「CSS **masonry layout** grid」
- 存取 MDN、CSS-Tricks、Codepen 範例
- 最新技術與瀏覽器支援資訊

❌ **受限的做法**：「CSS 瀑布流」
- 主要是中文結果
- 可能錯過最新解決方案

✅ **好的做法**：「React **virtualized list** with **lazy load**」
- 找到 react-window、react-virtualized 函式庫
- 來自核心團隊的效能最佳實踐

### Code Review 評論

使用標準術語能提升團隊溝通品質：

✅ **專業**：
```
"Consider using **debounce** instead of **throttle** here—
we want to wait for user input to stop, not limit frequency"
```

✅ **具體**：
```
"The **z-index** of this **modal** should be higher than
the **sticky** header (currently 1000)"
```

✅ **清晰**：
```
"Add **staggered** animation to list items for better
perceived performance during **lazy load**"
```

### 設計交付協作

與設計師協作時：

**動畫規格：**
- 「**Tween** opacity from 0 to 1 in 300ms with **ease-out**」
- 「Add **parallax** with 0.5 speed ratio to background」
- 「**Stagger** card animations by 50ms」

**版面需求：**
- 「Make header **sticky** at scroll position 100px」
- 「Use **flexbox** with **gap** instead of margin」
- 「Set **z-index** layering: modal (1000) > sticky nav (100)」

**元件行為：**
- 「Add **ripple effect** on button tap with 300ms duration」
- 「Implement **pull-to-refresh** with haptic feedback」
- 「Use **skeleton** screen during initial load」

### 資深開發者的視角

為什麼精確術語在資深層級更重要：

1. **架構討論**：「We need **lazy loading** with **intersection observer** for performance」比描述行為清晰得多

2. **技術債**：「This uses **throttle** but should use **debounce**」立即點出問題所在

3. **效能 Review**：「Replace **carousel** with **virtualized list** for 1000+ items」展現對規模的理解

4. **指導初階開發者**：教導正確術語有助於他們搜尋文件和理解最佳實踐

5. **跨部門會議**：PM 和設計師比起技術解釋，更能理解「**mobile-first responsive**」

## 總結

學習這些術語不只是翻譯——而是理解其背後的概念。當你同時掌握英文術語及其實際含義，你就能：

1. **與國際團隊更有效溝通**
2. **更高效地搜尋技術文件**
3. **更精確地使用 AI 工具**
4. **更快速地 Review 程式碼和理解開源專案**
5. **以清晰的方式主導技術討論**
6. **更有效地指導初階開發者**

記住：熟悉英文術語，能為你開啟全球資源、更好的 AI 互動，以及更清晰的團隊溝通。
