# Ubuntu 部署 OpenClaw

適合：

- VPS
- 雲端主機
- 家用 Ubuntu server

---

## 1. 更新套件

```bash
sudo apt update && sudo apt upgrade -y
```

---

## 2. 安裝 Node.js

最穩的做法之一是用 NodeSource：

```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
node -v
npm -v
```

---

## 3. 安裝 OpenClaw

```bash
sudo npm install -g openclaw
openclaw --version
```

---

## 4. 啟動 gateway

```bash
openclaw gateway start
openclaw gateway status
```

---

## 5. 驗證

```bash
openclaw status
bash scripts/check-system.sh
bash scripts/check-openclaw.sh
```

---

## 6. 防火牆提醒

如果你需要從其他機器存取，記得檢查：

- UFW
- 雲服務商 Security Group
- 綁定 host / port

---

## 7. 常見問題

### `sudo: command not found`

你可能是 root 帳號，不需要 sudo。

### `openclaw: command not found`

先查：

```bash
npm prefix -g
npm bin -g
```

確認全域 npm bin 路徑有在 PATH 裡。
