# Windows SSH 详细指南

这份文档讲的是：

**如果目标机器是 Windows，怎么让别人 SSH 进去。**

这和“在 Windows 里装 WSL2 跑 OpenClaw”是相关但不同的事情。

很多人会把这两件事混在一起：

1. 在 Windows 本机上用 WSL2 跑 OpenClaw
2. 从另一台电脑 SSH 进入这台 Windows 机器

请先记住：

**装了 WSL2，不等于 Windows 已经自动提供 SSH 登录。**

---

## 一、你到底想 SSH 到哪里？

先分清楚目标：

### 方案 A：SSH 到 Windows 主机
适合：
- 你想先登录 Windows
- 再从 Windows 里进入 WSL
- 你要管理整台机器，而不是只管 Ubuntu

### 方案 B：SSH 到 WSL 里的 Linux 环境
适合：
- 你就是想直接进 Ubuntu / bash
- 你想把它当 Linux 主机用

### 现实建议

对大多数新手来说，**先 SSH 到 Windows 主机，再执行 `wsl` 进入 Ubuntu**，通常更稳。

因为：

- Windows OpenSSH Server 比较直观
- 网络入口比较明确
- 不用一开始就处理 WSL 独立 SSH 服务、端口、启动时机等问题

---

## 二、最推荐的做法：SSH 到 Windows 主机

### 1. 检查 OpenSSH Server 是否已安装

在 **PowerShell（管理员）** 里执行：

```powershell
Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Server*'
```

如果没安装，可安装：

```powershell
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
```

---

### 2. 启动 sshd 服务

```powershell
Start-Service sshd
Set-Service -Name sshd -StartupType Automatic
Get-Service sshd
```

你要确认它状态是：

- `Running`

---

### 3. 放行 Windows 防火墙

检查规则：

```powershell
Get-NetFirewallRule -Name *OpenSSH* | Format-Table -AutoSize
```

如果没有适合的规则，可以手动加：

```powershell
New-NetFirewallRule -Name sshd-22 -DisplayName "OpenSSH Server (TCP 22)" -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
```

---

### 4. 找出 Windows 主机 IP

```powershell
ipconfig
```

找你当前在用的网卡 IP，例如：

- `192.168.10.25`

---

### 5. 从另一台机器测试 SSH

```bash
ssh 你的Windows用户名@192.168.10.25
```

例如：

```bash
ssh feng@192.168.10.25
```

---

### 6. 登录后进入 WSL

连接进 Windows 后，可以执行：

```powershell
wsl
```

如果你装了多个发行版，也可以：

```powershell
wsl -d Ubuntu
```

这样你就进入 Ubuntu 了。

---

## 三、这条路线为什么适合新手

因为它把问题拆成两层：

### 第一层：先保证 Windows 可 SSH
排查点比较标准：
- sshd 服务
- 防火墙
- 用户名密码
- IP 地址

### 第二层：SSH 进去后再进 WSL
这时才处理：
- Ubuntu
- Node
- OpenClaw
- `.env`
- gateway

这比一开始就想“直接 SSH 到 WSL”省事很多。

---

## 四、如果你想直接 SSH 到 WSL

可以，但更容易出坑。

你通常需要处理：

- WSL 内安装 openssh-server
- WSL 服务启动
- WSL 的 IP 可能变化
- 端口转发
- Windows 防火墙
- NAT / mirrored networking 差异

对新手来说，这条路不推荐作为第一选择。

---

## 五、Windows SSH 最常见的坑

### 1. `sshd` 没启动

排查：

```powershell
Get-Service sshd
```

如果不是 Running：

```powershell
Start-Service sshd
```

---

### 2. 防火墙没放行 22

症状：

- ping 通
- 但 `nc -vz 主机IP 22` 不通

处理：

- 检查 Windows Firewall
- 企业环境还要检查额外安全策略

---

### 3. 用错用户名

Windows SSH 登录用户名通常是：

- 本机账户名
- 或 Microsoft 账户映射后的用户名

别直接猜。

先在 Windows 上确认：

```powershell
whoami
$env:UserName
```

---

### 4. 密码能登录本机，但 SSH 不一定过

特别是：

- Microsoft 账户
- PIN 登录
- 企业域账户

这些情况会让 SSH 登录体验和你日常桌面登录不完全一样。

---

### 5. 局域网代理 / VPN / 路由问题

如果你从 Mac 连 Windows，别忘了：

- Shadowrocket
- Clash
- Surge
- 其他 VPN

都可能影响到 `192.168.x.x` 局域网流量。

这时候先看：

- `network-troubleshooting.md`

---

### 6. 企业电脑策略挡住 OpenSSH Server

公司电脑很常见：

- 安装权限有限
- 服务被策略限制
- 防火墙规则不允许本地开放 SSH

这不是你命令写错，是环境政策问题。

---

### 7. 你连到的是 Windows，但以为自己已经在 WSL

SSH 进 Windows 后，默认通常还是：

- PowerShell
- CMD

这时你还没进 Ubuntu。

你需要再执行：

```powershell
wsl
```

---

## 六、推荐的 Windows SSH 排查顺序

### 第一步：确认 Windows 上 sshd 是否运行

```powershell
Get-Service sshd
```

### 第二步：确认本机 IP

```powershell
ipconfig
```

### 第三步：确认防火墙规则

```powershell
Get-NetFirewallRule -Name *OpenSSH*
```

### 第四步：从另一台机器测试

```bash
ping WINDOWS_IP
nc -vz WINDOWS_IP 22
ssh 用户名@WINDOWS_IP
```

### 第五步：登录成功后再进 WSL

```powershell
wsl -d Ubuntu
```

---

## 七、如果你的目标是部署 OpenClaw

最稳的远端路径通常是：

1. 在 Windows 上启用 OpenSSH Server
2. 从 Mac / 另一台电脑 SSH 到 Windows
3. 在 Windows shell 中执行 `wsl -d Ubuntu`
4. 在 Ubuntu 里安装 Node.js 20+
5. 安装 OpenClaw
6. 配置 `.env`
7. 启动 gateway
8. 跑检查脚本

---

## 八、不推荐新手一开始就做的事

- 一上来直接 SSH 到 WSL 内部 IP
- 还没确认 Windows SSH 通不通，就先折腾 WSL sshd
- 同时改防火墙、端口转发、代理、WSL 网络模式

这样很容易把问题搅在一起。

---

## 九、给 AI agent / 协作者的简短摘要

如果目标是 Windows 远端部署，优先策略是：

**先建立 Windows 主机 SSH 入口，再从 Windows 进入 WSL。**

不要默认：

- WSL 已经可被直接 SSH
- WSL IP 稳定
- Windows 与 WSL 是同一个网络身份

---

## 十、推荐收集的信息

如果你要别人帮你排错，把这些贴出来最有用：

### Windows PowerShell

```powershell
whoami
$env:UserName
Get-Service sshd
ipconfig
Get-NetFirewallRule -Name *OpenSSH*
wsl --status
wsl -l -v
```

### 远端测试机（例如 Mac）

```bash
ping WINDOWS_IP
nc -vz WINDOWS_IP 22
ssh 用户名@WINDOWS_IP
```
