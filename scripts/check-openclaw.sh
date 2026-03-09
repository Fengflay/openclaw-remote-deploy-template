#!/usr/bin/env bash
set -euo pipefail

echo "== OpenClaw Check =="
echo "Date: $(date)"
echo

if command -v openclaw >/dev/null 2>&1; then
  echo "OpenClaw: $(openclaw --version)"
else
  echo "OpenClaw: NOT FOUND"
  exit 1
fi

echo
echo "-- openclaw status --"
openclaw status || true

echo
echo "-- openclaw gateway status --"
openclaw gateway status || true

echo
echo "-- Port 18789 check --"
if command -v lsof >/dev/null 2>&1; then
  lsof -i :18789 || true
else
  echo "lsof not available"
fi
