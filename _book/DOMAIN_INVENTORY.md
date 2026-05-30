# Domain Inventory (持續更新)

> 最後更新：2026-05-25  
> 維護原則：每次買入/轉移/改 DNS/改託管/改續費策略後，當天更新本表。

## 1) 域名總表

| 域名 | 層級 | 用途 | 註冊商 | 託管平台 | DNS 供應商 | 到期日 (UTC) | 自動續費 | 隱私保護 | SSL 狀態 | 目前狀態 | 備註 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| `bin.ooo` | Apex | 主網域（目前提供 `csapp.bin.ooo`） | Porkbun | GitHub Pages (待遷移 Vercel) | Porkbun Nameservers | 2026-08-14 23:59:59 | 未記錄 | 開啟（Private by Design） | 正常 | 使用中 | WHOIS 可查到到期時間 |
| `csapp.bin.ooo` | Subdomain | CSAPP 網站 | N/A（子網域） | GitHub Pages (待遷移 Vercel) | CNAME -> `recdnd.github.io` | N/A | N/A | N/A | 正常 | 使用中 | 子網域本身無獨立租期 |

## 2) DNS 與指向快照

### `csapp.bin.ooo`

- `CNAME`: `recdnd.github.io`
- `A`: `185.199.108.153`, `185.199.109.153`, `185.199.110.153`, `185.199.111.153`
- `AAAA`: `2606:50c0:8000::153`, `2606:50c0:8001::153`, `2606:50c0:8002::153`, `2606:50c0:8003::153`

### `bin.ooo` 委派 NS

- `fortaleza.ns.porkbun.com`
- `curitiba.ns.porkbun.com`
- `salvador.ns.porkbun.com`
- `maceio.ns.porkbun.com`

## 3) 續費與風險欄位（每月巡檢）

| 域名 | 距離到期天數 | 續費提醒 | 付款方式 | 風險等級 | 下次檢查日期 | 責任人 |
|---|---:|---|---|---|---|---|
| `bin.ooo` | 待更新 | 建議 60/30/14/7 天提醒 | 待填 | 中 | 待填 | 待填 |

## 4) 運維檢查清單

- `WHOIS` 到期日是否與表一致
- Nameserver 是否被意外改動
- 子網域是否仍指向正確託管（Vercel/GitHub）
- HTTPS 憑證是否正常、是否有混合內容
- 重要域名是否開啟自動續費與支付備援

## 5) 更新操作（複製即用）

```bash
# WHOIS（看註冊資訊與到期日）
whois bin.ooo

# 子網域 DNS
dig +short csapp.bin.ooo A
dig +short csapp.bin.ooo AAAA
dig +short csapp.bin.ooo CNAME

# Zone NS
dig +short NS bin.ooo

# 線上可用性
curl -I https://csapp.bin.ooo
```

## 6) 待補資料

- 自動續費狀態（Porkbun 後台）
- 付款方式/備援卡
- 域名責任人與交接文件連結
- 若有其他持有域名，請補進「域名總表」

