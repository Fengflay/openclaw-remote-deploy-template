# Deploy OpenClaw on Windows via WSL2

## Goal

Install OpenClaw inside Ubuntu on WSL2 and validate a minimal working deployment.

## Preconditions

- Host OS: Windows 10/11 with WSL2 support
- Local administrator rights available for WSL installation
- Ubuntu distribution installed or installable
- Internet access available

## Important distinction

Installing OpenClaw inside WSL2 is not the same as enabling inbound SSH into Windows.

- WSL2 is the recommended runtime path for local Windows deployment
- Windows OpenSSH Server is a separate concern

## Inputs

- Windows version
- Whether WSL2 is already installed
- Desired provider/API keys

## Expected outcome

- WSL2 installed
- Ubuntu available inside WSL
- Node.js >= 20 installed in Ubuntu
- OpenClaw installed in Ubuntu
- gateway starts successfully

## Procedure

### Step 1: Install WSL2 if needed

In elevated PowerShell:

```powershell
wsl --install
```

Reboot if prompted.

### Step 2: Open Ubuntu inside WSL

Initialize the Linux user if first launch.

### Step 3: Verify shell environment inside Ubuntu

```bash
uname -a
cat /etc/os-release
```

### Step 4: Install Node.js 20+

```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
node -v
npm -v
```

### Step 5: Install OpenClaw

```bash
sudo npm install -g openclaw
openclaw --version
```

### Step 6: Start gateway

```bash
openclaw gateway start
openclaw gateway status
openclaw status
```

### Step 7: Configure environment variables

Create `.env` and populate required API keys.

## Failure branches

### If WSL is missing

Action:
- install WSL2 first
- do not continue with OpenClaw setup until Ubuntu starts correctly

### If Ubuntu is installed but shell tools are missing

Action:

```bash
sudo apt update
sudo apt install -y curl git ca-certificates
```

### If files are stored under Windows-mounted paths and behavior is inconsistent

Recommendation:
- move the project into the WSL Linux filesystem for better compatibility and performance

### If the operator expects external SSH into Windows

Clarification:
- WSL deployment alone does not configure Windows OpenSSH Server
- treat that as a separate setup task

## Minimal success criteria

- Ubuntu launches in WSL2
- `node -v` is 20+
- `openclaw --version` succeeds
- `openclaw gateway status` succeeds
- `openclaw status` returns usable output
