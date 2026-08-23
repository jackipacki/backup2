# 07 — Hunt Auth & Identity (Auth Bypass, OAuth, SAML, MFA, ATO)

Distilled from `hunt-auth-bypass`, `hunt-oauth`, `hunt-saml`, `hunt-mfa-bypass`, `hunt-ato`, `hunt-session`.

---

## Auth Bypass — 12+ patterns

### Header Injection
- `X-Forwarded-For: 127.0.0.1` → bypass IP whitelist
- `X-Original-URL: /admin` → path-based auth bypass
- `X-rewrite-url: /admin` → Apache-specific
- `X-Custom-IP-Authorization: 127.0.0.1`

### Method Tampering
- POST → GET on admin endpoints
- Add `X-HTTP-Method-Override: DELETE`
- Add `_method=DELETE` in body

### Parameter Pollution
- Duplicate parameters: `?admin=true&user=normal&admin=false`
- JSON parameter injection: `{"admin": false, "admin": true}`

### JWT Attacks (see also `hunt-jwt-crypto`)
- `alg: none` → signature bypass
- RS256 → HS256 key confusion (use public key as HMAC secret)
- Audience confusion: change `aud` claim
- Expiration bypass: modify `exp` claim

### Race Conditions on Auth
- Session create race: two simultaneous logins → two valid sessions
- Password change race: change email + request password reset simultaneously

---

## OAuth 2.0 / OIDC — 19 disclosed reports

### redirect_uri Manipulation
- Add subdomain: `https://target.com.evil.com/callback`
- Add path: `https://target.com/callback/../../../evil`
- Use `@` trick: `https://target.com@evil.com/callback`
- Open redirect chaining: `https://target.com/redirect?url=https://evil.com`

### Scope Escalation
- Add `admin` or `write` scope to authorization request
- Remove scope parameter entirely (some servers default to full access)
- Modify scope post-authorization

### PKCE Bypass
- Remove `code_verifier` from token exchange
- Use pre-image of stored `code_challenge`

### Token Theft Chains
```
Open redirect → OAuth code in URL → Exchange for token → ATO
Open redirect → OAuth token in fragment → postMessage to attacker
```

---

## SAML / SSO Attacks

### XML Signature Wrapping (XSW)
1. Original signed assertion → move to `<dsig:Reference>` position
2. Insert malicious assertion where app reads
3. Signature remains valid over original, app processes malicious one

### Signature Stripping
- Remove `<dsig:Signature>` element entirely
- Some SPs accept unsigned assertions after signature present

### Key Confusion
- RSA public key (from IdP metadata) used as HMAC secret
- Sign with public key using HS256 → app verifies with same public key

### IdP Switching
- Modify `Issuer` in SAML request to point to attacker-controlled IdP
- If SP doesn't validate Issuer against whitelist → attacker controls authentication

---

## MFA / 2FA Bypass — 7 patterns

1. **Skip 2FA step**: Navigate directly to `/dashboard` after password login
2. **Response manipulation**: Change `{"requiresMFA": true}` → `false` in response
3. **Backup code brute force**: 6-digit codes with no rate limiting
4. **OTP replay**: Same OTP works multiple times
5. **Trust device bypass**: Set device cookie → skip MFA permanently
6. **SMS interception**: SS7 attack or SIM swap (advanced)
7. **TOTP algorithm confusion**: SHA-1 vs SHA-256, epoch alignment

---

## Account Takeover (ATO) — 9 paths

1. **Password reset poisoning**: Host header injection → reset link to attacker
2. **OAuth token theft**: Open redirect → code/token interception
3. **Session fixation**: Inject session ID before login → hijack after login
4. **Email change + password reset**: Change email → reset password on new email
5. **Password reset token in URL**: Token exposed in Referer header
6. **Username enumeration + credential stuffing**: Enumerate valid users → brute force
7. **API key / access token in source**: Hardcoded tokens in JS/mobile app
8. **JWT algorithm confusion**: forge token → impersonate any user
9. **SAML assertion forgery**: XSW/stripping → impersonate any user

---

## Session Management — 18 disclosed reports

### Session Fixation
- Session ID doesn't regenerate on login → attacker sets session ID before victim logs in

### Insufficient Invalidation
- Logout doesn't invalidate server-side session
- Password change doesn't invalidate other sessions
- Email change doesn't invalidate existing sessions

### Predictable Session IDs
- Low entropy in session tokens
- Sequential or timestamp-based generation
- JWT `exp` claim too far in future

---

## Forgot Password / Account Recovery — 5 patterns

1. **Username enumeration**: Different responses for valid vs invalid email
2. **Reset token in response body**: Token leaked in API response
3. **Token not invalidated after use**: Same token works twice
4. **Token entropy too low**: Brute-forceable reset token
5. **Host header injection in reset email**: Reset link sent to attacker

---

*Source: hunt-auth-bypass, hunt-oauth (19 reports), hunt-saml, hunt-mfa-bypass, hunt-ato, hunt-session (18 reports)*
