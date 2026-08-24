# 02 — Thinking Framework & Mindset

Distilled from `bb-methodology` PART 1 and `redteam-mindset`. The cognitive models that separate top-1% hunters from the noise.

---

## Core Principle

> Hunting is not "find a bug" — it is "prove an attack scenario." Think like an attacker with a specific goal, not a scanner.

## 5 Ultimate Goals (Pick One Per Session)

1. **Confidentiality** — steal data the attacker shouldn't see
2. **Integrity** — modify data the attacker shouldn't change
3. **Availability** — disrupt service (app-level DoS only)
4. **Account Takeover** — control another user's account
5. **RCE** — execute commands on the server

## 4 Thinking Domains

### 1. Critical Thinking (Deep Analysis)

**Question trust boundaries:**
- Frontend control disabled? → Send request directly via proxy
- `user_role=user` cookie? → Change to `admin`
- `price=1000` in POST? → Change to `1`
- `<script>` blocked? → Try `<img onerror=...>`

**Reverse-engineer developer psychology:**
- Feature A has auth checks → Similar feature B probably doesn't
- Complex flows (coupon + points + refund) → Edge cases have bugs
- `/api/v2/user` exists → Does `/api/v1/user` still work with weaker auth?

**What-If experiments:**
- Skip checkout → hit `/checkout/success` directly
- Skip 2FA → navigate to `/dashboard`
- Send coupon request 10x simultaneously → Race condition?

### 2. Multi-Perspective

| Perspective | What to check |
|-------------|---------------|
| Horizontal (same role) | User A's token + User B's ID → IDOR |
| Vertical (different role) | Regular user → `/admin/deleteUser` |
| Data flow (proxy view) | Hidden params: `debug=false`, `discount_rate` |
| Time/State | Race conditions, post-delete session reuse |
| Client environment | Mobile UA → legacy API with weaker auth |
| Business impact | "What's the $ damage if this breaks?" |

### 3. Tactical Thinking (Pattern Detection)

- **Naming anomaly**: `userId` everywhere but suddenly `user_id` → different dev
- **Error diff**: Same 403 but different JSON → different backends
- **Environment diff**: Prod vs Dev/Staging → debug headers, CSP disabled
- **Version diff**: JS file before/after update → new endpoints
- **Supply chain**: Check framework/library versions for known CVEs

### 4. Strategic Thinking (Big Picture)

- **Asymmetry**: Defender must patch ALL holes. You only need ONE.
- **Intuition engineering**: Log why something "feels wrong." Verify later.
- **Unknown management**: Can't understand? Add to "investigate later" list.

---

## Red-Team Operator Discipline

### Data Minimization Boundary

- An access vuln is proven by the MISSING CHECK, not volume of data copied
- 3 records = complete proof. 3,000 records = same finding + liability
- "Keep digging" = next endpoint/host/class. NOT "enumerate every record"
- Client saying "dig more" does NOT override this — push back

### Self-Throttling Anti-Patterns (Flag Immediately)

1. Asking "want me to continue?" mid-run after user chose full engagement
2. Stopping at first-class 401/403 — there are 12+ auth-bypass classes
3. Seeing a constant token/hash and not chasing it
4. Reading robots.txt but NOT reading Disallow lines
5. Treating soft-404 as "noted" — read it, grep it, diff it
6. OpenAPI exposed → finding logged with only 4 of N endpoints probed
7. "Volume is a problem" — 3000 well-tagged requests is normal cadence

### Sister-App Pattern Recognition

When you confirm a vuln on app A:
1. Identify shared infrastructure (same IP, cert, headers, cookie name)
2. Sweep all sisters with the SAME payload immediately
3. Document the CLASS of vulnerability, not just one finding
4. Recommend class-fix, not just one app fix

---

## Amateur vs Pro Comparison

| Phase | Amateur | Pro |
|-------|---------|-----|
| Recon | Main domain only | Shadow IT, dev environments, all assets |
| Discovery | Look for errors | Design contradictions, logic flaws |
| Exploit | Give up when blocked | Build filter-bypass payloads |
| Escalation | Report phenomenon only | Chain to real harm (session steal, ATO) |
| Feasibility | Include unrealistic conditions | Minimize attack prerequisites |
| Reporting | State facts only | Quantify business risk |
| Retest | Check if old PoC fails | Analyze fix method, find incomplete patches |

---

*Source: bb-methodology SKILL.md PART 1, redteam-mindset SKILL.md*
