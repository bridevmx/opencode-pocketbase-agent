---
name: code-reviewer
description: >
  Code quality auditor skill. Use ALWAYS before committing or completing tasks.
  Reviews frontend code (Svelte 5, SvelteKit, Tailwind, DaisyUI) and backend code
  (PocketBase JSVM, hooks, migrations). Reports findings by severity (CRITICAL / IMPORTANT / MINOR).
  Does NOT modify code.
license: MIT
metadata:
  author: brian-marquez
  version: "1.0.0"
---

# Code Reviewer — Quality Auditor Guidelines

## Role

Software quality control guidelines. Focus strictly on auditing code and reporting issues. Never modify code during review. Report findings by severity: CRITICAL, IMPORTANT, or MINOR.

---

## When to use this skill

- Auditing frontend code (Svelte 5, SvelteKit, Tailwind, DaisyUI, PocketBase JS SDK)
- Auditing backend code (PocketBase JSVM, hooks, migrations, API rules)
- Performing pre-commit checks or pre-delivery audits
- Verifying accessibility, security, and performance standards

---

## Backend Audit Checklist (PocketBase JSVM)

Mark each item as ✅ OK / ❌ CRITICAL / ⚠️ IMPORTANT / 💡 MINOR

**Scope and runtime:**
- [ ] Outer variables/functions are NOT used inside handlers (scope isolation)
- [ ] `require()` of shared modules is INSIDE the handler, not outside
- [ ] No `async/await`, `setTimeout`, `setInterval`, `Promise` in hooks
- [ ] No Node.js APIs (`fs`, native `fetch`, `Buffer`, `process`)

**Transactions:**
- [ ] Inside `runInTransaction`, `txApp` is used exclusively, never `$app`
- [ ] Emails and external HTTP requests are OUTSIDE the transaction

**Hooks:**
- [ ] All hooks and middlewares call `e.next()`
- [ ] Position of `e.next()` is correct (before vs after)

**v0.23+ APIs:**
- [ ] No `dao()` — use `$app.*`
- [ ] No `RecordUpsertForm` — use `record.set` + `$app.save`
- [ ] Routes use `{param}`, not `:param`
- [ ] Static serve uses `/{path...}`, not `/*`

**Security:**
- [ ] Filters use `{:placeholders}` — no user input concatenation
- [ ] Sensitive fields protected in hooks (owner, role, balance)
- [ ] API rules verified for every operation

**JSON fields:**
- [ ] JSON fields read with `unmarshalJSONField` or `JSON.parse(JSON.stringify(...))`
- [ ] JSON writes always use `record.set`

---

## Frontend Audit Checklist (SvelteKit + Svelte 5)

**Vanilla JavaScript:**
- [ ] No TypeScript, no `lang="ts"`, no type annotations
- [ ] No `.server.js` files

**Svelte 5 runes:**
- [ ] No `export let` — use `$props()`
- [ ] No `$:` — use `$derived` or `$effect`
- [ ] No `writable` stores — use `$state`
- [ ] `$effect` has cleanup if subscribing to realtime
- [ ] No mutations inside `$derived`

**PocketBase SDK:**
- [ ] `pb.autoCancellation(false)` in `client.js`
- [ ] `authRefresh` with explicit collection: `pb.collection('x').authRefresh()`
- [ ] `pb.authStore.onChange` has `unsubscribe()` in `onDestroy`
- [ ] Filters use `pb.filter()` — no string concatenation
- [ ] `ClientResponseError` caught and handled

**Auth:**
- [ ] Protected content calls `authRefresh()` before rendering
- [ ] `pb.authStore.clear()` on logout
- [ ] No `.server.js` files

**Styles:**
- [ ] Tailwind v4 + DaisyUI only — no inline CSS
- [ ] DaisyUI components match decision matrix

**Accessibility:**
- [ ] Every `<input>` has `<label>` or `aria-label`
- [ ] Semantic landmarks: `<header>`, `<main>`, `<nav>`, `<footer>`
- [ ] Images have `alt` attributes
- [ ] Errors have `role="alert"`

**Components:**
- [ ] No duplicate UI — extracted to `src/lib/components/`
- [ ] Loading and empty states implemented

---

## Audit Report Format

```md
## CODE REVIEW REPORT

### Files Reviewed
- [list of files with path]

### Domain
[frontend | backend | both]

### Executive Summary
[1-2 sentences: general state of code]

---

### CRITICAL (blocks commit)
[If none: "None"]

**[file:line]** — [description of issue]
- Rule violated: [which]
- How to fix: [concrete instruction]

---

### IMPORTANT (fix before merge)
[If none: "None"]

**[file:line]** — [description]
- Rule violated: [which]
- How to fix: [instruction]

---

### MINOR (suggestions)
[If none: "None"]

**[file:line]** — [description]
- Suggestion: [instruction]

---

### Full Checklist
[Checklist with ✅ / ❌ / ⚠️ / 💡 for each reviewed item]

### Verdict
[ ] APPROVED — ready for commit
[ ] APPROVED WITH MINORS — can commit, fix later
[ ] REJECTED — fix criticals/importants before commit
```
