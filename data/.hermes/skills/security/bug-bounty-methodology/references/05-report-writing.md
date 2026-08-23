# 05 — Report Writing

Distilled from `report-writing` and `bugcrowd-reporting`. Templates, tone, CVSS scoring, title formula, and submission tactics.

---

## THE MOST IMPORTANT RULE

> **Never use "could potentially" or "could be used to" or "may allow."** Either it does the thing or it doesn't.

```
BAD:  "This vulnerability could potentially allow an attacker to access user data."
GOOD: "An attacker can access any user's order history by changing the user_id
       parameter to the target user's ID. I confirmed this using two test accounts:
       attacker@test.com (ID 123) successfully retrieved victim@test.com (ID 456)
       orders, including their shipping address and payment method last 4 digits."
```

---

## TITLE FORMULA

```
[Bug Class] in [Exact Endpoint/Feature] allows [attacker role] to [impact] [victim scope]
```

**Good titles:**
```
IDOR in /api/v2/invoices/{id} allows authenticated user to read any customer's invoice data
Missing auth on POST /api/admin/users allows unauthenticated attacker to create admin accounts
Stored XSS in profile bio field executes in admin panel — allows privilege escalation
SSRF via image import URL parameter reaches AWS EC2 metadata service
Race condition in coupon redemption allows same code to be used unlimited times
```

**Bad titles (vague, useless to triager):**
```
IDOR vulnerability found
Broken access control
XSS in user input
Security issue in API
```

---

## HACKERONE REPORT TEMPLATE

```markdown
## Summary
[One paragraph: what the bug is, where it is, what an attacker can do.
Include: endpoint, method, parameter, data exposed, required access level.]

## Vulnerability Details
**Vulnerability Type:** IDOR / Broken Object Level Authorization
**CVSS 3.1 Score:** 6.5 (Medium) — AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:N
**Affected Endpoint:** GET /api/users/{user_id}/orders

## Steps to Reproduce
**Environment:**
- Attacker account: attacker@test.com, user_id = 123
- Victim account: victim@test.com, user_id = 456
- Target: https://target.com

**Steps:**
1. Log in as attacker@test.com
2. Capture request: GET /api/users/123/orders
3. Change user_id from 123 to 456
4. Observe: full order history of victim@test.com in response, including
   shipping address, email, and last 4 digits of payment method

## Impact
An attacker can enumerate any user's order history, including PII and
purchase data, by incrementing the user_id parameter. This affects all
users on the platform.

## Remediation
[Specific fix recommendation — not just "validate user ownership"]
```

---

## REPORT STRUCTURE PRINCIPLES

1. **Impact-first**: Lead with what the attacker can DO, not what the endpoint "allows"
2. **Human tone**: Triagers are people. Write like you're explaining to a smart colleague.
3. **Specificity**: Exact endpoint, exact parameter, exact data exposed
4. **Proof**: Every claim backed by a reproducible HTTP request
5. **No theoretical language**: "can" not "could potentially"; "does" not "may"

---

## CVSS 3.1 SCORING

### Common scores by bug class

| Class | Typical score | Vector |
|-------|:--:|--------|
| Any-user ATO (no interaction) | 9.8 | AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H |
| SQLi with data exfil | 8.6–9.8 | Depends on auth requirement |
| SSRF to cloud metadata | 8.6–9.1 | AV:N/AC:L/PR:L/UI:N/S:C/C:H/I:H/A:N |
| Stored XSS (admin panel) | 5.4–7.5 | Depends on auth + impact |
| IDOR on PII | 6.5 | AV:N/AC:L/PR:L/UI:N/S:U/C:H/I:N/A:N |
| Open redirect (standalone) | 6.1 | AV:N/AC:L/PR:N/UI:R/S:U/C:H/I:N/A:N |
| Clickjacking (non-sensitive) | 3.1 | AV:N/AC:H/PR:N/UI:R/S:U/C:N/I:L/A:N |

### CVSS 3.1 Metrics

| Metric | Values |
|--------|--------|
| Attack Vector (AV) | Network (N), Adjacent (A), Local (L), Physical (P) |
| Attack Complexity (AC) | Low (L), High (H) |
| Privileges Required (PR) | None (N), Low (L), High (H) |
| User Interaction (UI) | None (N), Required (R) |
| Scope (S) | Unchanged (U), Changed (C) |
| Confidentiality/Integrity/Availability | None (N), Low (L), High (H) |

---

## BUGCROWD-SPECIFIC TACTICS

### VRT Category Search

When no exact VRT match exists:
1. Search VRT for the closest category
2. Use the parent category if no exact child matches
3. Manual severity override with paragraph explaining why the VRT default underrates

### Severity-Request Paragraph

If triager defaults to lower severity:
```
I believe this finding should be rated [X] rather than the VRT default of [Y]
because [specific technical reason tied to CVSS metrics]. The attack requires
[no authentication / low privilege / specific conditions] and results in
[specific impact]. Per the CVSS calculator, this maps to [vector string].
```

### OOS Rebuttal Templates

When triager closes as "Out of Scope":
```
I understand the concern, but I'd like to clarify that [the finding IS in scope
because / the impact IS demonstrable because / the asset IS listed as in-scope
per the program page dated MM/DD/YYYY]. [Specific evidence or program page quote].
```

---

*Source: report-writing SKILL.md (567 lines), bugcrowd-reporting SKILL.md*
