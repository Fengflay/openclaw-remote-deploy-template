# Agent Playbooks

This directory contains **agent-friendly deployment and diagnosis playbooks** for OpenClaw.

These files are written for AI agents, automation tools, and technical operators who need:

- explicit preconditions
- stable step ordering
- clear validation commands
- failure branching
- minimal ambiguity

## Usage model

Read the most relevant file first.

- For Ubuntu deployment: `deploy-ubuntu.md`
- For Windows via WSL2: `deploy-windows-wsl.md`
- For advanced Windows/WSL2 cases: `deploy-windows-wsl-advanced.md`
- For SSH diagnosis: `diagnose-ssh.md`
- For network diagnosis: `diagnose-network.md`
- For OpenClaw diagnosis: `diagnose-openclaw.md`
- For short triage: `quick-checklist.md`

## General rules for agents

1. Prefer the smallest working configuration first.
2. Do not assume SSH is working until connectivity is verified.
3. Do not assume OpenClaw is the problem before checking network, shell access, Node.js, and installation state.
4. Treat proxy/VPN interference as a first-class failure mode on macOS and mixed local-network environments.
5. Capture command output before changing multiple variables at once.
6. When uncertain, classify the issue before attempting repair.

## Recommended execution order

### New deployment

1. Determine target OS
2. Verify shell access
3. Verify Node.js and npm
4. Install OpenClaw
5. Start gateway
6. Validate status
7. Add model/environment configuration
8. Re-test

### Existing broken deployment

1. Verify network reachability
2. Verify SSH or local shell access
3. Verify Node.js and OpenClaw installation
4. Check `openclaw status`
5. Check `openclaw gateway status`
6. Check config and environment variables
7. Classify root cause
8. Apply minimal fix
