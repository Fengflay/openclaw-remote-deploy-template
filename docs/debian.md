# Debian 部署 OpenClaw

適合：

- Debian VPS
- 輕量 Linux 伺服器

---

## 1. 更新系統

```bash
sudo apt update && sudo apt upgrade -y
```

---

## 2. 安裝必要工具

```bash
sudo apt install -y curl git ca-certificates
```

---

## 3. 安裝 Node.js

```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
node -v
npm -v
```

---

## 4. 安裝 OpenClaw

```bash
sudo npm install -g openclaw
openclaw --version
```

---

## 5. 啟動並檢查

```bash
openclaw gateway start
openclaw gateway status
openclaw status
```

---

## 6. 排錯提醒

如果遇到版本問題、config 問題、gateway 問題，直接看：

- `troubleshooting.md`
