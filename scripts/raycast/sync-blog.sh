#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Sync Blog Content
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 📝
# @raycast.packageName Blog

# Documentation:
# @raycast.description 同步部落格內容並推送 commit
# @raycast.author keroliao

set -e

# 定義路徑
SOURCE_DIR="/Users/keroliao/Documents/vault/remote-1/blog"
TARGET_DIR="/Users/keroliao/Documents/GitHub/Code-Beyond/content"
REPO_DIR="/Users/keroliao/Documents/GitHub/Code-Beyond"

# 檢查來源目錄是否存在
if [ ! -d "$SOURCE_DIR" ]; then
    echo "❌ 錯誤: 來源目錄不存在: $SOURCE_DIR"
    exit 1
fi

# 檢查目標目錄是否存在
if [ ! -d "$TARGET_DIR" ]; then
    echo "❌ 錯誤: 目標目錄不存在: $TARGET_DIR"
    exit 1
fi

# 切換到專案目錄
cd "$REPO_DIR"

# 同步檔案（保留目標目錄的其他檔案）
echo "📋 正在同步檔案..."
rsync -av --delete "$SOURCE_DIR/" "$TARGET_DIR/"

# 檢查是否有變更
if [ -z "$(git status --porcelain)" ]; then
    echo "✅ 沒有新的變更"
    exit 0
fi

# 顯示變更的檔案
echo "📝 變更的檔案:"
git status --short

# 加入所有變更
git add content/

# 建立 commit
COMMIT_MSG="docs: sync blog content from vault"

git commit -m "$COMMIT_MSG"

# 推送到遠端
echo "🚀 正在推送到遠端..."
git push origin v4

echo "✅ 部落格內容同步完成並已推送！"
