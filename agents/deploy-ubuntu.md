# Deploy OpenClaw on Ubuntu

## Goal

Install and validate a minimal working OpenClaw deployment on Ubuntu.

## Preconditions

- Target OS: Ubuntu
- Shell access available (local terminal or SSH)
- Internet access available
- `sudo` available, or equivalent root privileges
- Proxy/VPN does not block required outbound traffic

## Inputs

- Ubuntu version
- Desired model provider
- Required environment variables / API keys

## Expected outcome

- Node.js >= 20 installed
- npm available
- `openclaw` command available
- gateway starts successfully
- `openclaw status` returns usable output

## Procedure

### Step 1: Update system packages

```bash
sudo apt update && sudo apt upgrade -y
```

### Step 2: Install baseline tools

```bash
sudo apt install -y curl git ca-certificates
```

### Step 3: Install Node.js 20+

```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
node -v
npm -v
```

Validation:
- `node -v` should report 20.x or newer
- `npm -v` should succeed

### Step 4: Install OpenClaw

```bash
sudo npm install -g openclaw
openclaw --version
```

Validation:
- `openclaw --version` should succeed

### Step 5: Start gateway

```bash
openclaw gateway start
openclaw gateway status
```

Validation:
- gateway status should indicate a running or reachable service

### Step 6: Verify overall status

```bash
openclaw status
```

### Step 7: Add environment/configuration

Copy template files if present:

```bash
cp .env.example .env
cp config/openclaw.example.json config/openclaw.json
```

Then populate environment variables and model/provider settings.

### Step 8: Re-test

```bash
openclaw gateway restart
openclaw gateway status
openclaw status
```

## Failure branches

### If Node.js is too old

Action:
- reinstall using NodeSource or another maintained method

### If `openclaw` is not found after install

Check:

```bash
npm prefix -g
npm bin -g
which openclaw
```

Likely issue:
- global npm binary path not on `PATH`

### If gateway does not start

Read:
- `diagnose-openclaw.md`
- `../docs/troubleshooting.md`

### If SSH to the Ubuntu host is failing

Read:
- `diagnose-ssh.md`
- `diagnose-network.md`

## Minimal success criteria

A deployment is considered minimally working when all of the following are true:

- `node -v` succeeds and is 20+
- `npm -v` succeeds
- `openclaw --version` succeeds
- `openclaw gateway status` succeeds
- `openclaw status` returns usable output
