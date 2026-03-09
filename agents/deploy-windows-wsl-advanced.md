# Deploy OpenClaw on Windows via WSL2 (Advanced)

## Goal

Provide a more robust Windows deployment playbook that covers WSL2 installation failures, virtualization problems, networking mode caveats, path pitfalls, and Windows/WSL boundary confusion.

## Use this playbook when

- the operator is on Windows
- WSL2 is the preferred runtime target
- previous basic setup attempts failed
- networking, firewall, virtualization, or path issues are suspected

## Inputs

- Windows version/build
- `wsl --status` output
- `wsl -l -v` output
- Whether virtualization is enabled in BIOS/UEFI
- Whether corporate VPN/proxy/firewall policy may interfere

## Preconditions

- local admin access available if WSL installation must be repaired
- reboot is acceptable if Windows feature changes are required

## Procedure

### Step 1: Validate WSL presence

Run in PowerShell:

```powershell
wsl --status
wsl -l -v
```

Interpretation:
- if `wsl` is not recognized, classify as missing WSL feature/runtime
- if no distro is installed, install Ubuntu before continuing

### Step 2: Validate virtualization prerequisites

If errors such as `0x80370102` appear, suspect virtualization prerequisites.

Check hypervisor launch state:

```powershell
bcdedit /enum | findstr -i hypervisorlaunchtype
```

Interpretation:
- if `hypervisorlaunchtype Off`, WSL2 may not start correctly

Potential remediation:

```powershell
bcdedit /set hypervisorlaunchtype Auto
```

Then reboot.

### Step 3: Validate distro state

Interpretation:
- distro present but not initialized → launch Ubuntu manually once
- distro running as WSL1 when WSL2 is intended → convert or reinstall appropriately

### Step 4: Enter Ubuntu and verify Linux environment

```bash
uname -a
cat /etc/os-release
```

### Step 5: Install baseline packages

```bash
sudo apt update
sudo apt install -y curl git ca-certificates
```

### Step 6: Install Node.js 20+

```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
node -v
npm -v
```

### Step 7: Install OpenClaw

```bash
sudo npm install -g openclaw
openclaw --version
```

### Step 8: Start gateway and validate

```bash
openclaw gateway start
openclaw gateway status
openclaw status
```

## Windows/WSL networking cautions

### Default NAT mode

Do not assume WSL2 is a normal LAN host.

Implications:
- WSL2 has its own virtualized address space
- `localhost` behavior may differ depending on direction and feature support
- inbound LAN access to WSL services may require additional configuration

### Mirrored networking mode

On newer Windows/WSL versions, mirrored mode may improve:
- VPN compatibility
- localhost behavior
- direct LAN access

But do not assume it is enabled. Verify actual behavior.

### LAN access to WSL services

If a service in WSL must be reachable from another machine:
- ensure the app binds to `0.0.0.0` instead of only `127.0.0.1`
- consider Windows portproxy or mirrored mode where appropriate
- check Windows firewall and Hyper-V firewall rules

## File/path cautions

### Avoid placing the project under `/mnt/c/...` if behavior becomes inconsistent

Preferred approach:
- store active project files inside the WSL Linux filesystem

### Do not mix PowerShell commands and bash commands blindly

Rule:
- `powershell` blocks run in Windows shell
- `bash` blocks run in Ubuntu/WSL shell

## Common failure branches

### Failure A: `wsl` command missing

Classification:
- Windows feature/runtime missing or shell context problem

### Failure B: WSL2 install/start errors (`0x80370102`, similar)

Classification:
- virtualization/hypervisor prerequisite issue

### Failure C: WSL networking inconsistent

Classification:
- NAT mode limitation, firewall, VPN/proxy interference, or binding mismatch

### Failure D: OpenClaw install succeeds but command is missing

Check:

```bash
npm prefix -g
npm bin -g
which openclaw
```

### Failure E: operator expects SSH into Windows/WSL from another machine

Clarification:
- WSL runtime setup does not automatically create a correct inbound SSH topology
- evaluate Windows OpenSSH Server, firewall, and port-forwarding separately

## Minimal success criteria

- `wsl --status` succeeds
- Ubuntu launches normally
- `node -v` is 20+
- `openclaw --version` succeeds inside Ubuntu
- `openclaw gateway status` succeeds
- `openclaw status` returns usable output
