#!/bin/bash
# book-csapp · push 薄殼（push 即 Vercel 自動 preview/prod）

REC_PROJECT="book-csapp"
REC_DEPLOY_URL="https://csapp.bin.ooo"

REC_PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
_d="$REC_PROJECT_DIR"
while [[ "$_d" != "/" && ! -d "$_d/sov/machine/lib" ]]; do _d="$(dirname "$_d")"; done
MACHINE_LIB="${MACHINE_LIB:-$_d/sov/machine/lib}"

source "$MACHINE_LIB/rec-push.sh"
rec_push "$@"
