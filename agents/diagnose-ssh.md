# Diagnose SSH Problems

## Goal

Determine whether SSH failure is caused by network reachability, routing, service state, firewall rules, username/authentication mismatch, or operator-side proxy interference.

## Inputs

- Target IP or hostname
- Expected SSH username
- Operator OS
- Whether VPN/proxy software is active

## Procedure

### Step 1: Check host reachability

```bash
ping TARGET_IP
```

Interpretation:
- If ping fails entirely, do not assume SSH is the primary issue.
- Continue with TCP port testing.

### Step 2: Check TCP/22 reachability

```bash
nc -vz TARGET_IP 22
```

Interpretation:
- If port 22 is unreachable, likely causes include firewall, service down, wrong IP, security group, proxy/routing issue.

### Step 3: On macOS, inspect route when local-network targets fail

```bash
route -n get TARGET_IP
```

Interpretation:
- Inspect interface and gateway selection.
- Unexpected route behavior strongly suggests operator-side network or proxy interference.

### Step 4: Test with proxy/VPN disabled if applicable

Interpretation:
- If SSH works after disabling proxy/VPN, classify as operator-side routing/proxy issue.

### Step 5: Verify SSH service on the target host

Linux examples:

```bash
sudo systemctl status ssh
sudo systemctl status sshd
```

If inactive, start/enable as appropriate.

Windows example:

```powershell
Get-Service sshd
```

### Step 6: Verify firewall/security group

Examples:

```bash
sudo ufw status
```

Cloud environments:
- verify inbound `22/tcp` in provider security rules

### Step 7: Attempt SSH login

```bash
ssh USERNAME@TARGET_IP
```

Interpretation:
- `Permission denied` often means username or auth method mismatch, not basic reachability failure.
- `Connection refused` usually means the host answered but SSH service/port is not accepting.
- timeout usually means routing/firewall/proxy issue.

## Classification

### Class 1: Network/routing/proxy issue

Indicators:
- ping unstable or failing
- port 22 unreachable
- route selection suspicious
- proxy/VPN toggle changes result

### Class 2: SSH service/firewall issue

Indicators:
- host reachable
- service inactive or firewall blocking 22/tcp

### Class 3: Authentication/user issue

Indicators:
- port 22 reachable
- SSH prompt appears
- login denied

## Next actions

- Class 1 → read `diagnose-network.md`
- Class 2 → enable SSH service and open firewall/security group
- Class 3 → verify username, password, key policy, and SSH config
