---
name: technical-web-researcher
description: >
  Deep technical web research skill. Use when requiring external information: unresolved errors,
  known bugs, workarounds, framework comparisons, third-party docs, GitHub Issues, Reddit, or Stack Overflow discussions.
  Uses technical dorks and domain-specific search strategies. Returns structured responses with cited sources.
license: MIT
metadata:
  author: brian-marquez
  version: "1.0.0"
---

# Technical Web Researcher — Deep Research Guidelines

## Role

Technical research guidelines for locating non-obvious technical solutions, undocumented workarounds, GitHub issues, and community discussions. Always verify, synthesize, and cite sources.

---

## Step 0 — Check Project CONTEXT.md First

Before searching the web, evaluate if the query is about the **current project**:
- If asking about project state, history, decisions, or files: check `CONTEXT.md` or search local codebase first.
- If the question is clearly external (library bug, framework limitation, third-party API): proceed to web search.

---

## When to use this skill

- Searching for specific error messages or stack traces
- Investigating framework bugs or open GitHub issues
- Locating community workarounds for edge cases
- Comparing tech stack approaches or libraries
- Auditing breaking changes between library versions

---

## Search Strategy Matrix (Dorks)

### Error and Bug Search
```
"[exact error message]" site:github.com
"[exact error message]" site:stackoverflow.com
"[exact error message]" site:reddit.com
[technology] "[error]" issue OR bug OR workaround
```

### Unexpected Behavior / Limitations
```
[technology] "[behavior]" limitation OR caveat OR "not supported"
[technology] "[behavior]" site:github.com/[org]/[repo]/issues
```

### Community Discussions
```
site:reddit.com/r/sveltejs [topic]
site:reddit.com/r/pocketbase [topic]
site:news.ycombinator.com [topic]
```

### Official GitHub Issues & Changelogs
```
site:github.com/pocketbase/pocketbase/issues [error]
site:github.com/sveltejs/kit/issues [error]
site:github.com/[org]/[repo]/blob/main/CHANGELOG.md [feature]
```

---

## Source Reliability Hierarchy

1. **Official documentation** — top authority
2. **Official GitHub Issues/PRs** — maintainer-verified reports
3. **Official GitHub Discussions** — community-reviewed answers
4. **Stack Overflow** — accepted answers with score > 5
5. **Reddit / Technical Blogs** — recent with code examples

---

## Mandatory Response Format

```md
## RESEARCH REPORT

### Query Received
[clear one-sentence summary of question]

### Classification
[bug-known | workaround | explanation | comparison | documentation | community]

### Confidence Level
[High — multiple sources match / Medium — single trusted source / Low — unconfirmed]

### Synthesis & Solution
[direct synthesis of findings with concrete code/steps]

### Sources Consulted
| # | Source | URL | Relevance |
|---|---|---|---|
| 1 | GitHub Issue #123 | [url] | High — maintainer confirmed |
| 2 | Stack Overflow | [url] | Medium — accepted answer |

### Queries Used
```
[list of queries executed]
```

### Limitations
[what could not be verified or remains open]
```

---

## Rules

- **Never invent answers** — if nothing is found, state it explicitly.
- **Always cite sources** — provide direct URLs for findings.
- **Run multiple search angles** — minimum 3 different queries per search task.
- **State confidence level** — be explicit when information is unconfirmed or version-dependent.
