# Windows / WSL2 进阶部署与常见坑

这份是给 Windows 方案补强用的。

如果你只是第一次安装，请先看：

- `windows-wsl.md`

如果你已经开始装，或者遇到各种奇怪问题，再看这份。

---

## 推荐方案结论

对大多数人来说，**Windows 上跑 OpenClaw，优先推荐：WSL2 + Ubuntu**。

原因：

- Node / npm / shell 工具链更接近 Linux 主流环境
- 安装脚本和排错路径更统一
- 比直接在原生 Windows 上硬拼一堆环境更稳

但 WSL2 也有很多坑，尤其在：

- 虚拟化
- 网络
- 防火墙
- 路径
- 权限
- Windows 与 WSL 的边界

---

## 一、安装阶段常见坑

### 1. `wsl` 命令不存在

现象：

```powershell
wsl : The term 'wsl' is not recognized...
```

可能原因：

- WSL 组件没启用
- 当前系统版本太旧
- 当前 shell 环境异常

建议：

```powershell
wsl --status
wsl -l -v
```

如果不行，先安装：

```powershell
wsl --install
```

如果还是不行，确认：

- Windows Subsystem for Linux 功能已启用
- Virtual Machine Platform 已启用
- 系统已重启

---

### 2. `0x80370102` / required feature is not installed

这类错误通常不是 Ubuntu 坏了，而是：

- BIOS/UEFI 没开虚拟化
- Windows 的 Virtual Machine Platform 没启用
- Hyper-V / Hypervisor 没正常工作
- 你在虚拟机里套虚拟机，但没开 nested virtualization

建议检查：

```powershell
bcdedit /enum | findstr -i hypervisorlaunchtype
```

如果看到 `Off`，可尝试：

```powershell
bcdedit /set hypervisorlaunchtype Auto
```

然后重启。

---

### 3. 旧 CPU / 旧 Windows 版本不支持 WSL2

有些机器不是你操作错，是底层条件不够。

排查：

- Windows 版本是否足够新
- CPU 是否支持虚拟化 / SLAT

---

### 4. distribution 安装了，但 `wsl -l -v` 结果不对

可能原因：

- Ubuntu 还没完成首次初始化
- 还停留在 WSL1
- 发行版没正确启动过一次

建议：

```powershell
wsl -l -v
wsl --set-default-version 2
```

然后手动打开 Ubuntu 跑完第一次初始化。

---

## 二、网络相关常见坑

### 5. 以为 WSL 和 Windows 是同一个网络身份

这很常见，而且非常误导人。

在默认 **NAT** 模式下：

- Windows 主机有自己的 IP
- WSL2 虚拟机也有自己的 IP
- 它们不是完全同一个网络实体

所以：

- 从 Windows 连 WSL 服务，很多时候可以走 `localhost`
- 但从局域网其他机器连 WSL 服务，就不一定行

---

### 6. 服务只绑定 `127.0.0.1`，导致外部机器连不到

很多程序默认只监听本地：

- `127.0.0.1`
- `localhost`

如果你想让局域网其他机器访问，通常要改成：

- `0.0.0.0`

这是典型坑，不是 WSL 独有，但在 WSL 上特别容易踩。

---

### 7. 想从局域网访问 WSL2 服务，但没做端口转发

默认 NAT 下，WSL2 不像普通物理机那样天然可被 LAN 访问。

常见做法：

- Windows 侧做 `netsh interface portproxy`
- 或改用 **mirrored networking**（较新环境）

这是很多人以为“WSL 服务坏了”的根源，其实是网络拓扑问题。

---

### 8. `localhost` 行为和你想的不一样

在较新的 WSL 功能下，`localhost` 互通体验改善很多；
但如果环境较旧、网络模式不同、或程序监听方式不对，行为还是会不一致。

所以不要只凭“理论上 localhost 应该能通”来判断。

要实测。

---

### 9. 公司环境 / 防火墙 / Hyper-V firewall 干扰网络

企业环境经常会出现：

- Windows 防火墙规则影响 WSL
- Hyper-V firewall 生效
- 本地规则合并被禁用
- 企业代理/VPN 导致 WSL 网络异常

如果是公司电脑，这类问题要高度怀疑。

---

### 10. VPN / 代理导致 WSL 网络异常

常见症状：

- WSL 里 DNS 怪怪的
- 外网访问不稳定
- Windows 能上网，WSL 不能
- SSH/HTTP 行为前后不一致

较新的 WSL 文档里也强调：

- mirrored networking
- dnsTunneling
- autoProxy

这些功能是为了改善 VPN / 复杂网络兼容性。

---

## 三、路径与文件系统常见坑

### 11. 把项目放在 Windows 挂载路径，结果性能或权限怪怪的

例如放在：

- `/mnt/c/...`

可能会出现：

- 文件 IO 慢
- 权限行为不直觉
- 某些工具链兼容性差

更稳的做法通常是：

**把项目放在 WSL 自己的 Linux 文件系统里。**

---

### 12. 用 `\\wsl$` 访问文件出问题

有时你会遇到：

- Windows 看不到 `\\wsl$`
- 访问很慢
- 某些目录异常

这类问题在 WSL 文档里常和 9P 文件服务有关。

如果你只是部署 OpenClaw，尽量避免把整个工作流建立在 `\\wsl$` 文件共享体验上。

---

### 13. PATH 被 Linux shell 配置覆盖，导致 `.exe` 互通失效

官方文档里就提到一个常见坑：

- Linux 里的 PATH 被覆写
- 导致 `notepad.exe` 这类 Windows 可执行程序在 WSL 中找不到

虽然 OpenClaw 不一定直接依赖这个，但这说明：

**过度改 shell 初始化文件，会把 WSL 的互通能力搞坏。**

---

## 四、权限与服务边界坑

### 14. 以为装了 WSL 就等于 Windows 已经能被 SSH

不是。

这两个问题要分开：

1. 在 WSL 里运行 OpenClaw
2. 从其他机器 SSH 进 Windows / WSL

它们不是同一件事。

如果你要别人 SSH 到这台 Windows 机器：

- 你可能要启用 Windows OpenSSH Server
- 或另外处理端口转发 / 访问路径

---

### 15. 用管理员 PowerShell 和普通用户 PowerShell 行为不一致

WSL、分发版、安装状态，有时会因为用户上下文不同而看起来不一致。

如果你看到“明明装了但找不到 distribution”，要检查是不是：

- 换了用户
- 用了不同权限上下文
- 用到内建 Administrator 账户

---

## 五、OpenClaw 在 Windows/WSL 上的特有部署坑

### 16. 先装 OpenClaw，后发现 Node 版本不对

正确顺序仍然是：

1. 先确认 WSL 正常
2. 再装 Node 20+
3. 再装 OpenClaw
4. 再配置 `.env`
5. 再启动 gateway

不要一开始就乱装包。

---

### 17. `npm install -g openclaw` 成功，但命令找不到

WSL 里也一样会踩 PATH 问题。

排查：

```bash
npm prefix -g
npm bin -g
which openclaw
```

---

### 18. 误把 Windows 路径习惯带进 Linux

例如：

- 路径分隔符混用
- 把 PowerShell 命令拿去 bash 跑
- 把 bash 命令拿去 CMD 跑

这类错误非常高频。

建议明确区分：

- `powershell` 块只在 Windows PowerShell / Terminal 里跑
- `bash` 块只在 Ubuntu / WSL 里跑

---

## 六、推荐的 Windows 部署顺序

### 最稳路线

1. 确认 Windows 支持 WSL2
2. 安装 WSL2
3. 安装 Ubuntu
4. 完成首次初始化
5. 在 Ubuntu 内安装 Node.js 20+
6. 安装 OpenClaw
7. 配置 `.env`
8. 启动 gateway
9. 跑检查脚本

---

## 七、推荐检查命令

### Windows PowerShell

```powershell
wsl --status
wsl -l -v
```

### WSL Ubuntu

```bash
uname -a
cat /etc/os-release
node -v
npm -v
openclaw --version
openclaw status
openclaw gateway status
```

---

## 八、建议新增的判断规则

如果问题发生在 Windows 方案，请优先分类：

### A. WSL 根本没装好
- `wsl` 命令异常
- distribution 无法启动
- 虚拟化/Hyper-V 错误

### B. WSL 装好了，但网络有问题
- localhost 行为异常
- LAN 无法访问
- VPN/代理/防火墙干扰

### C. WSL 可用，但 Linux 环境没配好
- Node 没装
- npm 异常
- PATH 错

### D. OpenClaw 本身问题
- gateway 起不来
- config 错
- model / env 配错

---

## 参考线索

这份文档整理时，参考了 WSL 官方文档中常见的方向，包括：

- 安装错误码
- 虚拟化与 Hyper-V 要求
- WSL NAT / mirrored networking
- portproxy / LAN 访问
- Hyper-V firewall
- PATH 被覆盖导致互通失效
- `\\wsl$` 文件访问相关问题

你如果要给 AI agent 读，也很适合搭配：

- `agents/deploy-windows-wsl.md`
- `agents/diagnose-network.md`
- `agents/diagnose-openclaw.md`
