# Optimizing Claude Code: Reduce Token Usage and Boost Performance

As a heavy Claude Code user, even with the Max plan, I frequently hit my usage limits. After months of trial and error, I've compiled the most effective strategies to minimize token consumption while maintaining productivity.

## Install Essential CLI Tools

Claude Code leverages faster CLI tools when available. Installing these can significantly reduce search time and repeated queries.

```bash
brew install ripgrep fd bat fzf tree
```

|Tool|Purpose|Benefit|
|---|---|---|
|`ripgrep`|Fast code search|Claude prefers `rg` over grep|
|`fd`|Fast file finder|Quicker file lookups|
|`bat`|Syntax-highlighted cat|Better file previews|
|`fzf`|Fuzzy finder|Precise file targeting|
|`tree`|Directory structure|Reduces exploration tokens|

## Configure .claudeignore

Create a `.claudeignore` file in your project root to exclude unnecessary files from Claude's context:

```
node_modules/
dist/
build/
coverage/
.next/
*.log
*.lock
```

## Leverage CLAUDE.md

Create a `CLAUDE.md` file in your project root with essential context:

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

## Use Compact Mode

When your conversation grows long, use the `/compact` command to compress history while preserving key context.

## Restrict Git Operations

Prevent Claude from executing unwanted git commands by configuring `.claude/settings.json`:

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

## Best Practices

1. **Be specific** - Instead of "optimize this project", say "optimize re-renders in `src/components/GameTable.tsx`"
2. **Use @ references** - Directly reference files with `@filename` rather than letting Claude search
3. **Limit tool scope** - Use `--allowedTools` flag for focused sessions
4. **Batch related tasks** - Group similar operations to maintain context efficiency

## Quick Setup

Run this command to install all recommended tools:

```bash
brew install ripgrep fd bat fzf tree
```

---

_Last updated: 2025-01-03_