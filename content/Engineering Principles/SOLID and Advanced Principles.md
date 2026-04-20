---
title: "SOLID 與進階設計原則"
description: "從 SOLID 原則到進階設計模式——組合優於繼承、命令查詢分離、Fail Fast 與測試性設計"
tags:
  - architecture
  - career
---

## SOLID 原則

### S - Single Responsibility Principle（單一職責原則）

SRP 即 Single Responsibility，詳見 [[What is Elegant Code]] 的 Clean Code 章節。

### O - Open/Closed Principle（開放/封閉原則）

**原則**：軟體實體應該對擴展開放，對修改封閉。

**範例**：
```javascript
// 反例：新增形狀時需要修改 class
class AreaCalculator {
  calculate(shapes) {
    return shapes.reduce((total, shape) => {
      if (shape.type === 'circle') {
        return total + Math.PI * shape.radius ** 2;
      } else if (shape.type === 'rectangle') {
        return total + shape.width * shape.height;
      }
      // 新增形狀就得加 if-else
    }, 0);
  }
}

// 正例：透過新增 class 來擴展
class Shape {
  area() {
    throw new Error('Must implement area()');
  }
}

class Circle extends Shape {
  constructor(radius) {
    super();
    this.radius = radius;
  }

  area() {
    return Math.PI * this.radius ** 2;
  }
}

class Rectangle extends Shape {
  constructor(width, height) {
    super();
    this.width = width;
    this.height = height;
  }

  area() {
    return this.width * this.height;
  }
}

class AreaCalculator {
  calculate(shapes) {
    return shapes.reduce((total, shape) => total + shape.area(), 0);
  }
}
```

### L - Liskov Substitution Principle（里氏替換原則）

子型別必須能在不改變程式正確性的前提下替換其基底型別。

### I - Interface Segregation Principle（介面隔離原則）

客戶端不應該被強迫依賴它們不使用的介面。

### D - Dependency Inversion Principle（依賴反轉原則）

依賴抽象，而非具體實作。

**範例**：
```javascript
// 反例：高層模組依賴低層模組
class MySQLDatabase {
  save(data) {
    // MySQL 特定程式碼
  }
}

class UserService {
  constructor() {
    this.db = new MySQLDatabase(); // 緊耦合
  }

  saveUser(user) {
    this.db.save(user);
  }
}

// 正例：兩者都依賴抽象
class UserService {
  constructor(database) {
    this.database = database; // 依賴介面
  }

  saveUser(user) {
    this.database.save(user);
  }
}

// 任何資料庫實作都能使用
class MySQLDatabase {
  save(data) { /* ... */ }
}

class MongoDatabase {
  save(data) { /* ... */ }
}
```

## 進階原則

### Law of Demeter（最少知識原則）

**原則**：一個單元只應與它的直接朋友溝通。

**反例**：
```javascript
user.getAddress().getCity().getName(); // 跨多個物件的鏈式呼叫
```

**正例**：
```javascript
user.getCityName(); // 封裝呼叫鏈
```

### Composition Over Inheritance（組合優於繼承）

**反例**：
```javascript
class Animal { }
class FlyingAnimal extends Animal { }
class SwimmingAnimal extends Animal { }
class FlyingSwimmingAnimal extends FlyingAnimal { } // 尷尬的繼承層級
```

**正例**：
```javascript
class Animal {
  constructor(abilities = []) {
    this.abilities = abilities;
  }
}

const flyingAbility = {
  fly() { console.log('Flying!'); }
};

const swimmingAbility = {
  swim() { console.log('Swimming!'); }
};

const duck = new Animal([flyingAbility, swimmingAbility]);
```

### Command-Query Separation（命令查詢分離，CQS）

**原則**：方法應該要嘛改變狀態（命令），要嘛回傳資料（查詢），而不是兩者兼具。

**反例**：
```javascript
function getAndResetCounter() {
  const value = counter;
  counter = 0;
  return value; // 查詢 AND 命令
}
```

**正例**：
```javascript
function getCounter() {
  return counter; // 只查詢
}

function resetCounter() {
  counter = 0; // 只命令
}
```

### Fail Fast（快速失敗）

**原則**：盡可能早地偵測並回報錯誤。

```javascript
function divide(a, b) {
  if (b === 0) {
    throw new Error('Division by zero'); // 立即失敗
  }
  return a / b;
}
```

## 錯誤處理

**為例外情況使用例外**：
```javascript
// 反例：使用回傳碼
function readFile(path) {
  // ...
  return { error: null, data: content };
}

const result = readFile('file.txt');
if (result.error) { }

// 正例：使用例外
function readFile(path) {
  if (!fileExists(path)) {
    throw new FileNotFoundError(path);
  }
  return content;
}

try {
  const content = readFile('file.txt');
} catch (error) {
  // 處理錯誤
}
```

**提供上下文**：
```javascript
// 反例
throw new Error('Invalid input');

// 正例
throw new Error(`Invalid email format: ${email}. Expected format: user@domain.com`);
```

## 測試與優雅程式碼

**可測試的程式碼就是優雅的程式碼**：
- 純函數 → 易於測試
- 單一職責 → 隔離的測試
- 依賴注入 → 可 Mock 的依賴

**範例**：
```javascript
// 難以測試
class UserService {
  saveUser(user) {
    const db = new Database(); // 硬編碼的依賴
    db.save(user);
  }
}

// 易於測試
class UserService {
  constructor(database) {
    this.database = database; // 可注入
  }

  saveUser(user) {
    this.database.save(user);
  }
}

// 用 Mock 測試
const mockDb = { save: jest.fn() };
const service = new UserService(mockDb);
service.saveUser({ name: 'Alice' });
expect(mockDb.save).toHaveBeenCalled();
```

---

好的架構不是要一開始就設計完美——而是讓未來的改變代價最低。SOLID 給你的不是規則，而是一組問自己的問題：「如果這個需求改了，我需要動幾個地方？」答案越少，設計越好。
