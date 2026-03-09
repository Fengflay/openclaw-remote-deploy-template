# Raspberry Pi 部署 OpenClaw

適合：

- Raspberry Pi 4 / 5
- 家中低功耗常駐主機

---

## 1. 更新系統

```bash
sudo apt update && sudo apt upgrade -y
```

---

## 2. 安裝工具

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

## 5. 啟動 gateway

```bash
openclaw gateway start
openclaw gateway status
```

---

## 6. Raspberry Pi 特別提醒

- 記憶體通常比較少，別一次跑太多重任務
- 如果是 2GB 機型，模型和工作流要保守一點
- 建議搭配 swap、監控記憶體與溫度

---

## 7. 驗證

```bash
openclaw status
bash scripts/check-system.sh
bash scripts/check-openclaw.sh
```
