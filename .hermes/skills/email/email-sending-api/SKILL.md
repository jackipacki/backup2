---
name: email-sending-api
description: "Send email via REST APIs. Tier limits, schemas, pitfalls."
version: 0.1.0
author: Hermes Agent
license: MIT
platforms: [linux, macos, windows]
metadata:
  hermes:
    tags: [Email, API, Sending, Testing, Automation]
    related_skills: [himalaya, email-inbox-triage]
---

# Email Sending API

Send email programmatically via third-party REST APIs. This skill covers API
formats, tier limitations, and SDK pitfalls — NOT SMTP direct-send (use
himalaya for that).

## When to Use

- User asks to send a test/transactional email and no local SMTP is available.
- User cannot use phone-verification-restricted services (most API platforms).
- Need to send from an ephemeral address without owning a domain.

Don't use for: reading/managing an existing mailbox (use himalaya or
google-workspace instead).

## Procedure

### 1. Identify the constraint
Check whether the user can provide an API key. If not, guide them to sign up.
Prioritize services that do NOT require phone verification during signup
(MailSlurp, Resend).

### 2. Verify tier limits BEFORE sending
Free tiers almost always block external delivery. Check the plan docs or hit
the endpoint and read the error. Do not assume the free tier works for
external addresses.

### 3. Use the correct API format
Each provider has its own schema. Load the reference file for the provider
you're using (see `references/` directory). Never guess field shapes — the
`to` field type (string vs array) varies by endpoint.

### 4. Report honestly
If the free tier blocks external sending, say so immediately. Offer alternatives:
- Upgrade the provider plan
- Use a different provider with a more generous free tier
- Use local SMTP if available (himalaya skill)

## Pitfalls

- **MailSlurp free tier blocks external email addresses.** Only MailSlurp
  inboxes and verified domains work. Error: `E_429_SEND_BLOCK`.
- **MailSlurp Python SDK is outdated.** Newer `account_region` values (e.g.
  `US_WEST_2_ACCOUNT_SES_3`) cause `ValueError` during deserialization. Use
  raw HTTP/curl instead of the SDK.
- **`to` field type varies by endpoint.** MailSlurp `/sendEmail` expects a
  plain string for `to`, not an array. The old `SendEmailOptions` SDK model
  uses an array. Check the OpenAPI spec for the endpoint you're calling.
- Direct SMTP to protonmail.ch times out from most cloud VMs (port 587
  blocked or rate-limited).

## References

- `references/mailslurp.md` — MailSlurp API format, auth, free-tier limits,
  SDK issues
