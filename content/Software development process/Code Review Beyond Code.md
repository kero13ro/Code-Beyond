# Code Review 最有價值的時機不是在 PR 開出來之後

等到 PR 才開始審查，架構問題早就固化了。真正的 Code Review 有三個時機，最重要的在寫第一行程式碼之前。

## 開發前：架構設計 Review

在開始實作之前討論設計，成本最低，收益最高。這個階段要問的問題：

- **職責邊界**：這個類別 / 模組的職責是什麼？它有沒有混入不屬於自己的邏輯？
- **封裝程度**：高層模組有沒有暴露實作細節？呼叫端需要知道多少才能使用？
- **可擴展性**：如果需求改了，需要動幾個地方？能不能用 Open-Closed 原則保護核心邏輯？

參考 [[Engineering Principles/SOLID and Advanced Principles]] 和 [3Rs of Software Architecture](https://github.com/ryanmcdermott/3rs-of-software-architecture)——Reusable、Readable、Refactorable 是評估架構的三個維度。

## 開發中：程式碼審核

PR 階段的審核重點是兩件事：

**Scalable**
- 時間複雜度：這個演算法在資料量增長時表現如何？
- 空間複雜度：有沒有不必要的記憶體佔用？
- 大量資料時有沒有分頁、虛擬列表、批次處理？

**Readable**
- 命名：變數和函數名稱能不能讓人一眼知道它做什麼？
- 函數長度：超過 50 行的函數通常有多個職責，考慮拆分
- 巢狀層數：超過 4 層的 if/for 巢狀讓邏輯難以追蹤，先處理 early return
- 參數數量：函數參數超過 3 個，通常應該改成物件傳入

## 開發後：測試覆蓋 Review

測試不是最後才加的，但 Review 是確認覆蓋是否足夠的最後關卡。

| 測試層級 | 驗證對象 | 工具 |
|---|---|---|
| Unit Test | 單個函數 / 組件的輸出行為 | Jest、Vitest |
| Snapshot Test | HTML 結構有無非預期變動 | Jest snapshots |
| Integration Test | 多個模組組合後的協作行為 | Testing Library + mock server |
| E2E Test | 完整使用者流程 | Playwright、Cypress |

每層測試的比例呈金字塔：Unit 最多，E2E 最少。E2E 慢且脆弱，只覆蓋關鍵用戶路徑；Unit 快且精準，覆蓋邊界條件。

## Review 的本質

Code Review 不是找錯，是知識傳遞和系統健康度的檢查點。開發前的架構討論讓團隊對方向對齊，開發中的審核讓品質維持，開發後的測試確認行為有被驗證。

三個時機都做，PR 才不會變成走形式。
