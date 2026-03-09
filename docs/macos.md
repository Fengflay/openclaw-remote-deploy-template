# macOS 部署 OpenClaw

適合：

- Mac mini
- 舊 MacBook
- 家裡當常駐主機的 macOS 裝置

---

## 1. 檢查 Homebrew

```bash
brew --version
```

如果沒有，先安裝 Homebrew：

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

---

## 2. 安裝 Node.js

```bash
brew install node
node -v
npm -v
```

建議 Node 20+。

---

## 3. 安裝 OpenClaw

```bash
npm install -g openclaw
openclaw --version
```

---

## 4. 啟動 gateway

```bash
openclaw gateway start
openclaw gateway status
```

---

## 5. 檢查狀態

```bash
openclaw status
bash scripts/check-openclaw.sh
```

---

## 6. 如果要長時間常駐

你可以考慮：

- 開機自動登入
- 保持 Terminal / tmux session
- 用 launchd 或其他方式做常駐管理

---

## 7. 常見問題

### Node 太舊

升級：

```bash
brew upgrade node
```

### gateway 啟不來

先看：

```bash
openclaw gateway status
openclaw status
```

再看排錯文件：

- `troubleshooting.md`
