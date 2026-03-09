# OpenClaw Remote Deploy Template

給 **不太會 SSH**、但想把 OpenClaw（龍蝦）部署到遠端機器上的人用的 GitHub 模板。

這個模板的目標很簡單：

- 讓你知道該選哪一種作業系統
- 讓你有可以直接貼上執行的命令
- 讓你遇到錯誤時知道先查哪裡
- 讓你能把環境整理好，再交給 OpenClaw 接手

---

## 支援系統

第一版支援：

- macOS
- Ubuntu
- Debian
- Raspberry Pi OS

額外附上：

- Docker 方案
- Windows WSL 準備說明
- SSH 新手指南
- 故障排查文件

---

## 這個模板裡有什麼

```text
openclaw-remote-deploy-template/
├─ README.md
├─ .env.example
├─ config/
│  └─ openclaw.example.json
├─ docs/
│  ├─ no-ssh-beginner-guide.md
│  ├─ macos.md
│  ├─ ubuntu.md
│  ├─ debian.md
│  ├─ raspberry-pi.md
│  ├─ docker.md
│  ├─ windows-wsl.md
│  └─ troubleshooting.md
└─ scripts/
   ├─ install-macos.sh
   ├─ install-ubuntu.sh
   ├─ install-debian.sh
   ├─ install-pi.sh
   ├─ check-system.sh
   └─ check-openclaw.sh
```

---

## 新手先看：你該選哪個方案？

### 如果你是這些情況

- **家裡有 Mac mini / 舊 Mac** → 看 `docs/macos.md`
- **VPS 是 Ubuntu** → 看 `docs/ubuntu.md`
- **VPS 是 Debian** → 看 `docs/debian.md`
- **你要用 Raspberry Pi** → 看 `docs/raspberry-pi.md`
- **你想先用容器試跑** → 看 `docs/docker.md`
- **你用 Windows，但不想直接碰 Linux 主機** → 先看 `docs/windows-wsl.md`
- **你連 SSH 都還不熟** → 先看 `docs/no-ssh-beginner-guide.md`

---

## 最短路線

如果你只是想快速開始：

1. 選你的系統文件
2. 安裝 Node.js
3. 安裝 OpenClaw
4. 啟動 gateway
5. 執行檢查腳本
6. 配好 API keys / config

---

## 基本需求

建議環境：

- Node.js 20 或更新
- npm 可用
- 可連網
- 有終端機權限
- 如果是 Linux，建議有 sudo

---

## 快速檢查命令

### 檢查系統環境

```bash
bash scripts/check-system.sh
```

### 檢查 OpenClaw 狀態

```bash
bash scripts/check-openclaw.sh
```

---

## 設定檔

先複製模板：

```bash
cp .env.example .env
cp config/openclaw.example.json config/openclaw.json
```

再把 API key、模型、插件設定改成你自己的。

---

## 安裝腳本

### macOS

```bash
bash scripts/install-macos.sh
```

### Ubuntu

```bash
bash scripts/install-ubuntu.sh
```

### Debian

```bash
bash scripts/install-debian.sh
```

### Raspberry Pi OS

```bash
bash scripts/install-pi.sh
```

---

## OpenClaw 常用命令

```bash
openclaw status
openclaw gateway status
openclaw gateway start
openclaw gateway stop
openclaw gateway restart
```

如果不確定命令是否支援：

```bash
openclaw help
openclaw gateway --help
```

---

## 常見部署流程

### 方案 A：先在本機測通，再搬到遠端

適合新手。

1. 在自己的電腦照文件裝一次
2. 確認 OpenClaw 能跑
3. 再去遠端機器重做一遍

### 方案 B：直接在遠端 VPS 裝

適合已經有 VPS 的人。

1. 用 SSH 連上 VPS
2. 跑對應系統的安裝腳本
3. 配 `.env` / `config`
4. 啟動 gateway
5. 用檢查腳本驗證

---

## 不會 SSH？

看這份：

- `docs/no-ssh-beginner-guide.md`

裡面會教你：

- SSH 是什麼
- 怎麼用 Terminal / Termius / PowerShell
- 怎麼貼命令
- 怎麼把錯誤訊息貼回給協作者

---

## 遇到問題先看

- `docs/troubleshooting.md`

涵蓋：

- gateway 啟不來
- ECONNREFUSED
- config invalid
- plugin not found
- Node 版本不相容
- model 不支援

---

## 建議的 GitHub 用法

你可以把這個 repo：

1. `Use this template` 建成你自己的 repo
2. 填好 `.env`（**不要上傳真的密鑰**）
3. 修改 `config/openclaw.json`
4. 把你的部署紀錄寫進 issue / README

---

## 安全提醒

- 不要把真的 API keys push 到 GitHub
- `.env` 應該加進 `.gitignore`
- 遠端主機如果公開對外，建議額外做基本安全加固
- 不要直接複製不明來源的一鍵腳本

---

## 下一步建議

如果你是第一次部署，推薦順序：

1. `docs/no-ssh-beginner-guide.md`
2. 你的作業系統文件
3. `scripts/check-system.sh`
4. `scripts/check-openclaw.sh`
5. `docs/troubleshooting.md`

---

## License

MIT
