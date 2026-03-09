# 网络 / 代理 / SSH 排错指南

这份文件专门处理一种很烦、但很常见的情况：

**不是 OpenClaw 坏了，而是你根本没办法稳定连到目标主机。**

特别常见于：

- Mac 上开了 Shadowrocket / Surge / Clash / 其他代理工具
- 家里局域网设备是 `192.168.x.x`
- VPS / 本地机 / Windows / Raspberry Pi 混着用
- 你以为是 SSH 配置有问题，其实是流量被代理接管了

---

## 先记住一句话

如果：

- `ping` 不通
- `nc -vz 主机 22` 不通
- 关掉代理后突然就通了

那问题多半不是 SSH，而是：

**路由、代理规则、局域网直连策略出了问题。**

---

## 最常见的坑

### 1. Shadowrocket / Clash / Surge 把局域网流量劫持了

症状：

- SSH 连 `192.168.10.x` 超时
- 同网段机器互相不可达
- 关闭代理软件后恢复正常

### 处理方法

把这些网段设为 **DIRECT**：

- `192.168.0.0/16`
- `10.0.0.0/8`
- `172.16.0.0/12`
- `127.0.0.1/8`
- `localhost`

如果你只想处理当前网段，也可以先加：

- `192.168.10.0/24`

---

### 2. 你连的是错误 IP

很多人会把这些地址搞混：

- 主机 Wi‑Fi IP
- WSL IP
- Docker bridge IP
- 虚拟网卡 IP
- Tailscale / ZeroTier IP

### 处理方法

先在目标机上查真实地址。

#### Linux / WSL

```bash
ip addr
hostname -I
```

#### macOS

```bash
ifconfig
ipconfig getifaddr en0
```

#### Windows PowerShell

```powershell
ipconfig
```

---

### 3. SSH 服务根本没开

症状：

- 机器能 ping 通
- 但 22 端口不通

### Linux / Ubuntu / Debian / Pi

```bash
sudo systemctl status ssh
sudo systemctl enable --now ssh
```

有些系统服务名可能是 `sshd`。

### Windows（OpenSSH Server）

```powershell
Get-Service sshd
Start-Service sshd
Set-Service -Name sshd -StartupType Automatic
```

---

### 4. 防火墙挡住 22 端口

#### Ubuntu / Debian / Pi（UFW）

```bash
sudo ufw status
sudo ufw allow 22/tcp
```

#### Windows

确认防火墙允许 OpenSSH Server。

---

### 5. VPS 安全组挡住 SSH

云主机除了系统防火墙，还可能有：

- Security Group
- Firewall Rules
- Inbound Rules

如果你在云上，记得确认 **22/tcp 已开放**。

---

### 6. SSH 用户名写错

常见默认用户名：

- Ubuntu: `ubuntu`
- Debian: 视镜像而定
- Raspberry Pi OS: `pi`（旧环境常见）
- 部分 VPS: `root`

你连错用户名时，可能会看到：

```text
Permission denied
```

这不一定是密码错，也可能是用户就错了。

---

### 7. SSH key / 密码方式不匹配

症状：

- 明明 IP 对、端口也开了
- 但一直 `Permission denied (publickey)`

### 处理方法

确认主机到底允许：

- 密码登录
- SSH key 登录
- 或两者都可

---

### 8. 路由走错接口

尤其在 Mac 上有 VPN / 代理 / 虚拟网卡时很常见。

### macOS 检查

```bash
route -n get 192.168.10.10
```

你要看的是：

- 实际走哪个 interface
- gateway 是不是怪怪的

---

### 9. DNS 没问题，但 IP 层有问题

很多人看到域名能解析，就以为网络没问题。

其实 SSH 常见失败点在：

- 路由
- 防火墙
- 端口
- 代理

不是 DNS。

---

### 10. 公司 / 学校网络限制横向访问

有些网络环境会阻止内网设备互连。

症状：

- 能上网
- 但内网机器彼此不通

这种情况要检查：

- AP isolation
- Guest Wi‑Fi
- 路由器策略

---

## 推荐排查顺序

按这个顺序最省时间：

### 第一步：确认目标机 IP

### 第二步：测试网络通不通

```bash
ping 目标IP
nc -vz 目标IP 22
```

### 第三步：检查代理是否影响

- 开代理测一次
- 关代理测一次

### 第四步：检查 SSH 服务

### 第五步：检查防火墙 / 安全组

### 第六步：检查用户名 / 登录方式

---

## Shadowrocket 特别说明

如果你在 Mac 上用 Shadowrocket，并且目标机器在：

- `192.168.x.x`
- `10.x.x.x`
- `172.16.x.x` 到 `172.31.x.x`

请优先检查：

**这些网段有没有被排除代理、有没有设置为 DIRECT。**

否则你会遇到这种假象：

- 主机明明在线
- SSH 却死活连不上
- 你以为是主机坏了
- 实际上是代理改写了网络路径

---

## 一组最好用的测试命令

```bash
ping 192.168.10.10
nc -vz 192.168.10.10 22
route -n get 192.168.10.10
ssh 用户名@192.168.10.10
```

把这几组输出贴给协作者，排错会快很多。

---

## 和 OpenClaw 部署的关系

如果 SSH 不通，后面这些都会卡住：

- 安装 Node.js
- 安装 OpenClaw
- 上传 `.env`
- 启动 gateway
- 跑检查脚本

所以：

**先修网络，再谈部署。**
