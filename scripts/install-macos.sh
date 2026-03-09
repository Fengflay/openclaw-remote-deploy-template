#!/usr/bin/env bash
set -euo pipefail

echo "[macOS] Installing OpenClaw prerequisites..."

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew not found. Install it first:"
  echo '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
  exit 1
fi

brew install node
npm install -g openclaw

echo
echo "Installed versions:"
node -v
npm -v
openclaw --version

echo
echo "Starting gateway..."
openclaw gateway start || true
openclaw gateway status || true

echo
echo "Done. Next steps:"
echo "1. Copy .env.example to .env"
echo "2. Fill in API keys"
echo "3. Run: bash scripts/check-openclaw.sh"
