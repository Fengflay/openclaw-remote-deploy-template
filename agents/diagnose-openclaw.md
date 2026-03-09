# Diagnose OpenClaw Problems

## Goal

Determine whether a deployment issue is caused by missing installation, old runtime dependencies, gateway startup failure, invalid config, plugin issues, or environment/model configuration problems.

## Preconditions

Before using this playbook, verify:
- shell access works
- network/SSH issues are already ruled out or classified

## Inputs

- Installed OpenClaw version
- Node.js version
- Current environment variables
- Current config files

## Procedure

### Step 1: Verify runtime dependencies

```bash
node -v
npm -v
```

Interpretation:
- Node.js should be 20+
- npm should succeed

### Step 2: Verify installation presence

```bash
which openclaw || command -v openclaw
openclaw --version
```

Interpretation:
- If `openclaw` is missing, classify as installation/path issue

### Step 3: Check status

```bash
openclaw status
openclaw gateway status
```

Interpretation:
- If gateway is stopped, attempt controlled restart

### Step 4: Controlled restart

```bash
openclaw gateway restart
openclaw gateway status
```

### Step 5: Check port occupancy

```bash
lsof -i :18789
```

Interpretation:
- Another process may already be using the expected gateway port

### Step 6: Inspect configuration health

Checks:
- config file exists where expected
- JSON syntax is valid
- unsupported keys are not present
- plugin paths are real

### Step 7: Inspect environment/model configuration

Checks:
- required API keys exist
- model/provider names are valid for the installed version
- environment values are loaded from `.env` or shell as intended

## Classification

### Class 1: Installation/path issue

Indicators:
- `openclaw` command missing
- install succeeded but binary is not on `PATH`

### Class 2: Dependency/runtime issue

Indicators:
- Node.js too old
- npm broken

### Class 3: Gateway startup/port issue

Indicators:
- restart fails
- port conflict detected

### Class 4: Config/plugin issue

Indicators:
- invalid config
- plugin path errors
- startup breaks only after config changes

### Class 5: Model/environment issue

Indicators:
- OpenClaw runs but model calls fail
- provider credentials missing
- model names unsupported

## Minimal repair strategy

Apply the smallest likely fix first:

1. fix Node.js or PATH if broken
2. confirm `openclaw --version`
3. restart gateway
4. simplify config to minimum viable state
5. restore API keys/model settings
6. re-test

## Recommended command bundle for escalation

```bash
node -v
npm -v
openclaw --version
openclaw status
openclaw gateway status
lsof -i :18789
```
