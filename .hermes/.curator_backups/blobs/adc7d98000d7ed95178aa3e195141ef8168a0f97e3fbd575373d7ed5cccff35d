# 09 — Enterprise Platform Attack Chains

Distilled from `m365-entra-attack`, `okta-attack`, `vmware-vcenter-attack`, `enterprise-vpn-attack`, `cloud-iam-deep`, `hunt-sharepoint`, `hunt-k8s`.

---

## M365 / Entra ID

AADSTS error codes reveal config: `50011` = redirect_uri mismatch, `50105` = user not assigned, `700016` = app not found.

User enumeration: `GetUserRealm` endpoint reveals managed vs federated. Login error strings: "no account" vs "wrong password".

ROPC (password grant): works when MFA not enforced + legacy auth not blocked. Smart Lockout: 10 attempts → 60s lockout. Rule: 1-2 attempts per user max.

SAML SSO browser flow: capture SAMLRequest → modify NameID → impersonate.

---

## Okta — 8 reports

Tenant discovery: `https://{company}.okta.com/.well-known/openid-configuration`
User enumeration: login error strings, factor enrollment, password reset responses.
Push notification fatigue: 5-10 rapid pushes → user approves one.
FastPass abuse: replay token when device trust not enforced.
OIDC redirect_uri: same patterns as OAuth (subdomain, path traversal, open redirect).

---

## VMware vCenter — 10 reports

CVE chain:
- CVE-2021-21972 → vRealize unauth file upload (RCE)
- CVE-2021-21985 → vSAN plugin RCE
- CVE-2022-22954 → Workspace ONE SSTI
- CVE-2023-20887 → Aria command injection
- CVE-2024-37085 → ESXi auth bypass

Fingerprint: `/sdk/vimServiceVersions.xml`, `/mob/`, `/ui/`

---

## SSL VPN Appliances

| Appliance | Key CVEs/Attacks |
|-----------|-----------------|
| Cisco ASA | AnyConnect, default creds |
| Fortinet FortiOS | CVE-2022-40684 |
| Citrix NetScaler | CVE-2023-3519 (RCE) |
| Palo Alto GlobalProtect | CVE-2024-3400 (cmd injection) |
| Pulse/Ivanti | CVE-2023-46805 + CVE-2024-21887 |
| F5 BIG-IP | CVE-2022-1388 (auth bypass via X-Forwarded-For) |

General: default creds, SAML flow manipulation, cert-based auth bypass.

---

## Cloud IAM — 6 reports

**AWS**: IMDS (`169.254.169.254`), STS chaining, S3 bucket enumeration.
**Azure**: Managed Identity abuse via SSRF → IMDS → token, Entra app registrations.
**GCP**: Metadata server (`metadata.google.internal`), service account key exposure.

**Kubernetes (13 reports)**:
- Kubelet 10250 exec (SPDY/WebSocket, not plain POST)
- etcd 2379 unauthenticated
- RBAC misconfig: `kubectl auth can-i --list`
- SA tokens: `/var/run/secrets/kubernetes.io/serviceaccount/token`

---

## SharePoint On-Prem — 1 report

Anonymous endpoints: `/_layouts/15/viewlsts.aspx`, `/_api/web/lists`, `_vti_bin/`
ToolShell chain (CVE-2025-53770): anonymous `download.aspx?SourceUrl=` → SSRF → RCE
SafeControl enumeration: `/_layouts/15/viewtype.aspx?List=...`

---

*Source: m365-entra-attack, okta-attack (8), vmware-vcenter-attack (10), enterprise-vpn-attack, cloud-iam-deep (6), hunt-sharepoint (1), hunt-k8s (13)*
