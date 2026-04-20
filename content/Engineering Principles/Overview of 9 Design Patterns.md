---
title: "9 個設計模式速查"
draft: true
tags:
  - architecture
---

JavaScript 日常開發中最常出現的模式，一頁速查。

## 創建型

### Factory
不指定具體類別，統一建立物件。
```javascript
class TransportFactory {
  static create(type) {
    const map = { truck: () => new Truck(), ship: () => new Ship() };
    return map[type]?.();
  }
}
```

### Singleton
確保全局只有一個實例。
```javascript
class Database {
  constructor() {
    if (Database.instance) return Database.instance;
    Database.instance = this;
  }
}
```

## 結構型

### Facade
為複雜子系統提供簡化介面。
```javascript
class ComputerFacade {
  start() {
    this.cpu.freeze();
    this.memory.load();
    this.cpu.execute();
  }
}
```

### Proxy
控制對另一個物件的存取（Vue 的響應式系統即基於此）。
```javascript
const userProxy = new Proxy(user, {
  set(target, prop, value) {
    console.log(`Setting ${prop}`);
    target[prop] = value;
  }
});
```

### Decorator
不改變結構，動態附加行為。
```javascript
const withLogging = (fn) => (...args) => {
  console.log(`Calling ${fn.name}`);
  return fn(...args);
};
```

## 行為型

### Observer
一對多的依賴通知機制。
```javascript
class EventEmitter {
  subscribe(event, cb) { /* 加入監聽器 */ }
  emit(event, data)    { /* 通知所有監聽器 */ }
}
```

### State
根據內部狀態改變行為。
```javascript
class TrafficLight {
  constructor() { this.state = new RedLight(this); }
  next() { this.state.next(); }
}
```

### Iterator
依序存取集合元素（JS generator 原生支援）。
```javascript
function* range(start, end) {
  for (let i = start; i <= end; i++) yield i;
}
```

### Strategy
可互換的演算法策略。
```javascript
const strategies = {
  creditCard: (amount) => processCC(amount),
  paypal:     (amount) => processPP(amount),
};
const pay = (amount, method) => strategies[method](amount);
```

---

模式給了團隊共同語彙——重構時說「這裡用 Strategy」比解釋三段邏輯快得多。
