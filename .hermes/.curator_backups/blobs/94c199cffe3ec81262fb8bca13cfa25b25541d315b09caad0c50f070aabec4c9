---
name: web-pentesting
description: Web app pentesting and bug bounty methodology.
version: 1.0.0
author: Hermes
platforms: [linux]
metadata:
  hermes:
    tags: [security, pentesting, bug-bounty, web-security]
---

# Web Application Penetration Testing

## When to Use
- Bug bounty hunting on web applications
- Security assessments of web apps
- Finding high-impact vulnerabilities (RCE, SQLi, file upload, auth bypass)
- Educational pentesting with detailed methodology

## Methodology

### Phase 1: Reconnaissance
1. **Technology Fingerprinting**: whatweb, curl -sI
2. **Directory Enumeration**: gobuster, ffuf, dirsearch
3. **Service Discovery**: nmap, naabu
4. **Content Discovery**: katana, waybackurls
5. **API/SOAP Enumeration**: manual testing of /services, ?wsdl

### Phase 2: Vulnerability Identification
1. **Input Validation**: SQLi, XSS, Command Injection
2. **Authentication**: Brute force, default creds, session management
3. **Authorization**: IDOR, privilege escalation
4. **Configuration**: Info disclosure, security headers, error handling
5. **Business Logic**: Workflow bypass, race conditions

### Phase 3: Exploitation
1. **Prove Impact**: Never report unverified vulns
2. **Chain Vulnerabilities**: Combine low-severity for high impact
3. **Document Everything**: Screenshots, request/response pairs
4. **Respect Scope**: Only test authorized targets

### Phase 4: Reporting
1. **Executive Summary**: Business impact in plain language
2. **Technical Details**: Step-by-step reproduction
3. **Evidence**: Request/response pairs, screenshots
4. **Remediation**: Specific fix recommendations

## High-Impact Vulnerabilities to Focus On

### Remote Code Execution (RCE)
- Command injection
- Deserialization (Java, PHP, Python)
- Server-side template injection (SSTI)
- File upload with code execution

### Authentication Bypass
- Default credentials
- Session fixation/hijacking
- JWT vulnerabilities
- OAuth misconfigurations

### SQL Injection
- Union-based
- Error-based
- Blind (boolean/time)
- Second-order

### File Operations
- Path traversal / LFI
- File upload bypass
- SSRF to internal files

### Information Disclosure
- Debug endpoints
- Backup files
- Source code disclosure
- Credential leaks

## Testing Checklist

```bash
# 1. Technology detection
whatweb https://target.com
curl -sI https://target.com

# 2. Directory enumeration
ffuf -u https://target.com/FUZZ -w /usr/share/wordlists/dirb/common.txt -mc 200,301,302,403

# 3. SOAP/API discovery
curl -s https://target.com/services
curl -s https://target.com/api/swagger.json

# 4. HTTP Method testing
for method in GET POST PUT DELETE OPTIONS TRACE; do
  curl -X $method https://target.com -o /dev/null -w "%{http_code}\n"
done

# 5. Security headers check
curl -sI https://target.com | grep -i "strict\|x-frame\|x-content\|csp"

# 6. Error handling
curl -s "https://target.com/'" # SQL error
curl -s "https://target.com/<script>alert(1)</script>" # XSS

# 7. Path traversal
curl -s "https://target.com/..%2f..%2f/etc/passwd"
curl -s "https://target.com/..%5c..%5cwindows\system32\drivers\etc\hosts"
```

## Common Pitfalls

- **False Positives**: Always verify findings before reporting
- **Rate Limiting**: Too many requests can get you blocked
- **Logging**: Your IP and actions are being logged
- **Scope**: Only test authorized targets
- **Legal**: Ensure you have permission before testing

## Tools Reference

| Tool | Use Case | Command |
|------|----------|---------|
| whatweb | Technology detection | `whatweb https://target.com` |
| ffuf | Directory fuzzing | `ffuf -u https://target.com/FUZZ -w wordlist.txt` |
| nuclei | Vuln scanning | `nuclei -u https://target.com -severity critical,high` |
| sqlmap | SQL injection | `sqlmap -u "https://target.com/?id=1" --dbs` |
| hydra | Brute force | `hydra -l admin -P passwords.txt target.com http-post-form` |
| curl | Manual testing | `curl -sv https://target.com` |
| ncat | Smuggling tests | `echo -ne "..." \| ncat -w5 target 80` |

## Session-Specific Learnings

### HTTP Request Smuggling (CL.TE)
- Test by sending both Transfer-Encoding and Content-Length headers
- Use ncat for raw TCP control: `echo -ne "..." | ncat -w5 target 80`
- Python scripts give more control for complex smuggling
- Verify by checking if smuggled requests reach backend

### SOAP Service Enumeration
- Check /services for WSDL listing
- `xsd:anyType` parameter = potential deserialization risk
- AdminService may be exposed (check /services/AdminService)
- Different SOAPAction headers may bypass auth

### Path Traversal on Windows
- Backslash traversal: `.\..\..\`
- Encoded: `%5c` for `\`, `%2f` for `/`
- Semicolon bypass: `..;/..;/`
- 403 response = file exists but blocked

### Authentication Testing
- Try default creds for ICS/SCADA: admin:admin, admin:nordex
- Check for username enumeration via different error messages
- Test with session cookies from unauthenticated requests
- Brute force with common password lists

## References

- [OWASP Testing Guide](https://owasp.org/www-project-web-security-testing-guide/)
- [PortSwigger Web Security Academy](https://portswigger.net/web-security)
- [HackTricks](https://book.hacktricks.xyz/)
- [PayloadsAllTheThings](https://github.com/swisskyrepo/PayloadsAllTheThings)