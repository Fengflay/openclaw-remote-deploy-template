# OpenClaw 部署故障排查

這份文件是給你遇到「明明裝了，但就是跑不起來」時用的。

---

## 1. `openclaw: command not found`

### 原因

- OpenClaw 沒裝好
- npm 全域 bin 不在 PATH

### 先查

```bash
npm prefix -g
npm bin -g
which openclaw
```

### 處理

重新安裝：

```bash
npm install -g openclaw
```

---

## 2. gateway 啟不來

### 先查

```bash
openclaw gateway status
openclaw status
```

### 再查 port

```bash
lsof -i :18789
```

### 處理方向

- 有別的程式占用 port
- 設定檔錯誤
- plugin 路徑錯誤
- 安裝版本太舊

---

## 3. ECONNREFUSED

### 常見原因

- gateway 根本沒啟動
- host/port 不對
- 防火牆擋住

### 先做

```bash
openclaw gateway restart
openclaw gateway status
```

---

## 4. config invalid

### 原因

- JSON 格式錯
- 不支援的 key
- 版本和文件不對應

### 建議

- 先用最小設定檔
- 對照你安裝版本支援的設定
- 不確定時先跑 `openclaw help`

---

## 5. plugin not found

### 原因

- plugin 路徑錯
- 套件沒裝
- config 指到不存在的外掛

### 建議

- 先移除可疑 plugin 設定
- 用最小設定確認主程式先活著

---

## 6. 模型不能用 / model not supported

### 原因

- OpenClaw 版本太舊
- provider API key 沒設
- 模型名稱拼錯

### 建議

- 升級 OpenClaw
- 檢查 `.env`
- 先用保守的已知模型名稱測試

---

## 7. Node 版本太舊

### 先查

```bash
node -v
```

### 建議

至少升到 Node 20+。

---

## 8. 你不知道到底哪裡壞了

直接跑這些，把結果全部貼給協作者：

```bash
node -v
npm -v
openclaw --version
openclaw status
openclaw gateway status
bash scripts/check-system.sh
bash scripts/check-openclaw.sh
```

這比只說一句「不能用」有效很多。
