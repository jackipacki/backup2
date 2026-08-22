---
name: automated-backup
description: "Recurring file backup to Git with cron scheduling."
version: 1.0.0
author: Hermes Agent
license: MIT
platforms: [linux]
metadata:
  hermes:
    tags: [backup, cron, git, github, automation]
    related_skills: [github-repo-management]
---

# Automated Backup

Recurring backup of local files to a Git remote (GitHub, etc.) with exclusion
lists, secret-scanning awareness, and cron scheduling.

## When to Use

- User asks for periodic backup of files/directories to a remote repo.
- Need to set up cron jobs for recurring backup tasks.
- Dealing with GitHub Push Protection blocking pushes containing secrets.

## Procedure

### 1. Token management
Never embed tokens directly in scripts. Store in a separate file and read at
runtime:

```bash
# Write token to file (once)
echo "ghp_..." > /data/.backup_token
chmod 600 /data/.backup_token

# Read in script
TOKEN=$(cat /data/.backup_token)
```

### 2. Clone or create the repo
If the repo doesn't exist, create it via the API before cloning:

```bash
curl -s -X POST -H "Authorization: token $TOKEN" \
  https://api.github.com/user/repos \
  -d '{"name":"backup-repo","private":false,"auto_init":true}'
```

Clone via HTTPS with token (works when SSH port 22 is blocked):

```bash
git clone https://${TOKEN}@github.com/user/repo.git /path/to/backup_repo
```

### 3. Staging and exclusion
Use a staging directory to stage files before committing. Always exclude:

- **Secrets:** `.git-credentials`, `backup_token`, `state.db` (SQLite with
  embedded conversation data), any `.db` files >1MB
- **Large/generated dirs:** `node_modules`, `.cache`, `.npm`, `lost+found`
- **Dirs with embedded secrets:** `nuclei-templates` (contains checksum files
  with patterns matching known API keys — GitHub Push Protection will block)
- **The backup repo itself:** `.backup_repo`, `.backup_staging`

Include hidden directories (`.hermes/`, `.config/`, `.local/`) — they often
contain the important user data.

### 4. Git commit and push
After staging, clear the repo (except `.git`), copy clean files, commit, push:

```bash
find "$REPO_DIR" -mindepth 1 -maxdepth 1 ! -name '.git' -exec rm -rf {} +
cp -r "$STAGING_DIR"/* "$REPO_DIR/"
cp -a "$STAGING_DIR"/.??* "$REPO_DIR/" 2>/dev/null || true
git add -A
git commit -m "Backup: $(date +%Y-%m-%d_%H-%M)"
git push origin main
```

If history contains secrets that were already pushed, use force push with a
clean orphan branch:

```bash
git checkout --orphan clean
git add -A
git commit -m "Clean backup"
git push --force origin main
```

### 5. Schedule with cron
Set up a recurring cron job via the `cronjob` tool:

```
schedule: "every 24h"
prompt: "Run bash /path/to/backup.sh and report the result."
enabled_toolsets: ["terminal"]
```

## Pitfalls

### GitHub Push Protection
GitHub auto-blocks pushes containing detected secrets. Common triggers:
- `nuclei-templates/.checksum` — hashes match Fastly/Openweather key patterns
- SQLite `.db` files — contain embedded API keys from app state
- `.git-credentials` — plaintext tokens

**Fix:** Exclude these files in the staging step. If already in history,
force push with an orphan branch (see step 4).

### Hidden directories not matched by glob
`/data/*` does NOT match hidden dirs (`.hermes/`, `.config/`). Use:
```bash
for item in /data/* /data/.*; do
```
And skip `.` and `..` explicitly.

### rsync not always available
Use `cp -a` as a portable alternative. Skip `rsync` dependencies.

### Token in git clone URL
The token appears in process output and may be flagged by security scanners.
Read the token from a file at runtime, never hardcode in scripts.
