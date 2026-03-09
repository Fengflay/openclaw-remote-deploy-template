# Quick Checklist

## Goal

Perform a fast first-pass classification of an OpenClaw deployment problem.

## Inputs

- Target OS
- Access type: local shell or SSH
- Host/IP if remote
- Whether a proxy/VPN is active on the operator machine

## Fast checks

Run in this order.

### 1. Reachability

If remote:

```bash
ping TARGET_IP
nc -vz TARGET_IP 22
```

### 2. Route inspection (macOS recommended when local-network SSH fails)

```bash
route -n get TARGET_IP
```

### 3. Shell environment

```bash
node -v
npm -v
which openclaw || command -v openclaw
```

### 4. OpenClaw status

```bash
openclaw --version
openclaw status
openclaw gateway status
```

## Classification

### Category A: Network / route / proxy issue

Indicators:
- ping fails or is inconsistent
- TCP/22 is unreachable
- connection succeeds after disabling proxy/VPN

### Category B: SSH service / auth issue

Indicators:
- host reachable
- port 22 reachable or partially reachable
- login denied or auth mismatched

### Category C: Environment issue

Indicators:
- Node.js missing or too old
- npm missing
- `openclaw` command missing

### Category D: OpenClaw runtime/config issue

Indicators:
- OpenClaw installed
- gateway fails to start or respond
- config invalid
- plugin/model setup broken

## Next file to read

- A → `diagnose-network.md` and `diagnose-ssh.md`
- B → `diagnose-ssh.md`
- C → `deploy-ubuntu.md` or target OS deployment guide
- D → `diagnose-openclaw.md`
