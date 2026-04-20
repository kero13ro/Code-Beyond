---
title: "優化瀏覽器 Reflow 與 Repaint"
description: "深入瀏覽器渲染管線、layout thrashing 模式與效能優化技術，含 DevTools 剖析實例"
tags:
  - performance
  - architecture
---

# 瀏覽器渲染效能：避免 Layout Thrashing

Layout thrashing 會直接殺死效能。以下說明如何辨識它、如何阻止它。

## 瀏覽器渲染管線

瀏覽器顯示網頁時，會依序執行以下步驟：
![[Pasted image 20251023190310.png]]

### 各步驟說明

**1. JavaScript 執行**
瀏覽器執行 JavaScript，可能修改 DOM（Document Object Model）或 CSSOM（CSS Object Model）。

**2. 樣式計算（Style Calculation）**
瀏覽器判斷哪些 CSS 規則套用到各元素，並計算最終樣式，產生 CSSOM。

**3. 排版（Layout / Reflow）**
瀏覽器計算元素的幾何資訊：大小與位置。這是最昂貴的操作之一，因為修改一個元素可能牽連整個 DOM 樹的重算。

**4. 繪製（Paint）**
瀏覽器填入像素，繪製文字、顏色、圖片、邊框、陰影，通常分散在多個 layer 上進行。

**5. 合成（Composite）**
最後，瀏覽器按正確順序合併所有 layer，呈現在螢幕上。

## Reflow 與 Repaint 的差異

**Reflow（Layout）** 在瀏覽器需要重新計算元素位置與大小時發生，計算成本高，因為可能觸發 DOM 樹中大範圍的連鎖重算。

**Repaint** 發生於元素外觀改變、但不影響排版時，例如：
- `background-color`
- `color`
- `visibility`
- `outline`

Reflow 遠比 Repaint 昂貴。Reflow 發生後，通常還會觸發 Repaint，形成雙重效能損耗。

## 什麼是 Layout Thrashing？

Layout thrashing 是指 JavaScript 在單一 frame 內強迫瀏覽器多次重新計算 layout。根本原因是讀寫混雜交替進行。

### 問題程式碼

```javascript
// ❌ 錯誤：Layout Thrashing
// 每次迭代都強迫重算 layout
for (let i = 0; i < elements.length; i++) {
  // 讀取 — 強制同步 layout
  const height = elements[i].offsetHeight;

  // 寫入 — 使 layout 失效
  elements[i].style.height = height + 10 + 'px';
}
```

**發生了什麼：**
1. 讀取 `offsetHeight` 強迫瀏覽器立即計算 layout
2. 修改 `style.height` 使 layout 失效
3. 下一次迭代再讀取，再次強迫 layout 計算
4. 重複 N 次 = N 次強制 layout 計算

**效能衝擊：** 原本只需一次 layout 計算，卻變成幾十、幾百次，導致明顯卡頓。

## 觸發 Layout 的屬性

讀取 `offsetWidth`、`getBoundingClientRect()` 等幾何屬性會強制觸發 layout；修改 `width`、`position`、`font-size` 等幾何屬性則會使 layout 失效。

## 應避免的模式

### 1. 強制同步 Layout

```javascript
// ❌ 錯誤：先寫入再立即讀取
div.style.width = '100px';
const height = div.offsetHeight; // 強制立即計算 layout

// ✅ 正確：先批次讀取，再批次寫入
const height = div.offsetHeight;
div.style.width = '100px';
```

### 2. 迴圈中讀寫交替

```javascript
// ❌ 錯誤：迴圈中讀寫混雜
elements.forEach(el => {
  const width = el.offsetWidth; // 讀取
  el.style.width = width + 10 + 'px'; // 寫入
});

// ✅ 正確：先批次讀取，再批次寫入
// 第一階段：批次讀取
const widths = elements.map(el => el.offsetWidth);

// 第二階段：批次寫入
elements.forEach((el, i) => {
  el.style.width = widths[i] + 10 + 'px';
});
```

### 3. 頻繁存取 Layout 屬性

```javascript
// ❌ 錯誤：多次強制 layout
function updateElements() {
  const h1 = el1.offsetHeight; // layout 計算 #1
  el1.style.height = h1 + 10 + 'px';

  const h2 = el2.offsetHeight; // layout 計算 #2
  el2.style.height = h2 + 10 + 'px';

  const h3 = el3.offsetHeight; // layout 計算 #3
  el3.style.height = h3 + 10 + 'px';
}

// ✅ 正確：只計算一次 layout
function updateElements() {
  // 一次讀取全部
  const h1 = el1.offsetHeight;
  const h2 = el2.offsetHeight;
  const h3 = el3.offsetHeight;

  // 一次寫入全部
  el1.style.height = h1 + 10 + 'px';
  el2.style.height = h2 + 10 + 'px';
  el3.style.height = h3 + 10 + 'px';
}
```

### 4. 過深過大的 DOM 樹

```javascript
// ❌ 效能差：深層巢狀 DOM
<div>
  <div>
    <div>
      <div>
        <!-- 30 層深 -->
      </div>
    </div>
  </div>
</div>

// ✅ 較好：扁平化結構
<div>
  <div><!-- 直接子節點 --></div>
  <div><!-- 減少巢狀 --></div>
</div>
```

Layout 計算成本隨 DOM 大小線性增長，DOM 越大、layout 越貴。

## 高效能最佳做法

### 1. 使用 requestAnimationFrame

```javascript
// ✅ 在正確時機排程 layout 變更
requestAnimationFrame(() => {
  element.style.width = '100px';
  element.style.height = '200px';
});
```

### 2. 用 CSS transform 取代位置屬性

```javascript
// ❌ 觸發 Layout + Paint + Composite
element.style.left = '100px';
element.style.top = '100px';

// ✅ 只觸發 Composite（成本最低）
element.style.transform = 'translate(100px, 100px)';
```

### 3. 優先使用 CSS 動畫

```css
/* ✅ GPU 加速，只觸發 Composite */
.element {
  transition: transform 0.3s ease;
  will-change: transform; /* 提示瀏覽器 */
}

.element:hover {
  transform: scale(1.2);
}
```

### 4. 用 FastDOM 自動批次處理

FastDOM 自動將讀取與寫入操作分批排程：

```javascript
import fastdom from 'fastdom';

// ✅ 自動批次
fastdom.measure(() => {
  const height = element.offsetHeight;

  fastdom.mutate(() => {
    element.style.height = height + 10 + 'px';
  });
});
```

### 5. 快取 Layout 屬性

```javascript
// ❌ 每次 scroll 事件都重新讀取
window.addEventListener('scroll', () => {
  const height = element.offsetHeight; // 每次重算
  // ... 使用 height
});

// ✅ 快取，只在必要時重算
let cachedHeight = element.offsetHeight;

window.addEventListener('resize', () => {
  cachedHeight = element.offsetHeight; // 更新快取
});

window.addEventListener('scroll', () => {
  // 使用快取值
  console.log(cachedHeight);
});
```

### 6. 使用 CSS Containment

```css
/* 提示瀏覽器這個元素的 layout 是獨立的 */
.card {
  contain: layout;
}

/* 適用頻繁改變大小或位置的元素 */
.animated-box {
  contain: layout style paint;
}
```

## 效能成本比較

不同 CSS 屬性的效能成本差異極大：

```
Composite（最快）< Paint < Layout（最慢）
```

### 只觸發 Composite（效能最好）
- `transform`
- `opacity`
- 可在 16ms 預算內完成（60fps）

### 觸發 Paint + Composite（中等成本）
- `color`
- `background-color`
- `box-shadow`
- `border-radius`

### 觸發 Layout + Paint + Composite（成本最高）
- `width`、`height`
- `margin`、`padding`
- `top`、`left`、`bottom`、`right`
- `border-width`
- `font-size`

## 用 Chrome DevTools 除錯

### Performance 面板
1. 開啟 DevTools（F12）
2. 切換到 Performance 分頁
3. 點擊 Record，執行目標互動
4. 停止錄製
5. 尋找：
   - 紫色的「Layout」區塊（reflow 事件）
   - 警告三角形（強制同步 layout）
   - 過長的任務時間

### Rendering 分頁
啟用「Paint flashing」和「Layout Shift Regions」，視覺化 repaint 和 layout 的觸發位置。

### Long Animation Frames API（2025+）
現代瀏覽器透過 Long Animation Frames API 提供 `forcedStyleAndLayoutDuration` 屬性，讓正式環境的 layout 效能問題更容易被偵測：

```javascript
// 監控長動畫 frame
const observer = new PerformanceObserver((list) => {
  for (const entry of list.getEntries()) {
    if (entry.duration > 50) {
      console.warn('偵測到長 frame：', {
        duration: entry.duration,
        forcedLayout: entry.forcedStyleAndLayoutDuration
      });
    }
  }
});

observer.observe({ entryTypes: ['long-animation-frame'] });
```

## 實際案例：修復 Layout Thrashing

### 修改前（Layout Thrashing）

```javascript
function resizeCards() {
  const cards = document.querySelectorAll('.card');

  cards.forEach(card => {
    const width = card.offsetWidth; // 讀取 — 強制 layout
    const height = card.offsetHeight; // 讀取 — 再次強制 layout

    // 寫入 — 使 layout 失效
    card.style.width = width * 1.1 + 'px';
    card.style.height = height * 1.1 + 'px';
  });
}
```

100 張卡片 = 強制 200 次 layout 計算。

### 修改後（優化）

```javascript
function resizeCards() {
  const cards = document.querySelectorAll('.card');

  // 第一階段：批次讀取（只需 1 次 layout 計算）
  const dimensions = Array.from(cards).map(card => ({
    width: card.offsetWidth,
    height: card.offsetHeight
  }));

  // 第二階段：批次寫入（無強制 layout）
  cards.forEach((card, i) => {
    card.style.width = dimensions[i].width * 1.1 + 'px';
    card.style.height = dimensions[i].height * 1.1 + 'px';
  });
}
```

無論幾張卡片，只需 1 次 layout 計算。

## 真正重要的三條規則

1. **先批次讀取，再批次寫入** — 絕不交替
2. **優先用 `transform` 和 `opacity`** — 完全跳過 layout 和 paint
3. **快取 layout 值** — 別在每個 frame 都重讀 `offsetHeight`

這三件事做對，layout thrashing 就不會是問題。

---

## 延伸閱讀

- [Web.dev: Avoid Large, Complex Layouts and Layout Thrashing](https://web.dev/articles/avoid-large-complex-layouts-and-layout-thrashing)
- [MDN: Rendering Performance](https://developer.mozilla.org/en-US/docs/Web/Performance/Rendering)
- [Paul Irish: What Forces Layout/Reflow](https://gist.github.com/paulirish/5d52fb081b3570c81e3a)
- [Chrome DevTools: Performance Features Reference](https://developer.chrome.com/docs/devtools/performance/)
