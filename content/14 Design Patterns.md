# 14 Essential Design Patterns

Reusable solutions to common software problems in JavaScript.

## Programming Paradigms

### Object-Oriented Programming
```javascript
class BankAccount {
  #balance = 0;
  deposit(amount) { this.#balance += amount; }
  getBalance() { return this.#balance; }
}
```

### Functional Programming
```javascript
// Pure functions, immutability, higher-order functions
const add = (a, b) => a + b;
const newUsers = [...users, newUser];
const doubled = numbers.map(x => x * 2);
```

## Creational Patterns

### Factory Pattern
Create objects without specifying exact classes.
```javascript
class TransportFactory {
  static create(type) {
    const transports = {
      truck: () => new Truck(),
      ship: () => new Ship()
    };
    return transports[type]?.();
  }
}
```

### Builder Pattern
Build complex objects step-by-step.
```javascript
const user = new UserBuilder()
  .setName('John')
  .setEmail('john@example.com')
  .build();
```

### Singleton Pattern
Ensure only one instance exists.
```javascript
class Database {
  constructor() {
    if (Database.instance) return Database.instance;
    Database.instance = this;
  }
}
```

### Prototype Pattern
Clone existing objects.
```javascript
const character = { name: 'Warrior', health: 100 };
const clone = { ...character };
```

## Structural Patterns

### Facade Pattern
Simplified interface to complex subsystem.
```javascript
class ComputerFacade {
  start() {
    this.cpu.freeze();
    this.memory.load();
    this.cpu.execute();
  }
}
```

### Proxy Pattern
Control access to another object.
```javascript
const userProxy = new Proxy(user, {
  set(target, prop, value) {
    console.log(`Setting ${prop} to ${value}`);
    target[prop] = value;
  }
});
```

### Composite Pattern
Treat individual and composite objects uniformly.
```javascript
class Folder {
  add(item) { this.children.push(item); }
  getSize() { return this.children.reduce((sum, child) => sum + child.getSize(), 0); }
}
```

### Decorator Pattern
Add behavior without altering structure.
```javascript
const withLogging = (fn) => (...args) => {
  console.log(`Calling ${fn.name}`);
  return fn(...args);
};
```

## Behavioral Patterns

### Observer Pattern
One-to-many dependency notifications.
```javascript
class EventEmitter {
  subscribe(event, callback) { /* add to listeners */ }
  emit(event, data) { /* notify all listeners */ }
}
```

### Mediator Pattern
Objects communicate through central mediator.
```javascript
class ChatRoom {
  sendMessage(message, fromUser) {
    this.users.forEach(user => {
      if (user !== fromUser) user.receive(message);
    });
  }
}
```

### State Pattern
Change behavior based on internal state.
```javascript
class TrafficLight {
  constructor() { this.state = new RedLight(this); }
  next() { this.state.next(); }
}
```

### Iterator Pattern
Access collection elements sequentially.
```javascript
function* range(start, end) {
  for (let i = start; i <= end; i++) yield i;
}
```

### Strategy Pattern
Interchangeable algorithms.
```javascript
const paymentStrategies = {
  creditCard: (amount) => processCC(amount),
  paypal: (amount) => processPP(amount)
};

function pay(amount, method) {
  return paymentStrategies[method](amount);
}
```

## Key Benefits

- **Reusability**: Proven solutions to common problems
- **Communication**: Shared vocabulary among developers
- **Maintainability**: Clear, flexible code structure
- **Flexibility**: Adapt to changing requirements