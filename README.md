---

# 🧭 Netdata with GitHub OAuth2 Authentication via oauth2-proxy

This project runs **Netdata**, a real-time monitoring dashboard, protected by **GitHub OAuth2 authentication** using [`oauth2-proxy`](https://oauth2-proxy.github.io/oauth2-proxy/). It’s all wrapped up inside Docker with `host` networking and ready to integrate with **Nginx Proxy Manager (NPM)**.

---

## 📦 Services

- `netdata`: System performance monitor (host network, no auth by default)
- `oauth2-proxy`: Acts as an auth gateway between users and Netdata, using GitHub OAuth
- (Optional) `Nginx Proxy Manager`: Manages HTTPS, domain routing, and SSL via Let's Encrypt

---

## 🧰 Prerequisites

- Docker & Docker Compose
- GitHub OAuth App
- Domain (e.g. `netdata.sppidy.in`)
- Nginx Proxy Manager or any reverse proxy handling HTTPS

---

## 🔐 Setting up GitHub OAuth2

1. Go to [GitHub Developer Settings](https://github.com/settings/developers)
2. Click **"New OAuth App"**
3. Fill in:

   | Field                 | Value                                       |
   |----------------------|---------------------------------------------|
   | Application Name     | `Netdata Dashboard`                         |
   | Homepage URL         | `https://netdata.sppidy.in`                |
   | Authorization Callback URL | `https://netdata.sppidy.in/oauth2/callback` |

4. After creating, note the:
   - **Client ID**
   - **Client Secret**

---

## 🔑 Generate `COOKIE_SECRET`

You need a base64-encoded secret that decodes to **32 raw bytes**:

```bash
openssl rand -base64 32 | tr -- '+/' '-_'
```

Use the output in your `.env` or directly in the compose file.

---

## 📁 `docker-compose.yaml`

```yaml
services:
  netdata:
    image: netdata/netdata
    container_name: netdata
    pid: host
    network_mode: host
    restart: unless-stopped
    cap_add:
      - SYS_PTRACE
      - SYS_ADMIN
    security_opt:
      - apparmor:unconfined
    volumes:
      - ./netdataconfig:/etc/netdata
      - ./netdatalib:/var/lib/netdata
      - ./netdatacache:/var/cache/netdata
      - /:/host/root:ro,rslave
      - /etc/passwd:/host/etc/passwd:ro
      - /etc/group:/host/etc/group:ro
      - /etc/localtime:/etc/localtime:ro
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /etc/os-release:/host/etc/os-release:ro
      - /var/log:/host/var/log:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro

  oauth2-proxy:
    image: quay.io/oauth2-proxy/oauth2-proxy
    container_name: oauth2-proxy
    network_mode: host
    restart: always
    environment:
      OAUTH2_PROXY_PROVIDER: github
      OAUTH2_PROXY_CLIENT_ID: <your-client-id>
      OAUTH2_PROXY_CLIENT_SECRET: <your-client-secret>
      OAUTH2_PROXY_COOKIE_SECRET: <your-32-byte-base64-secret>
      OAUTH2_PROXY_COOKIE_SECURE: "true"
      OAUTH2_PROXY_GITHUB_USERS: sppidy
      OAUTH2_PROXY_EMAIL_DOMAINS: "*"
      OAUTH2_PROXY_UPSTREAMS: "http://localhost:19999"
      OAUTH2_PROXY_HTTP_ADDRESS: "0.0.0.0:4180"
      OAUTH2_PROXY_REDIRECT_URL: "https://netdata.sppidy.in/oauth2/callback"
    depends_on:
      - netdata
```

> 🔁 Replace `<your-client-id>`, `<your-client-secret>`, and `<your-32-byte-base64-secret>` accordingly.

---

## 🌐 Setting up Nginx Proxy Manager

1. Add a new **Proxy Host**
2. Domain Name: `netdata.sppidy.in`
3. Forward to: `localhost:4180`
4. Enable Websockets
5. SSL (Managed by Cloudflare)
6. Save

---

## ✅ Access Control

You can lock access to **only yourself** using:

```yaml
OAUTH2_PROXY_GITHUB_USERS: sppidy
```

> You can allow teams, orgs, or domains too. Check: https://oauth2-proxy.github.io/oauth2-proxy/configuration/overview/

---

## Screenshots
![OuthSS](https://github.com/sppidy/elevate_internship_devops/blob/elevate-labs-task7/screenshots/oauth.png)
![PreDashboardSS](https://github.com/sppidy/elevate_internship_devops/blob/elevate-labs-task7/screenshots/netdata_predashboard.png)
![DashboardSS](https://github.com/sppidy/elevate_internship_devops/blob/elevate-labs-task7/screenshots/netdata_dashboard.png)

---

## 🚀 Deploy

```bash
docker compose up -d
```

Navigate to `https://netdata.sppidy.in`, and you'll be prompted with GitHub auth before seeing the dashboard.

---

## 🛠️ Troubleshooting

- **Cookie error**: Make sure your cookie secret decodes to exactly 16, 24, or 32 bytes
- **404 after login**: Check your GitHub redirect URL is exact
- **No metrics**: Ensure Netdata runs on `host` mode (already set ✅)

---
