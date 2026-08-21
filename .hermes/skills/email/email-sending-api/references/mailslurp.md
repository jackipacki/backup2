# MailSlurp API Reference

## Authentication

Header: `x-api-key: <API_KEY>`

API key management: https://app.mailslurp.com/developers/api-keys/
Free signup requires only email (no phone verification).

## Base URL

`https://api.mailslurp.com`

## OpenAPI Docs

- Spec: https://api.mailslurp.com/v2/api-docs/
- Swagger UI: https://swagger.mailslurp.com/

## Create Inbox

```
POST /inboxes
```

No body required. Returns inbox with `id` and `emailAddress`.
The inbox `emailAddress` can be used as the sender for outgoing email.

## Send Email (Simple)

```
POST /sendEmail
Content-Type: application/json
```

Schema: `SimpleSendEmailOptions`

```json
{
  "to": "recipient@example.com",       // STRING, not array
  "subject": "Subject line",            // optional
  "body": "HTML or plain text body",    // optional
  "senderId": "inbox-uuid-here"         // optional — inbox to send FROM
}
```

**Critical:** The `to` field is a **string**, not an array. Sending an array
will produce a 400 `MismatchedInputException`.

If `senderId` is omitted, MailSlurp creates a random sender address.

## Free Tier Limitations

- **Cannot send to external email addresses.** Only MailSlurp inboxes and
  verified domains are allowed.
- Error code: `E_429_SEND_BLOCK` with message:
  "Your current plan does not permit sending to external email addresses."
- Can receive emails to any created inbox (inbound works fine).
- Workaround: upgrade to PRO plan for external sending.

## Python SDK Issues

Package: `mailslurp-client` (pip install)

**Outdated SDK** — newer API responses include `account_region` values not in
the SDK's enum list, causing `ValueError` during deserialization. Affected
values: `US_WEST_2_ACCOUNT_SES_3`, `EU_WEST_1_ACCOUNT_SES_3`, and any
regions added after the SDK's last release.

**Workaround:** Use raw `curl`/`requests` instead of the Python SDK.

## Alternatives for External Sending (Free Tier)

- **Resend.com** — 100 emails/day free, email-only signup (no phone).
  API: `https://api.resend.com/emails` with `Authorization: Bearer <key>`.
  Must verify a domain or use their `onboarding@resend.dev` sandbox.
- **Brevo (Sendinblue)** — 300 emails/day free, email-only signup.
- **Elastic Email** — 100 emails/day free.

## Direct SMTP

ProtonMail SMTP (`mail.protonmail.ch:587`) times out from most cloud VMs.
Do not rely on direct SMTP to ProtonMail — use an API-based sender instead.
