# OpenClaw 远端部署常见坑总表

这份是把新手最容易踩的坑集中列出来，部署前扫一遍，能省很多时间。

---

## 一、环境层

### 1. Node.js 版本太旧

现象：

- 安装失败
- 启动异常
- 某些依赖不兼容

建议：

- 直接用 Node 20+
- 不要拿系统自带超旧 Node 顶着用

---

### 2. npm 全局路径不在 PATH

现象：

- `npm install -g openclaw` 成功
- 但 `openclaw` 命令找不到

排查：

```bash
npm prefix -g
npm bin -g
which openclaw
```

---

### 3. 机器内存太小

现象：

- gateway 起得来但很不稳定
- 任务跑一半卡死
- 系统开始疯狂 swap

建议：

- 低内存机器先跑轻量工作流
- Raspberry Pi / 小 VPS 要保守配置

---

### 4. 磁盘空间不足

现象：

- 安装到一半失败
- npm cache / logs / temp 文件堆满

排查：

```bash
df -h
```

---

## 二、网络层

### 5. 代理软件干扰局域网

重点工具：

- Shadowrocket
- Clash
- Surge
- 其他 VPN / Proxy 工具

影响：

- SSH 不通
- 局域网主机误判离线

详见：

- `network-troubleshooting.md`

---

### 6. 防火墙 / 安全组挡住端口

别只看系统内，云主机还要看控制台的安全组。

---

### 7. 搞混本地地址、容器地址、WSL 地址

你以为连的是远端主机，实际上连的是：

- Docker bridge
- WSL 虚拟网卡
- VPN 地址
- 旧 IP

---

## 三、SSH 层

### 8. SSH 服务没启动

不是每台机器默认都开。

### 9. 用户名猜错

Ubuntu 不一定能用 root。

### 10. 公钥 / 密码认证方式不匹配

看到 `publickey` 错误，不代表主机坏了。

---

## 四、OpenClaw 层

### 11. OpenClaw 版本太旧

现象：

- 新模型不可用
- 某些配置项不支持
- 文档和实际行为对不上

建议：

- 先确认 `openclaw --version`
- 不行就升级

---

### 12. 配置文件写了不受支持的字段

现象：

- gateway 起不来
- status 异常
- config invalid

建议：

- 先用最小配置启动
- 再逐步加功能

---

### 13. 插件路径错

现象：

- plugin not found
- 启动时直接报错

建议：

- 不要一开始就堆很多 plugin
- 先让主服务跑起来

---

### 14. API key 没配置好

现象：

- 服务起来了
- 但模型调用失败

建议：

- 先检查 `.env`
- 不要把密钥写错 provider

---

## 五、Windows / WSL 特有坑

### 15. WSL 装好了，但 Ubuntu 没初始化完整

### 16. 把项目放在 Windows 挂载目录导致权限/性能问题

建议：

- 尽量放在 WSL 自己的 Linux 文件系统里

### 17. Windows 上没开 OpenSSH Server，却想让别人 SSH 进去

这和 WSL 里安装 OpenClaw是两件不同的事。

---

## 六、流程层

### 18. 一上来就想全自动

建议：

- 先最小可用
- 再加自动化
- 再加 skills / heartbeat / bridge

### 19. 还没确认网络就开始排 OpenClaw

顺序错了。

应该先排：

1. 网络
2. SSH
3. 系统环境
4. OpenClaw
5. 模型与插件

### 20. 没有留下检查结果

最常见的低效沟通：

> “不能用”

更好的方式：

```bash
node -v
npm -v
openclaw --version
openclaw status
openclaw gateway status
bash scripts/check-system.sh
bash scripts/check-openclaw.sh
```

---

## 最后建议

如果你是第一次部署，请遵守这条：

**先通 SSH，再装环境；先跑最小系统，再加复杂功能。**
