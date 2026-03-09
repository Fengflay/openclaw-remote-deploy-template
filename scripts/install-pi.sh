#!/usr/bin/env bash
set -euo pipefail

echo "[Raspberry Pi OS] Installing OpenClaw prerequisites..."

sudo apt update
sudo apt install -y curl git ca-certificates
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
sudo npm install -g openclaw

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
