#!/bin/bash
# Daily Backup Script for Hermes Agent
# Backs up /data files to GitHub repo: jackipacki/backup2
set -e

REPO_DIR="/data/.backup_repo"
TOKEN=$(cat /data/.backup_token)
BACKUP_DIR="/data/.backup_staging"
DATE=$(date +%Y-%m-%d_%H-%M)

echo "=== Starting backup: $DATE ==="

# Clean old staging
rm -rf "$BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

# Copy ALL files including hidden dirs (exclude large/sensitive)
echo "Backing up files..."
for item in /data/* /data/.*; do
    name=$(basename "$item")
    [ "$name" = "." ] || [ "$name" = ".." ] && continue
    case "$name" in
        .backup_repo|.backup_staging|.backup_token|.cache|.npm|nuclei-templates|lost+found|node_modules) continue ;;
    esac
    cp -a "$item" "$BACKUP_DIR/"
done

# Remove files that may contain secrets or are too large
find "$BACKUP_DIR" -name "state.db" -delete 2>/dev/null
find "$BACKUP_DIR" -name "*.db" -size +1M -delete 2>/dev/null
find "$BACKUP_DIR" -name ".git-credentials" -delete 2>/dev/null
find "$BACKUP_DIR" -name "backup_token" -delete 2>/dev/null

echo "Files staged: $(du -sh "$BACKUP_DIR" 2>/dev/null | cut -f1)"

# Clone fresh repo (or reset existing)
if [ -d "$REPO_DIR" ]; then
    rm -rf "$REPO_DIR"
fi

echo "Cloning repo..."
cd /data
git clone https://${TOKEN}@github.com/jackipacki/backup2.git "$REPO_DIR" 2>&1

cd "$REPO_DIR"
git config user.email "hermes-backup@bot"
git config user.name "Hermes Backup Bot"

# Clear old files in repo (except .git)
find . -mindepth 1 -maxdepth 1 ! -name '.git' -exec rm -rf {} +

# Copy new files
cp -r "$BACKUP_DIR"/* . 2>/dev/null || true
# Also copy hidden files from staging
cp -a "$BACKUP_DIR"/.??* . 2>/dev/null || true

# Remove secrets before committing
find . -name "state.db" -delete 2>/dev/null
find . -name "*.db" -size +1M -delete 2>/dev/null
find . -name ".git-credentials" -delete 2>/dev/null
find . -name "backup_token" -delete 2>/dev/null

# Commit and push
git add -A
git commit -m "Backup: $DATE" || echo "No changes to commit"
git push origin main 2>&1

echo "=== Backup completed: $DATE ==="
echo "Repo: https://github.com/jackipacki/backup2"

# Cleanup staging
rm -rf "$BACKUP_DIR"
