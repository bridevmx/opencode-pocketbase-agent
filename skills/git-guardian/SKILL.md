---
name: git-guardian
description: >
  Git and security guardian skill. Conducts security scans before any commit,
  audits PocketBase API rules, detects exposed secrets, and executes clean commits
  using Conventional Commits. Use before any commit or to audit project security.
license: MIT
metadata:
  author: brian-marquez
  version: "1.0.0"
---

# Git Guardian — Security & Conventional Commits

## Role

Security scanner and Git conventions guidelines. Ensures that no secrets or vulnerabilities enter the repository, and enforces strict Conventional Commit standards.

**Never execute a commit without completing a security scan first.**

---

## When to use this skill

- Performing pre-commit security scans
- Auditing PocketBase API rules for security vulnerabilities
- Checking for exposed secrets (API keys, tokens, credentials, private keys)
- Structuring clean Conventional Commits
- Conducting full project security audits

---

## Mode 1 — Pre-commit Security Scan

### Phase 1 — Secret and Vulnerability Scan

Scan the diff before staging/committing:

```bash
git diff --staged
git diff
```

**Patterns to detect (BLOCK commit if found):**

#### Exposed Secrets
- Generic API keys (`sk-`, `pk-`, `rk-` followed by 20+ chars)
- AWS keys (`AKIA[0-9A-Z]{16}`)
- GitHub tokens (`ghp_`, `gho_`, `ghs_`, `ghr_`)
- Private keys (`-----BEGIN (RSA|EC|OPENSSH) PRIVATE KEY-----`)
- Database connection strings (`(mongodb|postgresql|mysql|sqlite)://...`)
- PocketBase admin tokens or hardcoded superuser passwords
- Environment variables with real non-placeholder secrets
- JWT secrets (`JWT_SECRET=...`)

#### Sensitive / Dangerous Files
Check staged files (`git diff --staged --name-only`). Block if staged:
- `.env`, `.env.local`, `.env.production` with real values
- `*.pem`, `*.key`, `*.p12`, `*.pfx`
- `service-account*.json`, `credentials.json`
- `*.sqlite`, `*.db` (database files)

#### Code Vulnerabilities
- `{@html` without `DOMPurify.sanitize()` (Svelte XSS)
- `innerHTML =` with user variables
- `eval()` with external input
- `localStorage.setItem` storing sensitive auth tokens
- `console.log` containing sensitive data (tokens, passwords)

---

### Phase 2 — PocketBase API Rules Audit

If diff includes files in `pb_migrations/` or `pb_hooks/`, verify:

1. **Accidental empty rule** — search for `"listRule": ""` or `"createRule": ""` — empty string = total public access.
2. **Missing auth check** — ensure rules include `@request.auth.id != ""` unless intentionally public.
3. **Missing owner filter** — ensure `listRule` includes `user = @request.auth.id` or equivalent.
4. **Role escalation protection** — in `updateRule`, ensure fields like `role` or `isAdmin` have `@request.body.role:isset = false`.
5. **Exposed manageRule** — ensure `manageRule` is `null` unless explicitly required.

---

### Phase 3 — Scan Verdict Format

```md
## SECURITY SCAN — Pre-commit

### Files to Commit
[list of staged files]

### Secrets Detected
[NONE | list with CRITICAL severity]

### Dangerous Files
[NONE | list]

### Vulnerabilities in Diff
[NONE | list]

### API Rules Audit
[NONE | table]

### Verdict
[CLEAN — proceed | BLOCKED — resolve before commit]
```

If **BLOCKED**: stop, report issues, do NOT execute commit.

---

### Phase 4 — Conventional Commits Standard

Format:
```
<type>(<optional-scope>): <description>

<optional body — the WHY, not the WHAT>

<optional footer>
```

**Valid types:**
- `feat`: new feature
- `fix`: bug fix
- `feat!` / `fix!`: breaking change
- `chore`: maintenance, dependencies, tooling
- `refactor`: structural change without behavior change
- `docs`: documentation only
- `style`: formatting, whitespace
- `perf`: performance improvement
- `test`: testing only
- `security`: security fix

**Commit Message Rules:**
- Description: lowercase, no trailing period, imperative mood ("add" not "added")
- Header line: 72 characters max
- Body: explain WHY, not WHAT
- No AI attribution footers ("Co-Authored-By: Claude", etc.)

---

## Mode 2 — Full Project Security Audit

1. **Scan repo for secrets:**
```bash
grep -rn "AKIA[0-9A-Z]\{16\}" .
grep -rn "sk-[a-zA-Z0-9]\{48\}" .
grep -rn "ghp_\|gho_\|ghs_" .
grep -rn "BEGIN.*PRIVATE KEY" .
```

2. **Audit SvelteKit client code:**
- Verify `DOMPurify.sanitize()` on `{@html`
- Verify no secrets in `VITE_` or `PUBLIC_` variables

3. **Audit PocketBase migrations:**
- Check all 5 API rules anti-patterns

4. **Dependency Audit:**
```bash
npm audit --audit-level=high 2>/dev/null || true
```

---

## Absolute Rules

1. **Never commit secrets** — if a secret is found, stop immediately.
2. **Never commit directly to main/master without verification.**
3. **Never force-push without explicit user confirmation.**
4. **Never auto-resolve merge conflicts.**
