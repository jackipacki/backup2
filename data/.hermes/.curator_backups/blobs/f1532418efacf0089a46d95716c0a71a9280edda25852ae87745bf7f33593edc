# 04 — Evidence Hygiene & PoC Redaction

Distilled from `evidence-hygiene`. Use BEFORE capturing any screenshot, exporting any HAR, or attaching any evidence.

---

## Core Principle

Bug-bounty evidence is meant to convince a triager. Anything beyond that — live cookies, real-user PII, internal trace IDs — should not be in the evidence.

## Two Categories of Sensitive Data

| Category | Examples | Treatment |
|----------|----------|-----------|
| **Your-account secrets** | Session cookies, OAuth tokens, refresh tokens, API keys | Always redact |
| **Other users' PII** | Real names, emails, phones, addresses, profile photos | Redact unless demonstrating cross-account impact |
| **Triager-useful metadata** | Trace IDs, request IDs, timestamps, test account UID, GraphQL operation names | **Leave visible** |
| **Test-account passwords** | Throwaway passwords (e.g., `Testing@5678`) | Acceptable if you rotate immediately after submission |

---

## Cookie Redaction Protocol

### What must be masked

- Session cookie (`authn`, `session`, `sid`, `__Secure-id`)
- `csrf-token` bound to session
- `Authorization` headers (Bearer, JWT)
- `Cookie` request header values (session-bearing)
- `Set-Cookie` response header values (session-bearing)

### What's safe to leave visible

- Cloudflare cookies (`__cf_bm`, `_cfuvid`) — bot management
- Analytics cookies (`ajs_anonymous_id`, `_ga`)
- Trace IDs (`x-datadog-trace-id`, `x-request-id`)
- Server/framework headers
- Your test account email/UID

### Redaction Methods (ranked by practicality)

**Method A — Don't capture cookies in the first place (preferred)**
- DevTools Console PoCs: use `credentials: 'include'` — cookies auto-sent, not echoed
- Burp Repeater: drag request/response divider DOWN to hide request body before screenshot

**Method B — Black-bar in image editor**
- macOS Preview → Tools → Annotate → Rectangle → fill black → drag over cookie value
- Burp Proxy → Match and Replace → pre-emptively redact cookie values

**Method C — Find/replace in raw text** (HAR files, terminal transcripts)

### Pre-Screenshot Checklist

```
[ ] Network tab Headers panel collapsed or out of frame
[ ] Burp's Request panel hidden behind divider drag
[ ] No "Copy as cURL" output visible on screen
[ ] DevTools Application → Storage → Cookies tab closed
[ ] Browser URL bar doesn't show session token in query string
```

After capturing:
```
[ ] Open screenshot at full resolution before saving
[ ] Search for session cookie name substring — if present, redact
[ ] Search for literal first 6 chars of cookie value — if present, redact
```

---

## PII Black-Bar Discipline

### What to mask in other-user data

| Item | Treatment |
|------|-----------|
| Real names | Black-bar or replace with "User A" |
| Email addresses | Black-bar or replace with "redacted@test.com" |
| Phone numbers | Black-bar |
| Physical addresses | Black-bar |
| Profile photos / faces | Black-bar faces |
| Account numbers / payment info | Black-bar |

### What is safe to leave visible

- Usernames (they're public)
- Trace IDs / request IDs
- Request bodies with test-account data
- Response shapes / field names
- GraphQL operation names

---

## HAR File Sanitization

### jq filter for Cookie/Set-Cookie/Authorization headers

```bash
jq '
  .log.entries[].request.headers |=
    map(select(.name != "Cookie" and .name != "Authorization"))
  | .log.entries[].response.headers |=
    map(select(.name != "Set-Cookie"))
' input.har > sanitized.har
```

### Post-submission rotation hygiene

After submission, rotate any credentials visible in evidence:
- Change test account password
- Invalidate session tokens
- Rotate API keys if exposed

---

## Screenshot Capture Order

1. Redact first (apply Method A/B/C)
2. Capture the PoC screenshot
3. Verify at full resolution
4. Search for leaked secrets
5. Save with descriptive filename: `vuln-class_endpoint_evidence_N.png`

---

*Source: evidence-hygiene SKILL.md (375 lines)*
