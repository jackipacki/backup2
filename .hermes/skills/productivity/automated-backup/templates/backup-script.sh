#!/bin/bash
# Daily Backup Script for Hermes Agent
# Backs up /data files to GitHub repo
# Usage: Set REPO_OWNER, REPO_NAME, and TOKEN_PATH before running
set -e

# ── Configuration ────────────────────────────────────────────────────
REPO_OWNER="your_username"
REPO_NAME="backup-repo"
TOKEN_PATH="/data/.backup_token"
REPO_DIR="/data/.backup_repo"
BACKUP_DIR="/data/.backup_staging"
DATE=$(date +%Y-%m-%d_%H-%M)

# ── Read token ──────────────────────────────────────────────────────
TOKEN=$(cat "$TOKEN_PATH")

echo "=== Starting backup: $DATE ==="

# ── Stage files ─────────────────────────────────────────────────────
rm -rf "$BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

echo "Staging files..."
for item in /data/* /data/.*; do
    name=$(basename "$item")
    [ "$name" = "." ] || [ "$name" = ".." ] && continue
    # Exclude dirs that are large, sensitive, or the backup repo itself
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

echo "Staged: $(du -sh "$BACKUP_DIR" 2>/dev/null | cut -f1)"

# ── Clone or reset repo ─────────────────────────────────────────────
if [ -d "$REPO_DIR" ]; then
    rm -rf "$REPO_DIR"
fi

echo "Cloning repo..."
cd /data
git clone https://${TOKEN}@github.com/${REPO_OWNER}/${REPO_NAME}.git "$REPO_DIR" 2>&1

cd "$REPO_DIR"
git config user.email "hermes-backup@bot"
git config user.name "Hermes Backup Bot"

# ── Commit and push ─────────────────────────────────────────────────
find . -mindepth 1 -maxdepth 1 ! -name '.git' -exec rm -rf {} +
cp -r "$BACKUP_DIR"/* . 2>/dev/null || true
cp -a "$BACKUP_DIR"/.??* . 2>/dev/null || true

# Remove secrets before committing
find . -name "state.db" -delete 2>/dev/null
find . -name "*.db" -size +1M -delete 2>/dev/null
find . -name ".git-credentials" -delete 2>/dev/null
find . -name "backup_token" -delete 2>/dev/null

git add -A
git commit -m "Backup: $DATE" || echo "No changes to commit"
git push origin main 2>&1

echo "=== Backup completed: $DATE ==="
rm -rf "$BACKUP_DIR"
