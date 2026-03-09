# Docker 部署思路

如果你想先快速試跑，可以用 Docker 做隔離環境。

> 注意：不同版本的 OpenClaw 對檔案路徑、插件掛載、瀏覽器/系統整合可能有不同要求。
> 所以 Docker 比較適合測試、打包、隔離，不一定是每個人最省事的正式部署方案。

---

## 基本想法

你需要：

- Node.js 基底 image
- 把設定檔和資料夾掛進容器
- 暴露 gateway port
- 在容器內安裝 openclaw

---

## 範例 Dockerfile

```Dockerfile
FROM node:20-bookworm
WORKDIR /app
RUN npm install -g openclaw
CMD ["openclaw", "status"]
```

---

## 範例執行

```bash
docker build -t openclaw-test .
docker run --rm -it -p 18789:18789 openclaw-test
```

---

## 什麼時候不建議先用 Docker

- 你還不熟 OpenClaw 本身
- 你還在學怎麼排錯
- 你需要很多主機原生整合

對新手來說，**先用原生安裝通常比較直覺**。
