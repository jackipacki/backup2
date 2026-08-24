# 10 — Recon & OSINT

Distilled from `offensive-osint`, `web2-recon`, `recon-scope-triage`.

---

## Recon Pipeline

### Phase 1: Subdomain Enumeration
- `subfinder -d target.com -all` (passive DNS)
- `crt.sh` (Certificate Transparency)
- `amass enum -d target.com` (comprehensive passive)
- `assetfinder --subs-only target.com`

### Phase 2: DNS Resolution
```
cat subdomains.txt | dnsx -silent -a -resp-only
```

### Phase 3: HTTP Probing
```
cat live_hosts.txt | httpx -silent -title -tech-detect -status-code -follow-redirects
```

### Phase 4: URL Crawling
```
katana -u live_hosts.txt -d 3 -jc
```
Plus: `waybackurls`, `gau`, JS file download + analysis

### Phase 5: Directory Fuzzing
```
ffuf -u https://target.com/FUZZ -w wordlist.txt -mc 200,301,302,403
```

---

## JavaScript Analysis

Extract from JS bundles:
1. **API endpoints**: `/api/`, `/v1/`, fetch/axios calls
2. **Hidden routes**: Client-side routes not in navigation
3. **Secrets**: API keys, tokens, Firebase config, AWS creds
4. **GraphQL queries**: Query/mutation definitions
5. **Environment configs**: `process.env`, `window.__CONFIG__`
6. **Internal hostnames**: `*.internal.target.com`

Source map recovery:
```
curl -s https://target.com/static/js/main.js.map
curl -s https://target.com/_next/static/chunks/*.js.map
```

---

## Secret Regex Patterns

```
AKIA[0-9A-Z]{16}              → AWS Access Key
AIza[0-9A-Za-z_-]{35}         → Google API Key
ghp_[A-Za-z0-9]{36}           → GitHub PAT
eyJ[A-Za-z0-9_-]*\.eyJ        → JWT token
sk_live_[A-Za-z0-9]+          → Stripe Secret Key
xox[bpsa]-[0-9a-zA-Z-]+      → Slack token
firebaseio\.com                → Firebase database
```

---

## Firebase Enumeration
```
https://project.firebaseio.com/.json
https://project.firebaseio.com/users.json
```

---

## Tool Inventory

| Tool | Purpose |
|------|---------|
| `subfinder` | Passive subdomain enum |
| `dnsx` | DNS resolution |
| `httpx` | HTTP probing + tech detection |
| `katana` | URL crawling |
| `nuclei` | Template-based vuln scanning |
| `ffuf` | Directory/parameter fuzzing |
| `LinkFinder` | JS endpoint extraction |
| `SecretFinder` | JS secret detection |

---

*Source: offensive-osint, web2-recon, recon-scope-triage*
