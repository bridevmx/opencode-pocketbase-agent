---
name: project-scribe
description: >
  Project documentation skill. Keeps CONTEXT.md updated with real project state,
  key architectural decisions, features, and pending tasks. Use at the end of every completed task.
  Also cleans up transient contracts (.schema-draft.md) and answers queries about project status.
license: MIT
metadata:
  author: brian-marquez
  version: "1.0.0"
---

# Project Scribe — Documentation Guidelines

## Role

Maintain `CONTEXT.md` accurate, structured, and immediately useful for any developer or AI agent. Document decisions and context, not code that is already in the repository.

---

## When to use this skill

- Updating `CONTEXT.md` after completing a feature, bug fix, or refactor
- Cleaning up transient contract files like `.schema-draft.md`
- Answering questions about current project state, conventions, or past decisions

---

## What to document

### Always document
- What was built or changed (one line per item)
- Non-obvious decisions: why one approach was chosen over another
- What remains pending or out of scope
- What was attempted and failed (avoids repeating mistakes)
- New key files and their purpose

### Never document
- Generic framework docs (how Svelte or PocketBase works)
- Full code listings that already exist in the repo
- Temporary exploration steps or scratch notes

---

## Protocol — Updating CONTEXT.md

1. **Read current state**: read `CONTEXT.md` completely. If it does not exist, initialize it from the template below.
2. **Identify changes**: determine which section is affected (Current State, Decisions, What Didn't Work, Key Files, Pending).
3. **Edit with precision**: update only modified sections without overwriting unchanged content.
4. **Update date**: set `> Last update:` to the current date.
5. **Clean up transient files**: if `.schema-draft.md` exists, ensure its contents are reflected in `CONTEXT.md` and delete the file:
   ```bash
   rm .schema-draft.md
   ```

---

## CONTEXT.md Template

```md
# CONTEXT — [Project Name]

> Last update: [date]
> Stack: SvelteKit Static SPA + PocketBase + Tailwind v4 + DaisyUI

---

## Index

| # | Section | Description |
|---|---|---|
| 1 | [Stack and Conventions](#1-stack-and-conventions) | Project technologies and rules |
| 2 | [Current State](#2-current-state) | Completed and in-progress features |
| 3 | [Decisions Taken](#3-decisions-taken) | Rationale behind technical choices |
| 4 | [What Failed](#4-what-failed) | Pitfalls and discarded approaches |
| 5 | [Key Files](#5-key-files) | Map of critical project files |
| 6 | [Pending](#6-pending) | Out of scope or future backlog |

---

## 1. Stack and Conventions

- **Frontend:** SvelteKit Static SPA — `adapter-static` + `fallback: 'index.html'` + `ssr: false`
- **Backend:** PocketBase v0.23+
- **Styling:** Tailwind CSS v4 + DaisyUI
- **Language:** Vanilla JavaScript — no TypeScript
- **SDK:** `pb.autoCancellation(false)` singleton in `client.js`
- **Auth:** `pb.collection('users').authRefresh()` with explicit collection

---

## 2. Current State

<!-- Format: - [state] FeatureName — brief description -->
<!-- State: COMPLETED | IN PROGRESS | BLOCKED -->

_No features registered yet._

---

## 3. Decisions Taken

<!-- Format: - **Decision:** rationale -->

_No decisions registered yet._

---

## 4. What Failed

<!-- Format: - **[technology]** problem description — how it was resolved or why discarded -->

_No records yet._

---

## 5. Key Files

<!-- Format: - `path/file` — purpose -->

_No files registered yet._

---

## 6. Pending

<!-- Format: - [ ] description — context or reason it was deferred -->

_No pending items registered._
```
