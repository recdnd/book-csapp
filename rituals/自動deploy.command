#!/bin/bash
# book-csapp · Vercel deploy 薄殼

REC_PROJECT="book-csapp"

REC_PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REC_PROJECT_DIR"

echo "▣ ${REC_PROJECT} · Vercel deploy"
if ! command -v vercel >/dev/null 2>&1; then
  echo "✗ vercel CLI 未安裝。npm i -g vercel 後再試。"
  read -n 1 -s -r -p "按任意鍵關閉視窗…"; exit 1
fi
if vercel --prod; then
  echo "✓ 已觸發 production deploy"
else
  echo "✗ deploy 失敗"
  read -n 1 -s -r -p "按任意鍵關閉視窗…"; exit 1
fi
read -n 1 -s -r -p "按任意鍵關閉視窗…"
