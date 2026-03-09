# Windows + WSL 準備說明

如果你用 Windows，最推薦的方式通常不是直接在原生 Windows 上硬裝所有東西，
而是先開一個 Linux 環境（WSL）。

---

## 1. 安裝 WSL

在 PowerShell（系統管理員）裡：

```powershell
wsl --install
```

安裝完成後重開機。

---

## 2. 選 Ubuntu

第一次進 WSL 時，建立你的 Linux 使用者。

之後照 `ubuntu.md` 的流程走就可以。

---

## 3. 檔案位置提醒

- Linux 內的專案，盡量放在 WSL 的 Linux 檔案系統
- 不要一開始就把所有東西都放在 Windows 掛載路徑裡

---

## 4. 驗證

進入 Ubuntu on WSL 後：

```bash
node -v
npm -v
```

如果正常，再安裝 OpenClaw。
