# Free Email API — Send Transactional Emails via REST

Need to send transactional emails from your app without setting up SendGrid, Mailgun, or AWS SES? The **Agent Email Sender API** lets you send plain text, HTML, and template-based emails through a simple REST endpoint. It includes 5 built-in templates, custom SMTP support, and delivery logs — all without an account or credit card.

In this guide you'll learn how to send emails via API, use built-in templates for common use cases, configure your own SMTP server, and track deliveries with the logs endpoint.

#### Plain Text & HTML

Send raw text or fully styled HTML emails with attachments, CC/BCC, and reply-to headers.

#### 5 Built-in Templates

Welcome, alert, invoice, notification, and password reset — just pass variables.

#### Custom SMTP

Bring your own SMTP server or use the built-in Ethereal sandbox for testing.

#### Delivery Logs

Track every email: status, timestamp, message ID, and duration. Up to 100 entries per key.

## Quick Start

Get an API key (free, no signup), then send your first email in one request:

### Step 1: Get an API Key

```
 curl -X POST https://agent-gateway-kappa.vercel.app/v1/agent-email/api/keys/create # Response: { "apiKey": "em_abc123...", "credits": 50, "plan": "free" }
```

### Step 2: Send an Email

curl

Python

Node.js

```
 curl -X POST https://agent-gateway-kappa.vercel.app/v1/agent-email/api/send \ -H "Authorization: Bearer em_abc123..." \ -H "Content-Type: application/json" \ -d '{ "to": "user@example.com", "subject": "Order Confirmation #1234", "html": "<h1>Thank you!</h1><p>Your order has been confirmed.</p>" }' # Response: { "status": "sent", "email_id": "a1b2c3d4-...", "message_id": "<abc@mail.ethereal.email>", "to": ["user@example.com"], "subject": "Order Confirmation #1234", "duration_ms": 342, "preview_url": "https://ethereal.email/message/...", "note": "Using Ethereal test SMTP. Configure your own SMTP for production." }
```

```
 import requests API_KEY = "em_abc123..." BASE = "https://agent-gateway-kappa.vercel.app/v1/agent-email" resp = requests. post ( f"{BASE}/api/send" , headers={ "Authorization" : f"Bearer {API_KEY}" }, json={ "to" : "user@example.com" , "subject" : "Order Confirmation #1234" , "html" : "<h1>Thank you!</h1><p>Your order has been confirmed.</p>" } ) result = resp. json () print (result[ "email_id" ], result[ "preview_url" ])
```

```
 const API_KEY = "em_abc123..." ; const BASE = "https://agent-gateway-kappa.vercel.app/v1/agent-email" ; const resp = await fetch ( `${BASE}/api/send` , { method: "POST" , headers: { "Authorization" : `Bearer ${API_KEY}` , "Content-Type" : "application/json" }, body: JSON. stringify ({ to: "user@example.com" , subject: "Order Confirmation #1234" , html: "<h1>Thank you!</h1><p>Your order has been confirmed.</p>" }) }); const data = await resp. json (); console. log (data.email_id, data.preview_url);
```

The default sandbox uses **Ethereal** (a fake SMTP service). Every email returns a `preview_url` so you can see exactly what was sent — perfect for development and testing.

## API Endpoints

API Endpoints
| Method | Endpoint | Description |
|---|---|---|
| **POST** | `/api/send` | Send email (text or HTML, with attachments) |
| **POST** | `/api/send/template` | Send templated email (welcome, alert, invoice, notification, reset) |
| **POST** | `/api/smtp/configure` | Configure custom SMTP server |
| **POST** | `/api/smtp/verify` | Verify SMTP connection |
| **GET** | `/api/templates` | List available templates and their variables |
| **GET** | `/api/logs` | View delivery logs (up to 100 entries) |
| **GET** | `/api/logs/:emailId` | Get details for a specific email |

## Built-in Email Templates

Instead of writing HTML from scratch, use one of the 5 built-in templates. Just provide the template name and a `variables` object:

### Welcome Email

```
 curl -X POST https://agent-gateway-kappa.vercel.app/v1/agent-email/api/send/template \ -H "Authorization: Bearer em_abc123..." \ -H "Content-Type: application/json" \ -d '{ "to": "newuser@example.com", "subject": "Welcome to Acme!", "template": "welcome", "variables": { "name": "Alice", "message": "Your account is ready. Start building today.", "cta_url": "https://app.example.com/dashboard", "cta_text": "Open Dashboard", "company": "Acme Inc." } }'
```

### Alert / Incident Email

```
 curl -X POST https://agent-gateway-kappa.vercel.app/v1/agent-email/api/send/template \ -H "Authorization: Bearer em_abc123..." \ -H "Content-Type: application/json" \ -d '{ "to": "ops@example.com", "subject": "CRITICAL: Database connection pool exhausted", "template": "alert", "variables": { "severity": "critical", "title": "Database Pool Exhausted", "message": "Primary PostgreSQL pool reached 100% capacity at 14:32 UTC.", "details": "Pool: primary-db\nActive: 100/100\nWaiting: 47\nAvg wait: 12.4s" } }'
```

### Invoice Email

```
 curl -X POST https://agent-gateway-kappa.vercel.app/v1/agent-email/api/send/template \ -H "Authorization: Bearer em_abc123..." \ -H "Content-Type: application/json" \ -d '{ "to": "billing@client.com", "subject": "Invoice #INV-2026-003", "template": "invoice", "variables": { "invoice_id": "INV-2026-003", "date": "2026-03-03", "items": [ {"item": "API Pro Plan (March)", "amount": "$49.00"}, {"item": "Extra API calls (12K)", "amount": "$8.40"} ], "total": "$57.40", "payment_link": "https://pay.example.com/inv-003" } }'
```

### All 5 Templates

All 5 Templates
| Template | Description | Key Variables |
|---|---|---|
| **welcome** | Onboarding email with CTA button | `name`, `message`, `cta_url`, `cta_text`, `company` |
| **alert** | Incident/alert with severity levels | `severity` (info/warning/critical), `title`, `message`, `details` |
| **notification** | General notification with items list | `title`, `message`, `items[]`, `cta_url` |
| **invoice** | Invoice with line items and pay link | `invoice_id`, `items[{item,amount}]`, `total`, `payment_link` |
| **reset** | Password reset with link + optional code | `reset_url`, `expiry`, `code` |

## Custom SMTP Configuration

The default sandbox is great for testing, but for production you'll want your own SMTP server. Configure it once per API key:

```
 # Configure your SMTP server curl -X POST https://agent-gateway-kappa.vercel.app/v1/agent-email/api/smtp/configure \ -H "Authorization: Bearer em_abc123..." \ -H "Content-Type: application/json" \ -d '{ "host": "smtp.gmail.com", "port": 587, "secure": false, "user": "yourname@gmail.com", "pass": "your-app-password" }' # Verify the connection curl -X POST https://agent-gateway-kappa.vercel.app/v1/agent-email/api/smtp/verify \ -H "Authorization: Bearer em_abc123..." {"status": "ok", "message": "SMTP connection verified"}
```

After configuring SMTP, all subsequent emails sent with that API key will use your server instead of the Ethereal sandbox. Works with Gmail, Outlook, Amazon SES, Postmark, or any standard SMTP provider.

## Sending Emails with Attachments

```
 curl -X POST https://agent-gateway-kappa.vercel.app/v1/agent-email/api/send \ -H "Authorization: Bearer em_abc123..." \ -H "Content-Type: application/json" \ -d '{ "to": "team@example.com", "subject": "Monthly Report - March 2026", "text": "Please find the monthly report attached.", "attachments": [ { "filename": "report.pdf", "content": "JVBERi0xLjQK...", "encoding": "base64", "contentType": "application/pdf" } ], "cc": ["manager@example.com"], "replyTo": "noreply@example.com" }'
```

## Delivery Logs

Track every email you've sent with the logs endpoint:

```
 curl https://agent-gateway-kappa.vercel.app/v1/agent-email/api/logs?limit=5 \ -H "Authorization: Bearer em_abc123..." { "total": 12, "emails": [ { "id": "a1b2c3d4-...", "to": ["user@example.com"], "subject": "Order Confirmation #1234", "status": "sent", "messageId": "<abc@mail.ethereal.email>", "timestamp": "2026-03-03T15:42:18.123Z", "duration_ms": 342 } ] }
```

## Real-World Use Cases

#### SaaS Transactional Email

Welcome emails, password resets, billing receipts, and usage alerts. Use templates to skip HTML coding entirely.

#### AI Agent Notifications

Let AI agents send status updates, task completions, and error alerts via email. Works with LangChain, CrewAI, and AutoGPT.

#### Monitoring & Alerting

Send critical/warning/info alerts when your infrastructure has issues. The alert template has built-in severity styling.

#### Invoicing & Billing

Generate professional invoices with line items and payment links. Use the invoice template with dynamic variables.

## Comparison: Free Email API vs Alternatives

Comparison: Free Email API vs Alternatives
| Feature | Agent Email | SendGrid | Mailgun | Amazon SES |
|---|---|---|---|---|
| Free tier | **50 emails** | 100/day | 100/day (1 mo) | 62K/mo (from EC2) |
| Signup required | **No** | Yes + verify | Yes + card | Yes + AWS account |
| Built-in templates | **5 templates** | Editor (paid) | None | None |
| Custom SMTP | **Yes** | No | No | No |
| Delivery logs | **Yes** | Yes | Yes | CloudWatch |
| Attachments | **Yes (base64)** | Yes | Yes | Yes |
| Time to first email | **< 30 seconds** | ~10 minutes | ~15 minutes | ~30 minutes |
| Domain verification | **Not required** | Required | Required | Required |
**Key advantage:** Agent Email gets you sending emails in under 30 seconds — no account creation, no domain verification, no credit card. For production, bring your own SMTP and you get the full power of Gmail, SES, or any provider through a simple REST wrapper.

## FAQ

Do I need to verify a domain to send emails?
No. The built-in Ethereal sandbox lets you send test emails immediately with no domain verification. For production sending, configure your own SMTP server (Gmail, SES, Postmark, etc.) which handles domain authentication.

What is Ethereal and where do my test emails go?
Ethereal is a fake SMTP service by Nodemailer. Emails aren't actually delivered — instead, you get a `preview_url` where you can view the rendered email in your browser. It's ideal for development and testing.

Can I send HTML emails with inline CSS?
Yes. Pass your HTML in the `html` field. Inline CSS is recommended for maximum email client compatibility. The built-in templates already use inline styles optimized for Gmail, Outlook, and Apple Mail.

How many emails can I send for free?
The free tier includes 50 email credits. Each email costs 1 credit. Additional credits can be purchased via the payment endpoint. When using your own SMTP, the API acts as a REST wrapper — actual sending limits depend on your SMTP provider.

Can I send to multiple recipients?
Yes. The `to` field accepts a single email address or an array of addresses. You can also use `cc` and `bcc` fields for carbon copies.

Is this suitable for marketing/bulk email?
This API is designed for transactional emails (order confirmations, alerts, password resets). For bulk marketing campaigns, use a dedicated service like Mailchimp or SendGrid that handles unsubscribe management and CAN-SPAM compliance.