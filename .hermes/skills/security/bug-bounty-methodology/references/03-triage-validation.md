# 03 — Triage & Validation (5-Question Gate)

Distilled from `triage-validation`. Run BEFORE writing any report. One wrong answer = kill the finding.

---

## THE 5-QUESTION GATE

Ask IN ORDER. One wrong answer = STOP immediately.

### Q1: Can an attacker use this RIGHT NOW, step by step?

```
1. Setup:   I need [own account / another user's ID / no account]
2. Request: [exact HTTP method, URL, headers, body — copy-paste ready]
3. Result:  I can [read / modify / delete] [exact data shown]
4. Impact:  The real-world consequence is [ATO / PII read / money stolen]
5. Cost:    Time: [X minutes], Capital: [$0 / $X]
```

**If you CANNOT write step 2 as a real HTTP request → KILL IT.**

### Q2: Is the impact on the program's accepted impact list?

| Tier | Typical examples |
|------|-----------------|
| Critical | Any-user ATO without interaction, RCE, SQLi with data exfil |
| High | Mass PII exfil, privilege escalation, internal SSRF with data |
| Medium | IDOR on specific user non-critical data, XSS requiring click |
| Low | Non-sensitive info disclosure, clickjacking with PoC |

**If bug maps to listed exclusion → KILL IT.**

### Q3: Is this already known or accepted behavior?

Search: disclosed reports, GitHub issues, CHANGELOG, API docs.

**If acknowledged/design decision → KILL IT.**

### Q4: Can you prove impact beyond "technically possible"?

- XSS → show actual cookie theft, not just `alert(1)`
- SSRF → hit internal endpoint returning data, not just DNS ping
- SQLi → show actual data exfil, not just error message
- IDOR → show actual other-user's data, not just 200 status

**If "technically possible" only → DOWNGRADE, not kill.**

### Q5: Is this a known-invalid bug class?

Check NEVER SUBMIT list. If on list without chain → **KILL IT.**

---

## NEVER SUBMIT LIST (Without a Chain)

- Missing security headers without exploit chain
- Clickjacking on non-sensitive pages
- Self-XSS (requires user to paste into console)
- Verbose error messages without sensitive data
- Cookie without Secure/HttpOnly (no hijack chain)
- Version disclosure without exploit path
- Missing rate limiting without demonstrated brute-force
- TLS/SSL issues without demonstrated downgrade/MITM
- CSRF on logout / non-state-changing actions
- Open redirect without chain

## CONDITIONALLY VALID WITH CHAIN

| Finding | Chain needed |
|---------|-------------|
| Open redirect | → OAuth token theft → ATO |
| Self-XSS | → CSRF to store in admin panel → stored XSS |
| Missing CSP | → Existing XSS becomes exploitable |
| Cookie without Secure | → Network sniffing in MITM |
| Username enumeration | → Credential stuffing with valid usernames |

---

## 4 PRE-SUBMISSION GATES

1. **Is the PoC reproducible?** — Re-test from scratch
2. **Is the severity defensible?** — Argue it to a skeptical triager
3. **Is the report free of "could potentially"?** — Every claim proven
4. **Is all evidence redacted?** — Read `04-evidence-hygiene.md`

---

## THE LAYER-ORDERING TRAP

Before claiming auth bypass, verify which layer rejects:
1. WAF / CDN edge
2. Reverse proxy / load balancer
3. Application auth middleware
4. Business logic / authorization layer

A 401 from the WAF ≠ 401 from the app. Test with WAF bypassed (origin IP).

---

## CVSS 3.1 QUICK REFERENCE

| Score range | Severity | Example |
|-------------|----------|---------|
| 9.0–10.0 | Critical | Any-user ATO, RCE, admin auth bypass |
| 7.0–8.9 | High | SQLi with data exfil, stored XSS all users |
| 4.0–6.9 | Medium | IDOR on PII, XSS requiring click |
| 0.1–3.9 | Low | Info disclosure, clickjacking |

Common scores:
- Any-user ATO: **9.8 Critical**
- SQLi with data exfil: **8.6–9.8**
- IDOR on PII: **6.5 Medium**
- Stored XSS on admin panel: **5.4–7.5**
- Open redirect (standalone): **6.1 Medium**

---

*Source: triage-validation SKILL.md (417 lines)*
