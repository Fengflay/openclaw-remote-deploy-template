# Diagnose Network and Proxy Interference

## Goal

Determine whether deployment failure is caused by operator-side networking, proxy/VPN interception, incorrect addressing, or firewall path issues.

## Scope

Use this playbook when:
- remote SSH is failing
- local-network devices are unexpectedly unreachable
- behavior changes when proxy/VPN tools are enabled or disabled

## Inputs

- Target IP/hostname
- Operator OS
- Whether the operator uses Shadowrocket, Clash, Surge, VPN, or other proxy tools
- Whether the target is on a local/private subnet

## Private network ranges to treat carefully

- `192.168.0.0/16`
- `10.0.0.0/8`
- `172.16.0.0/12`
- `127.0.0.0/8`
- `localhost`

## Procedure

### Step 1: Confirm the target address is correct

Do not assume the remembered address is current.

Examples to inspect on target systems:

Linux / WSL:

```bash
ip addr
hostname -I
```

macOS:

```bash
ifconfig
ipconfig getifaddr en0
```

Windows:

```powershell
ipconfig
```

### Step 2: Test raw reachability

```bash
ping TARGET_IP
nc -vz TARGET_IP 22
```

### Step 3: Inspect route selection

macOS:

```bash
route -n get TARGET_IP
```

Interpretation:
- wrong interface or strange gateway choice suggests operator-side path issues

### Step 4: Toggle proxy/VPN state

Run the same connectivity tests with proxy/VPN enabled and disabled.

Interpretation:
- if disabling proxy/VPN restores connectivity, classify as proxy/routing interference

### Step 5: Inspect proxy rules for private subnets

Recommended direct-routing policy for private ranges:

- `192.168.0.0/16`
- `10.0.0.0/8`
- `172.16.0.0/12`
- `127.0.0.0/8`
- `localhost`

If possible, add narrower rules for the exact subnet first, such as:
- `192.168.10.0/24`

### Step 6: Verify target-side firewall exposure

Even if route selection is correct, firewalls may still block traffic.

### Step 7: Verify cloud-side security rules if relevant

For VPS/cloud hosts, verify provider security groups or inbound rules.

## Classification

### Class A: Wrong address

Indicators:
- target IP discovered on host differs from assumed IP

### Class B: Proxy/VPN interference

Indicators:
- connectivity changes based on proxy state
- route selection inconsistent with expected local interface

### Class C: Firewall/security rule issue

Indicators:
- route/path correct
- host reachable or partially reachable
- service port blocked

## Recommended conclusion format

Use a concise classification statement:

- `Root cause: operator-side proxy intercepted private-subnet traffic.`
- `Root cause: target address was incorrect.`
- `Root cause: target firewall/security rules blocked SSH.`
