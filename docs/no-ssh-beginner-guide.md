# SSH 新手指南

如果你看到很多人說「SSH 上去跑指令」，意思其實很簡單：

**SSH = 遠端打開另一台電腦的終端機。**

你不是在那台主機前面，但你可以像坐在那台主機前面一樣輸入命令。

---

## 你需要準備什麼

通常只要這三個東西：

- 主機 IP 或網址
- 帳號名稱（例如 `root`、`ubuntu`、`pi`）
- 密碼或 SSH 金鑰

常見長這樣：

```bash
ssh ubuntu@123.123.123.123
```

這句話的意思是：

- 用 `ubuntu` 這個帳號
- 連到 `123.123.123.123` 這台機器

---

## macOS / Linux 怎麼連

直接打開 Terminal，輸入：

```bash
ssh 使用者@主機IP
```

例如：

```bash
ssh root@192.168.1.50
```

第一次連線時，可能會看到要你確認指紋：

```text
Are you sure you want to continue connecting (yes/no/[fingerprint])?
```

輸入：

```text
yes
```

然後按 Enter。

---

## Windows 怎麼連

你可以選一種：

### 方法 1：PowerShell

Windows 新版通常內建 ssh：

```powershell
ssh ubuntu@123.123.123.123
```

### 方法 2：Termius

如果你怕命令列，可以裝 **Termius**。

你只要填：

- Host / IP
- Username
- Password 或 Key

然後按連線。

---

## 什麼叫「貼上命令」

當我給你一段這種：

```bash
bash scripts/check-system.sh
```

你的工作通常只是：

1. 複製
2. 在終端機貼上
3. 按 Enter
4. 把輸出結果貼回來

---

## 怎麼知道你已經連上去

如果你成功 SSH 到遠端主機，你通常會看到：

- 一些系統歡迎訊息
- 提示符變成遠端主機名稱

例如：

```bash
ubuntu@server-01:~$
```

這就表示你現在是在遠端主機上。

---

## 常見錯誤

### 1. Connection refused

意思：

- 對方沒開 SSH
- 或 SSH port 不對

### 2. Permission denied

意思：

- 帳號或密碼錯了
- 或你的 SSH key 不對

### 3. Host key verification failed

意思：

- 之前記過舊主機指紋
- 現在主機可能重裝過

---

## 如果你真的不想學 SSH

那就至少做到這件事：

**找一個能打開遠端終端機的工具，然後把命令複製貼上。**

你不一定要理解所有 Linux 細節，先會：

- 連上去
- 貼命令
- 看錯誤
- 把輸出貼回來

就已經夠用。

---

## 和協作者合作時的最佳做法

把下面資訊整理好：

```text
系統：Ubuntu 24.04
主機 IP：123.123.123.123
帳號：ubuntu
問題：openclaw gateway start 後無法連線
錯誤：ECONNREFUSED
```

這樣對方才能更快幫你排錯。

---

## 下一步

如果你已經會登入主機，接下來看你的系統文件：

- `macos.md`
- `ubuntu.md`
- `debian.md`
- `raspberry-pi.md`
