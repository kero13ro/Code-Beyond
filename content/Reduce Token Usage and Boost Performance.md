---
title: "減少 Token 用量、提升 Claude Code 效能"
draft: true
tags:
  - tools
---

# 優化 Claude Code：減少 Token 用量、提升效能

作為重度 Claude Code 使用者，即使訂閱了 Max 方案，我還是頻繁觸碰用量上限。經過幾個月的反覆測試，以下是真正有效的做法。

## 安裝必要的 CLI 工具

Claude Code 會優先使用更快的 CLI 工具。安裝這些工具能縮短搜尋時間，減少重複查詢。

```bash
brew install ripgrep fd bat fzf tree
```

| 工具 | 用途 | 效益 |
|---|---|---|
| `ripgrep` | 快速程式碼搜尋 | Claude 偏好 `rg` 而非 grep |
| `fd` | 快速檔案搜尋 | 加快檔案定位速度 |
| `bat` | 帶語法高亮的 cat | 更好的檔案預覽 |
| `fzf` | 模糊搜尋 | 精準鎖定目標檔案 |
| `tree` | 顯示目錄結構 | 減少探索目錄所耗的 token |

## 設定 .claudeignore

在專案根目錄建立 `.claudeignore`，排除不必要的檔案進入 Claude 的 context：

```
node_modules/
dist/
build/
coverage/
.next/
*.log
*.lock
```

## Use CLAUDE.md for Context

在專案根目錄建立 `CLAUDE.md`，寫入必要的背景資訊：

```markdown
## Project Overview
- Tech stack: React, TypeScript, PixiJS
- Architecture: Monorepo with pnpm workspaces

## Common Commands
- `pnpm dev` - Start development server
- `pnpm test` - Run tests
- `pnpm lint` - Run linter

## Code Conventions
- Use functional components with hooks
- Prefer named exports
- Follow existing patterns in src/components
```

## 使用 Compact 模式

當對話變得很長，使用 `/compact` 指令壓縮歷史紀錄，同時保留關鍵 context。

## 限制 Git 操作

透過設定 `.claude/settings.json`，防止 Claude 執行不必要的 git 指令：

```json
{
  "permissions": {
    "allow": [],
    "deny": [
      "Bash(git stash*)",
      "Bash(git commit*)",
      "Bash(git push*)",
      "Bash(git merge*)",
      "Bash(git rebase*)",
      "Bash(git reset*)"
    ]
  }
}
```

## How to Cut Token Usage by 50%

1. **明確指定範圍** — 不要說「優化這個專案」，改說「優化 `src/components/GameTable.tsx` 中的重複渲染」
2. **使用 @ 引用** — 直接以 `@filename` 指定檔案，而非讓 Claude 自行搜尋
3. **限制工具範圍** — 用 `--allowedTools` flag 鎖定單一工作情境
4. **批次相關任務** — 將類似的操作合併處理，維持 context 效率

---

_最後更新：2025-01-03_
