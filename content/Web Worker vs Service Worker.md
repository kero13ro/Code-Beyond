# Web Worker 和 Service Worker 名字像，但解決完全不同的問題

把計算密集任務丟給 Web Worker、把網路請求快取交給 Service Worker——混淆這兩個會讓你在錯誤的地方尋找解決方案。

## Web Worker：把重計算移出主線程

JavaScript 是單線程。當 Call Stack 被長時間佔用，頁面會凍結、無法回應使用者操作。Web Worker 讓你在獨立線程執行 JavaScript，主線程繼續處理 UI。

**適用場景：**
- 大量數據解析（JSON、CSV）
- 圖像處理、加密運算
- 複雜的資料結構排序或搜尋

```javascript
// 主線程
const worker = new Worker('heavy-task.js');
worker.postMessage({ data: largeArray });
worker.onmessage = (e) => console.log('結果:', e.data);

// heavy-task.js（Worker 內）
self.onmessage = (e) => {
  const result = expensiveCompute(e.data.data);
  self.postMessage(result);
};
```

**限制：** Web Worker 無法存取 DOM，生命週期與建立它的頁面綁定，頁面關閉 Worker 就消失。

## Service Worker：瀏覽器的網路代理

Service Worker 是一種特殊的 Worker，獨立於頁面運行，即使頁面關閉仍可存活。它的核心能力是攔截頁面發出的所有網路請求。

**適用場景：**
- 離線快取（PWA 的核心）
- 攔截並修改 API 請求
- 推播通知（即使頁面未開啟）
- 跨分頁共享資料

```javascript
// 安裝時快取靜態資源
self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open('v1').then((cache) =>
      cache.addAll(['/index.html', '/app.js', '/style.css'])
    )
  );
});

// 攔截請求：有快取用快取，沒有才走網路
self.addEventListener('fetch', (event) => {
  event.respondWith(
    caches.match(event.request).then((cached) =>
      cached || fetch(event.request)
    )
  );
});
```

**限制：** 只能在 HTTPS 下運作（localhost 除外），有自己的安裝 / 啟動 / 更新生命週期，需要手動管理快取版本。

## 選哪個？

| | Web Worker | Service Worker |
|---|---|---|
| 主要用途 | 避免主線程阻塞 | 網路代理 / 離線快取 |
| 生命週期 | 依附頁面 | 獨立於頁面 |
| DOM 存取 | 不能 | 不能 |
| 跨分頁 | 不能 | 可以 |
| 攔截網路請求 | 不能 | 可以 |
| 通訊方式 | postMessage | postMessage + FetchEvent |

兩個都可以透過 `postMessage` 與頁面通訊，但解決問題的層次完全不同：Web Worker 是計算問題，Service Worker 是網路問題。

大多數應用用不到 Service Worker，但如果你在做 PWA 或需要離線功能，它是無可替代的工具。Web Worker 則低估的情況更多——任何超過 50ms 的計算都值得考慮搬離主線程。
