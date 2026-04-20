---
title: "程式碼美學：核心原則"
description: "程式碼品質的核心哲學——DRY、KISS、YAGNI、關注點分離、命名慣例，以及讓程式碼自我說明的實踐"
tags:
  - architecture
  - career
---

## 概述

優雅的程式碼不只是能運行的程式碼——它清晰、可維護、高效，讀起來是一種享受。就像一篇精心撰寫的文章或一棟美麗的建築，優雅的程式碼在每個層面都展現出簡潔、連貫與目的性。

## 優雅程式碼的哲學

**可讀性優先**
> "任何傻瓜都能寫出電腦能理解的程式碼。優秀的程式設計師寫的是人類能理解的程式碼。" — Martin Fowler

**簡潔勝於聰明**
> "簡潔是終極的複雜。" — Leonardo da Vinci

**可維護性是一種功能**
程式碼被閱讀的次數遠多於被撰寫的次數。優雅的程式碼為下一位讀者優化——那個人可能是六個月後的你自己。

## 清晰程式碼原則

### 1. DRY（Don't Repeat Yourself）

**原則**：系統中每一份知識都應該有唯一、明確的表示。

**反例**：
```javascript
function calculateTotalWithTax(price) {
  return price * 1.1;
}

function calculateSubtotalWithTax(subtotal) {
  return subtotal * 1.1;
}
```

**正例**：
```javascript
const TAX_RATE = 1.1;

function applyTax(amount) {
  return amount * TAX_RATE;
}
```

**優點**：
- 減少 bug（修一處，處處修）
- 更易維護
- 單一事實來源

### 2. KISS（Keep It Simple, Stupid）

**原則**：偏好簡單的解法而非複雜的。只有在必要時才增加複雜度。

**反例**：
```javascript
const isEven = (num) => num % 2 === 0 ? true : false;
```

**正例**：
```javascript
const isEven = (num) => num % 2 === 0;
```

**原則**：
- 清晰勝於聰明
- 避免過早優化
- 使用直觀的邏輯流程

### 3. YAGNI（You Aren't Gonna Need It）

**原則**：在真正需要某個功能之前，不要去建構它。

**避免**：
```javascript
class User {
  constructor(name) {
    this.name = name;
    this.preferences = {}; // 也許我們會需要這個？
    this.metadata = {};     // 或許以後有用？
    this.cache = new Map(); // 為了未來的優化？
  }
}
```

**較佳做法**：
```javascript
class User {
  constructor(name) {
    this.name = name;
  }
  // 等需求明確後再新增功能
}
```

### 4. Separation of Concerns（關注點分離）

**原則**：不同的關注點應由不同的模組/函數處理。

**反例**：
```javascript
function processOrder(order) {
  // 驗證
  if (!order.items || order.items.length === 0) {
    throw new Error('Empty order');
  }

  // 計算總計
  const total = order.items.reduce((sum, item) => sum + item.price, 0);

  // 儲存至資料庫
  database.save('orders', order);

  // 發送 Email
  emailService.send(order.customer.email, 'Order confirmed');

  // 記錄 Log
  logger.info(`Order ${order.id} processed`);
}
```

**正例**：
```javascript
function processOrder(order) {
  validateOrder(order);
  const total = calculateOrderTotal(order);
  saveOrder(order);
  notifyCustomer(order);
  logOrderProcessed(order);
}
```

### 5. Single Responsibility Principle（SRP，單一職責原則）

**原則**：一個 class/模組/函數應該只有一個改變的理由。

**反例**：
```javascript
class User {
  constructor(name, email) {
    this.name = name;
    this.email = email;
  }

  save() {
    // 資料庫邏輯
    database.insert('users', this);
  }

  sendWelcomeEmail() {
    // Email 邏輯
    emailService.send(this.email, 'Welcome!');
  }

  validateEmail() {
    // 驗證邏輯
    return /\S+@\S+\.\S+/.test(this.email);
  }
}
```

**正例**：
```javascript
class User {
  constructor(name, email) {
    this.name = name;
    this.email = email;
  }
}

class UserRepository {
  save(user) {
    database.insert('users', user);
  }
}

class UserNotifier {
  sendWelcome(user) {
    emailService.send(user.email, 'Welcome!');
  }
}

class EmailValidator {
  static validate(email) {
    return /\S+@\S+\.\S+/.test(email);
  }
}
```

## 命名慣例

### 變數與函數

**清晰的意圖**：
```javascript
// 反例
const d = 86400000; // d 是什麼？
const temp = data.filter(x => x.active); // 暫時的什麼？

// 正例
const MILLISECONDS_PER_DAY = 86400000;
const activeUsers = data.filter(user => user.active);
```

**可搜尋的命名**：
```javascript
// 反例
if (status === 4) { } // 魔術數字

// 正例
const STATUS_COMPLETED = 4;
if (status === STATUS_COMPLETED) { }
```

**避免心智映射**：
```javascript
// 反例
const yyyymmdd = formatDate(date);

// 正例
const formattedDate = formatDate(date);
```

### 一致性

**選定一種風格並堅持**：
- `getUser` vs `fetchUser` vs `retrieveUser` → 選一個並統一使用
- `isValid` vs `checkValid` vs `validate` → 保持一致

## 注釋與文件

### 何時寫注釋

**好的注釋**：
- 解釋**為什麼**，而非是什麼
- 複雜的演算法
- Bug 的臨時解法
- 法律聲明
- TODO/FIXME 標記

**範例**：
```javascript
// 使用二元搜尋，因為資料集可能超過 10 萬筆
// 線性搜尋是 O(n)，二元搜尋是 O(log n)
function findUser(id, users) {
  // 實作...
}

// FIXME: 多個使用者同時更新時存在競態條件
// TODO: 新增樂觀鎖（ticket #1234）
```

**不好的注釋**：
```javascript
// 將計數器加 1
counter++; // 這很明顯

// 這個函數將兩個數字相加
function add(a, b) {
  return a + b; // 函數名稱已經說明了這點
}
```

**自我說明的程式碼**（優先採用）：
```javascript
// 反例：需要注釋
// 檢查使用者是否成年且有權限
if (user.age >= 18 && user.role === 'admin') { }

// 正例：程式碼自我說明
const isAdult = user.age >= 18;
const isAdmin = user.role === 'admin';
if (isAdult && isAdmin) { }
```

進階設計原則（SOLID、Composition Over Inheritance、Error Handling）見 [[SOLID and Advanced Principles]]。

## 童子軍法則

> "讓程式碼比你發現它時更乾淨。"

**實踐**：
- 重新命名不清晰的變數
- 提取過長的函數
- 移除死碼
- 補上缺少的測試
- 修復明顯的 Bug

小小的改進會隨著時間複利累積。

## 結論

優雅的程式碼是：
- **簡單**：一眼就能理解
- **一致**：遵循模式與慣例
- **可測試**：能被可靠地驗證
- **可維護**：易於修改與擴展
- **自我說明**：清楚地表達意圖
- **專注**：每個部分都有單一目的

**程式碼只寫一次，但會被閱讀數十次。為可讀性而優化。**
