---
title: "瀏覽器引擎深度解析"
description: "V8 引擎內部機制、Event Loop 運作、記憶體管理與垃圾回收的深入探索——定義資深前端工程師的核心知識"
draft: true
tags:
  - performance
  - architecture
---

# 瀏覽器引擎深度解析：V8、Event Loop 與記憶體管理

大多數開發者不理解瀏覽器實際上如何執行程式碼。這件事對效能很重要——理解引擎能告訴你為什麼 `delete obj.key` 很慢、為什麼單型態函式更快、為什麼 transform 動畫不會阻塞主執行緒。

## 1. V8 引擎架構

### 解析管線
- **Scanner** → 原始碼 tokenization
- **Parser** → AST（抽象語法樹）生成
- **Ignition** → Bytecode 直譯器（基準執行）
- **TurboFan** → 優化 JIT 編譯器（熱點程式碼路徑）
- **Sparkplug** → 快速非優化編譯器（銜接 Ignition → TurboFan 的間隙）

### 物件形狀對效能的實際意義
- Hidden Classes（Maps）— V8 為每個物件分配一個形狀；改變它，V8 就會去優化
- Inline Caches（ICs）— 為什麼一致的物件形狀對 call site 優化很重要
- 去優化觸發條件：動態新增屬性、型別混淆、megamorphic call site
- 為什麼 `delete obj.key` 很慢：它改變了 hidden class，破壞了 IC

### 程式碼範例
- 基準測試：單型態 vs 多型態函式呼叫
- Hidden class 轉換視覺化
- `Object.create(null)` vs `{}` 在 V8 內部的差異

## 2. Event Loop 機制

### 超越基礎
大多數文章只解釋「microtask 在 macrotask 之前」，這裡再往深一層：

- **Task queue 有優先順序**：渲染任務 > 使用者互動 > 網路 > timer
- **渲染管線整合**：requestAnimationFrame 位於 microtask flush 與 paint 之間
- **queueMicrotask vs Promise.resolve().then()**：細微的排程差異
- **Starvation 情境**：無限 microtask 迴圈會完全阻塞渲染

### 實際 Debug
- 用 `performance.mark()` 和 `performance.measure()` 追蹤 event loop 延遲
- Long Animation Frames API（LoAF）辨識 jank 來源
- `scheduler.postTask()` API 實現優先順序排程
- `scheduler.yield()` 實現協作式多工

### 程式碼範例
- Task 排程優先順序示範
- requestIdleCallback vs requestAnimationFrame 時序
- 用 yield 點建立不阻塞的批次處理器

## 3. 記憶體管理與垃圾回收

### V8 的分代 GC
- **Young Generation（Scavenger）**：Semi-space 複製 GC，快速但容量有限（約 1–8MB）
- **Old Generation（Mark-Sweep-Compact）**：增量標記、並行清掃、壓縮
- **晉升**：存活過 2 次 scavenge 的物件移入 old generation
- **Orinoco**：V8 的並行、增量、concurrent GC 架構

### 前端常見記憶體洩漏模式
1. **分離的 DOM tree**：Event listener 持有已移除元素的參考
2. **Closure 洩漏**：內部函式無意間捕獲大型外部 scope
3. **Timer 洩漏**：SPA 路由切換時 `setInterval` 沒有清理
4. **WeakRef／FinalizationRegistry**：快取模式的現代解法
5. **ArrayBuffer／TypedArray**：Canvas／WebGL 的二進位資料處理

### 用 Chrome DevTools Debug
- Memory 面板：Heap 快照、分配時間線、分配取樣
- Performance 面板：GC 事件、強制垃圾回收
- 辨識保留樹與 retainer 路徑
- 比對快照找出增長中的物件計數

### 程式碼範例
- 以程式偵測分離的 DOM 節點
- 基於 WeakRef 的快取實作
- 記憶體高效的大型列表渲染（虛擬捲動內部機制）

## 4. Web Workers 與主執行緒外架構

### Worker 類型
- **Dedicated Workers**：1 對 1 關係，透過 `postMessage` 通訊
- **Shared Workers**：多個 tab 共用一個 worker 實例
- **Service Workers**：網路代理、快取策略、背景同步

### Structured Clone vs Transferable Objects
- 為什麼 `postMessage` 會複製資料（structured clone 演算法）
- Transferable objects（ArrayBuffer、OffscreenCanvas、MessagePort）的零複製傳輸
- SharedArrayBuffer + Atomics 實現真正的共享記憶體（需要 COOP／COEP headers）

### 架構模式
- 主執行緒外的資料處理管線
- CPU 密集任務的 Worker pool 實作
- Comlink 函式庫讓 worker 通訊更人性化

## 5. 渲染引擎內部

### 從 DOM 到像素
- **Style Resolution**：Cascade、specificity、繼承計算
- **Layout（Reflow）**：Blink 中的 LayoutNG 架構
- **Paint**：Paint records、繪製順序、stacking context
- **Compositing**：Layer 提升、GPU 加速、`will-change` 的影響
- **Display**：Rasterization、tile-based 渲染、display lists

### Compositor Thread
- 為什麼 CSS transform 和 opacity 是「便宜的」——它們完全跳過主執行緒
- Layer explosion：過多 composited layer 反而傷效能
- `contain: layout paint` — CSS containment 如何幫助引擎優化

## 6. 實際效能模式

### 應用引擎知識
- 為什麼 `transform: translateZ(0)` 有效（以及何時它有害）
- requestAnimationFrame 批次模式
- 高效 DOM 操作：DocumentFragment、template cloning
- 何時使用 `content-visibility: auto` 優化渲染

---

*每個段落都包含基準測試、DevTools 工作流程與真實世界的優化範例。*
