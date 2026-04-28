#!/usr/bin/env bash
set -euo pipefail

# One-click deploy for HonKit output to GitHub Pages.
# Defaults:
#   DOMAIN=csapp.bin.ooo
#   REMOTE=origin
#   TARGET_BRANCH=gh-pages
#
# Usage:
#   ./deploy.sh
#   DOMAIN=csapp.bin.ooo REMOTE=origin TARGET_BRANCH=gh-pages ./deploy.sh

DOMAIN="${DOMAIN:-csapp.bin.ooo}"
REMOTE="${REMOTE:-origin}"
TARGET_BRANCH="${TARGET_BRANCH:-gh-pages}"
TMP_BRANCH="gh-pages-deploy"

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Error: command '$1' not found." >&2
    exit 1
  fi
}

echo "[1/6] Checking required commands..."
require_cmd git
require_cmd npx
require_cmd node

NODE_VERSION="$(node -v || true)"
if [[ "${NODE_VERSION}" != v1[468]* && "${NODE_VERSION}" != v2* ]]; then
  echo "Warning: current Node is ${NODE_VERSION}. HonKit is more stable on Node 14+." >&2
fi

echo "[2/6] Building HonKit..."
npm run build

echo "[3/6] Writing CNAME (${DOMAIN})..."
echo "${DOMAIN}" > _book/CNAME

echo "[4/6] Disabling Jekyll processing..."
touch _book/.nojekyll

echo "[5/6] Preparing temporary deploy branch (${TMP_BRANCH})..."
if git show-ref --verify --quiet "refs/heads/${TMP_BRANCH}"; then
  git branch -D "${TMP_BRANCH}" >/dev/null 2>&1
fi
git subtree split --prefix _book -b "${TMP_BRANCH}"

echo "[6/6] Pushing to ${REMOTE}/${TARGET_BRANCH}..."
git push "${REMOTE}" "${TMP_BRANCH}:${TARGET_BRANCH}" --force

echo "[7/7] Cleaning up..."
git branch -D "${TMP_BRANCH}" >/dev/null 2>&1 || true

echo "Done."
echo "Pages URL (after GitHub Pages propagation): https://${DOMAIN}"
