#!/bin/bash
# book-csapp · localhost 薄殼（HonKit build + serve）

REC_PROJECT="book-csapp"
REC_PORT=7474
REC_BUILD_CMD="npm run build"
REC_SERVE_DIR="_book"

REC_PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
_d="$REC_PROJECT_DIR"
while [[ "$_d" != "/" && ! -d "$_d/sov/machine/lib" ]]; do _d="$(dirname "$_d")"; done
MACHINE_LIB="${MACHINE_LIB:-$_d/sov/machine/lib}"

source "$MACHINE_LIB/rec-serve.sh"
rec_serve "$@"
