# Diagnose Windows SSH Access

## Goal

Establish or diagnose inbound SSH access to a Windows host, and distinguish this from WSL runtime setup.

## Important distinction

Do not confuse these two tasks:

1. Running OpenClaw inside WSL2
2. Allowing inbound SSH to the Windows machine

These are related but separate.

## Preferred strategy

For most operators, prefer:

1. enable SSH access to the Windows host
2. log in to Windows over SSH
3. enter WSL using `wsl` or `wsl -d <DistroName>`
4. operate OpenClaw inside Ubuntu/WSL

This is usually simpler than exposing WSL directly over SSH.

## Inputs

- Windows host IP address
- intended SSH username
- whether OpenSSH Server is installed
- whether corporate policy may restrict services/firewall changes

## Procedure

### Step 1: Confirm OpenSSH Server capability

Run in elevated PowerShell:

```powershell
Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Server*'
```

Interpretation:
- if not installed, install it before continuing

Potential install command:

```powershell
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
```

### Step 2: Confirm sshd service state

```powershell
Get-Service sshd
```

If not running:

```powershell
Start-Service sshd
Set-Service -Name sshd -StartupType Automatic
```

### Step 3: Confirm firewall rules

```powershell
Get-NetFirewallRule -Name *OpenSSH*
```

If needed, add an inbound allow rule for TCP/22.

### Step 4: Confirm the Windows host IP address

```powershell
ipconfig
```

Do not confuse:
- Windows host IP
- WSL virtual IP
- VPN adapter IP
- Hyper-V virtual adapter IP

### Step 5: Test from remote machine

```bash
ping WINDOWS_IP
nc -vz WINDOWS_IP 22
ssh USERNAME@WINDOWS_IP
```

Interpretation:
- ping fails + TCP/22 fails → likely network/routing/firewall issue
- ping works + TCP/22 fails → likely firewall or sshd not listening
- TCP/22 works + login denied → username/auth problem

### Step 6: Enter WSL after successful Windows login

```powershell
wsl
```

Or:

```powershell
wsl -d Ubuntu
```

## Common pitfalls

### Pitfall A: assuming WSL installation automatically enables remote SSH

It does not.

### Pitfall B: targeting the wrong IP

Do not target a WSL IP unless there is a deliberate reason and the network path is configured for it.

### Pitfall C: Microsoft account / PIN login confusion

Desktop sign-in behavior does not always map cleanly to SSH expectations.

### Pitfall D: corporate policy restrictions

Service installation, inbound firewall, or local rule changes may be blocked.

### Pitfall E: operator-side proxy/VPN interference

When connecting from macOS or another machine, private subnet routing may be intercepted by proxy/VPN software.

## Classification

### Class 1: Windows SSH service not installed or not running

### Class 2: Windows firewall / network path issue

### Class 3: Wrong IP selected

### Class 4: Username/authentication mismatch

### Class 5: Environment/policy restriction

## Recommended next actions

- Class 1 → install/start OpenSSH Server
- Class 2 → inspect firewall and network path
- Class 3 → identify correct Windows host IP
- Class 4 → verify local Windows username and auth method
- Class 5 → confirm admin/policy constraints
