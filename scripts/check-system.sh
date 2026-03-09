#!/usr/bin/env bash
set -euo pipefail

echo "== System Check =="
echo "Date: $(date)"
echo "User: $(whoami)"
echo "Host: $(hostname)"
echo "OS: $(uname -a)"
echo

if command -v node >/dev/null 2>&1; then
  echo "Node: $(node -v)"
else
  echo "Node: NOT FOUND"
fi

if command -v npm >/dev/null 2>&1; then
  echo "npm: $(npm -v)"
else
  echo "npm: NOT FOUND"
fi

if command -v pnpm >/dev/null 2>&1; then
  echo "pnpm: $(pnpm -v)"
else
  echo "pnpm: NOT FOUND"
fi

if command -v git >/dev/null 2>&1; then
  echo "git: $(git --version)"
else
  echo "git: NOT FOUND"
fi
