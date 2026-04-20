---
title: "行動裝置 Web 除錯指南"
description: "在 iOS 與 Android 實機或模擬器上除錯 Web 頁面——vConsole、Xcode Simulator、Android Studio 模擬器的實作設定"
tags:
  - tools
---

桌面 DevTools 在手機上不存在，但行動裝置的 bug 往往只在手機上出現。

## vConsole

[vConsole](https://github.com/Tencent/vConsole) 是 Tencent 開源的輕量行動端除錯工具，直接在頁面上浮出一個 DevTools 面板——Console、Network、Storage、Element 都有。

```html
<script src="https://unpkg.com/vconsole/dist/vconsole.min.js"></script>
<script>
  if (process.env.NODE_ENV !== 'production') {
    new VConsole();
  }
</script>
```

只在開發環境載入，不影響正式環境效能。當你需要在真實裝置上看 console log 或 network request，這是最快的方法。
![file-20260420231944446|300](assets/Mobile%20Web%20Debugging/file-20260420231944446.png|)

## iOS：Xcode Simulator

不需要真機，Simulator 就能模擬各種 iOS 版本與機型。

1. 開啟 Xcode → **Xcode menu → Open Developer Tool → Simulator**
2. **File → New Simulator** 新增版本（例如 iOS 16）
3. 選擇機型（例如 iPhone 8）並建立
4. 啟動後在 Safari 開啟目標網址
5. Mac 上的 **Safari → 開發 → Simulator** 即可連接 Web Inspector
![file-20260420232243612|600](assets/Mobile%20Web%20Debugging/file-20260420232243612.png)
![file-20260420232320890|300](assets/Mobile%20Web%20Debugging/file-20260420232320890.png)

模擬 Safari 的行為比 Chrome 更接近 iOS 真實環境，尤其是 CSS 相容性問題。

## Android：Android Studio 模擬器

1. Android Studio → **Device Manager → Create Virtual Device**
2. 選擇機型與 API 版本
3. 啟動設定建議：**Cold Boot**（避免睡眠狀態殘留的 bug）、關閉 **Enable Device Frame**（加快渲染）
4. 啟動後在模擬器開啟 Chrome，輸入 `chrome://inspect` 可在桌面 Chrome DevTools 遠端除錯

---

優先順序：真機 > Simulator/模擬器 > vConsole。真機能抓到的問題最真實，但 Simulator 的 Web Inspector 整合讓除錯效率高很多。

![file-20260420232342922](assets/Mobile%20Web%20Debugging/file-20260420232342922.png)
![file-20260420232402186](assets/Mobile%20Web%20Debugging/file-20260420232402186.png)