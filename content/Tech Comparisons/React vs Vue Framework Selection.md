# React 還是 Vue？先搞清楚你在解決什麼問題

框架選擇不是宗教戰爭，是工程決策。React 和 Vue 的核心差異只有一個：對「狀態」的哲學截然不同，這個差異決定了你的程式碼量、除錯體驗、和團隊學習曲線。

## 最根本的差異：狀態模型

**Vue：Proxy signal，資料就是真相**

Vue3 用 `Proxy` 攔截物件存取，你改哪裡它更新哪裡，不需要告訴框架「我改了」：

```javascript
const state = reactive({ list: [1, 2, 3] });
state.list.push(4); // Vue 自動偵測，畫面更新
```

**React：Immutable snapshot，每次都是新物件**

React 的狀態是快照。你不改舊物件，你建立新物件：

```javascript
function handleClick() {
  const nextList = [...list];
  nextList.reverse();
  setList(nextList); // 必須傳入新陣列
}
```

同樣的操作，React 需要 3-4 倍的程式碼。這不是缺陷，是設計選擇——強制不可變讓狀態追蹤變得可預測，代價是寫法更冗長。

## Vue2 vs Vue3：響應式的進化

Vue2 用 `Object.defineProperty` 監聽 getter/setter，有個硬傷：無法偵測物件屬性的新增與刪除。

```javascript
// Vue2 偵測不到這個操作
this.user.newProp = 'value'; // 需要用 Vue.set() 繞過
```

Vue3 改用 `Proxy`，直接代理整個物件，新增屬性、陣列操作都能正確追蹤。這是架構層面的修正，不只是功能更新。

## 模板與組件設計

Vue 的 SFC（Single File Component）把 template、script、style 放在同一個檔案，可讀性高，適合快速開發：

```vue
<template>
  <div>{{ message }}</div>
</template>
<script setup>
const message = ref('Hello');
</script>
```

React 用 JSX，組件就是函數，強調 HOC（Higher-Order Component）和組合模式。每個組件是一個資料夾，沒有官方 compiler，生態系碎片化但靈活。

## 什麼情況選 React

- 超高流量服務（Netflix、Uber 規模），需要精細控制 re-render 和快取策略
- 團隊有強烈的 Functional Programming 偏好
- 需要 React Native 跨平台方案
- 需要對 `useMemo`、`useCallback` 的依賴關係有完全掌控

## 什麼情況選 Vue

- 以網站服務為主，開發速度優先
- 團隊規模不大，語法糖降低學習成本
- 需要快速交付，SFC 模式比 JSX 少寫 1/3 程式碼
- 偏好官方統一的解決方案（Pinia、Vue Router、Vite）

## 兩者的共同點先確認

兩個框架在以下方面是相同的：
- Virtual DOM：避免頻繁直接操作 DOM tree
- 單向數據流：父組件向下傳遞 props
- 組件化架構：切分職責、提升複用性

如果你的團隊在這兩個框架上都有生產經驗，選 React 還是 Vue 影響沒你想的大。真正的差異在邊緣情況：狀態複雜度高的表單、大量列表渲染、跨組件狀態同步——這時候各自的響應式模型才真的分出高下。

先問「我的應用狀態有多複雜」，答案比框架選邊更重要。
