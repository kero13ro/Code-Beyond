# CORS 不是後端的鍋，是瀏覽器在保護你

CORS 錯誤在 console 出現時，第一反應通常是去改後端設定。但理解它為什麼存在，才能知道什麼時候該改後端、什麼時候是前端架構設計的問題。

## CORS 是什麼

Cross-Origin Resource Sharing，跨來源資源共享。瀏覽器的同源政策（Same-Origin Policy）禁止一個網頁向不同來源（不同 domain、protocol 或 port）發送請求——這是防止惡意網站竊取你已登入的其他服務資料的安全機制。

CORS 是一個豁免機制：如果目標伺服器明確表示「我允許來自 X 的請求」，瀏覽器才放行。

**Preflight 請求**

對於非簡單請求（如帶自訂 header 的 POST 或 PUT），瀏覽器會先送一個 `OPTIONS` 請求詢問伺服器：

```
OPTIONS /api/users HTTP/1.1
Origin: https://app.example.com
Access-Control-Request-Method: POST
Access-Control-Request-Headers: Content-Type
```

伺服器回應允許後，才發出真正的請求。這個預檢會消耗一次 RTT，高頻 API 呼叫要注意快取 preflight（`Access-Control-Max-Age`）。

## 不透過 API 的跨站通訊

如果兩個不同的前端專案在同一個 domain 下，有幾種不需要後端的通訊方式：

**1. Web Storage API**（同 origin 共享）
```javascript
// 專案 A 寫入
localStorage.setItem('token', value);

// 專案 B 讀取（需在同 origin 下）
const token = localStorage.getItem('token');

// 監聽變動（跨 tab 有效）
window.addEventListener('storage', (e) => console.log(e.key, e.newValue));
```

**2. PostMessage API**（跨 origin 也可用）

適合父頁面與 iframe、或彈出視窗之間的通訊：
```javascript
// 發送
iframe.contentWindow.postMessage({ type: 'AUTH', token }, 'https://sub.example.com');

// 接收（務必驗證 origin）
window.addEventListener('message', (e) => {
  if (e.origin !== 'https://app.example.com') return;
  console.log(e.data);
});
```

**3. Cookie**（可設定跨子域）

設定 `Domain=.example.com` 讓 cookie 在所有子域共享，但注意隱私法規限制（GDPR、CCPA）和 `SameSite` 屬性。

**4. BroadcastChannel API**（同 origin 跨 tab 廣播）

專為同 origin 多個分頁 / Worker 之間的廣播設計，比 `localStorage + storage 事件` 更直接：

```javascript
// 任何分頁都可以建立同名 channel
const channel = new BroadcastChannel('app-events');

// 發送（不限哪個 tab）
channel.postMessage({ type: 'LOGOUT' });

// 接收（同 origin 下所有訂閱者都會收到）
channel.onmessage = (e) => {
  if (e.data.type === 'LOGOUT') redirectToLogin();
};

// 用完記得關閉
channel.close();
```

與 `localStorage` 方案的差異：BroadcastChannel 是即時推播，不需要輪詢或依賴寫入 storage 觸發事件；但它不持久化，重新開啟的 tab 不會收到歷史訊息。

**5. Service Worker**（跨 tab 共享狀態）

同一 origin 下的 Service Worker 可以攔截所有分頁的請求，適合需要跨 tab 同步狀態的場景。參考 [[Web Worker vs Service Worker]]。

**5. Shared Storage API**（目前僅 Chrome）

Google 為解決跨 origin 共享需求提出的新 API，目前支援度有限，不建議用於生產。

## 選擇依據

| 場景 | 建議方案 |
|---|---|
| 同 origin 跨 tab 即時廣播 | `BroadcastChannel` |
| 同 origin 跨 tab 持久化狀態 | `localStorage` + `storage` 事件 |
| 父頁面與 iframe | `postMessage` |
| 認證 token 跨子域共享 | Cookie（`Domain=.example.com`）|
| 離線快取 / 攔截請求 | Service Worker |

CORS 設定是後端工作，但通訊架構是前端設計決策。跨站通訊需求出現的時候，先確認是否真的需要跨 origin——有時候把兩個專案合進同一個 origin 才是正確解。
