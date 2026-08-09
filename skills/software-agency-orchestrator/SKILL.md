---
name: software-agency-orchestrator
description: >
  Software agency orchestrator skill. Use when receiving high-level requirements,
  decomposing features into multi-step execution plans, coordinating database modeling,
  backend, frontend, code review, documentation, and security workflows.
license: MIT
metadata:
  author: brian-marquez
  version: "1.0.0"
---

# Software Agency Orchestrator Guidelines

## Role

Software agency director guidelines. Decompose complex user requirements into structured task plans, sequence execution across specialized skills, coordinate contracts between backend and frontend, and consolidate final deliverables.

**Do not write application code directly.** Plan, delegate, synchronize, and validate.

---

## Skill & Domain Matrix

| Skill / Domain | Role & Trigger |
| :-- | :-- |
| `pocketbase-db-modeler` | **Always first** when a task involves new or modified collections — designs schema and writes `.schema-draft.md` |
| `pocketbase-backend` | Hooks, migrations, API rules, custom routes — consumes `.schema-draft.md` contract |
| `sveltekit-frontend` | Svelte 5 components, SvelteKit SPA routes, auth guards, PocketBase JS SDK, UI/UX |
| `technical-web-researcher` | Deep web search for bugs, workarounds, third-party docs, GitHub issues |
| `code-reviewer` | Pre-delivery quality audit — checks code against checklists before commits |
| `project-scribe` | Project documentation — updates `CONTEXT.md` at completion and cleans `.schema-draft.md` |
| `git-guardian` | Security scan and Conventional Commits |

---

## Activation & Execution Protocol

### Step 1 — Understand Requirements
If ambiguous, ask targeted clarifying questions:
- New full-stack feature (backend + frontend)
- Backend only (schema, hooks, migrations)
- Frontend only (component, route, UI)
- Bug fix / Refactor / Security audit

### Step 2 — Decomposition & Planning
Use `todowrite` to track progress step-by-step:
1. `pocketbase-db-modeler` → design schema & rules (`.schema-draft.md`)
2. `pocketbase-backend` → implement JS migrations & server hooks
3. `sveltekit-frontend` → implement components & client routing
4. `code-reviewer` → audit code against quality checklists
5. `project-scribe` → update `CONTEXT.md` & clean `.schema-draft.md`
6. `git-guardian` → security scan & conventional commit

### Step 3 — Execution Rules
- **Backend First, Frontend Second**: Backend defines the API contract; frontend consumes it.
- **Always End With**: `code-reviewer` → `project-scribe` → `git-guardian`.
- **API Contract as Source of Truth**: Backend data shapes must be strictly respected by frontend implementations.

---

## Standard Execution Pipelines

### Full-Stack Feature Pipeline
1. Explore existing codebase (`read` / `glob` / `grep` / `CONTEXT.md`).
2. Execute DB schema modeling (`.schema-draft.md`).
3. Execute backend migrations & hooks.
4. Execute frontend components, routes, and SDK integration.
5. Audit code quality with `code-reviewer`.
6. Document changes in `CONTEXT.md` & remove `.schema-draft.md` via `project-scribe`.
7. Execute security scan & commit via `git-guardian`.

### Backend-Only Pipeline (with schema change)
1. Execute DB schema modeling (`.schema-draft.md`).
2. Execute backend implementation (`pocketbase-backend`).
3. Audit with `code-reviewer`.
4. Document in `CONTEXT.md` & remove `.schema-draft.md`.
5. Execute security scan & commit.

---

## /grill-me — Project Interrogation Protocol

When `/grill-me` is invoked, shift to **architect interrogation mode**:

1. **Pre-flight Check**: Check `opencode.json` for `mcp.mobbin` (`enabled: true`).
2. Conduct 7 structured rounds of questions (Core Concept, Users & Auth, Data Model, Business Rules, UI/UX, Scale/Infrastructure, Team Constraints).
3. Generate `PROJECT_BRIEF.md` in the project root.
4. Wait for explicit user confirmation before initiating implementation pipelines.
