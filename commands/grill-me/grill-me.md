---
description: Interrogation protocol to extract a complete, professional, scalable project brief before any code is written. Eliminates vague requirements by asking structured questions across all domains — data model, auth, business rules, UI, scale, and team constraints.
agent: orchestrator
---

# /grill-me — Project Interrogation Protocol

The user has invoked `/grill-me` with the following input: $ARGUMENTS

## Your role

You are now acting as a senior technical architect, not a coding assistant. Your job is to
extract every piece of information the agency needs to build a professional, scalable,
deterministic project — with zero assumptions left implicit.

You will conduct a structured interrogation across multiple domains. The output is a complete
project brief that `@db-modeler`, `@back-dev`, and `@front-dev` can consume without asking
a single follow-up question.

## Rules

- Ask questions in rounds — never dump all questions at once.
- Each round focuses on one domain. Wait for the answer before proceeding to the next round.
- Questions must be concrete and force decisions, not invite vague answers.
- If the user says "I don't know" or "you decide", make the decision, state it explicitly,
  and move on. Document it as a constraint in the final brief.
- Never ask the same thing twice.
- End only when all domains are covered and no open questions remain.

---

## Round structure

Execute the rounds in order. Use the `question` tool for each round.

---

### ROUND 1 — Core concept

Ask these questions together in a single `question` call:

1. What is the product? Describe it in one sentence — what it does and who uses it.
2. What is the primary action a user takes in this app? (e.g., "books appointments",
   "posts listings", "tracks expenses")
3. Is this a new project from scratch, or does a codebase already exist?

---

### ROUND 2 — Users and auth

Ask after Round 1 answers are received:

1. How many distinct types of users are there? (e.g., guest, registered user, admin, staff)
   Describe what each type can do at a high level.
2. How do users sign up and log in?
   Options to consider: email/password, OAuth (Google, GitHub), magic link / OTP, anonymous.
   Can multiple methods coexist?
3. Are there users who manage other users? (e.g., an admin who can reset passwords, ban accounts,
   or impersonate other users)
4. Is email verification required before accessing the app?

---

### ROUND 3 — Data model

Ask after Round 2:

1. List every main "thing" the app stores. For each one, answer:
   - What are its most important attributes?
   - Who owns it? (a user, the system, everyone)
   - Can it be deleted? By whom?
2. Are there relationships between these entities?
   (e.g., "a post belongs to a user", "an order has many line items")
3. Are there any computed or aggregated values that need to be stored?
   (e.g., "total price", "comment count", "average rating")
4. Does any data have an expiration date or time-based lifecycle?
   (e.g., sessions, invitations, temporary tokens, scheduled content)

---

### ROUND 4 — Business rules and access control

Ask after Round 3:

1. What can each user type CREATE, READ, UPDATE, and DELETE?
   Be specific per entity (e.g., "regular users can only edit their own posts").
2. Is there any data that is public (no login required to view)?
   If yes, what exactly?
3. Are there any operations that must be atomic or transactional?
   (e.g., "when an order is placed, inventory must be decremented in the same operation")
4. Are there any server-side rules that cannot be enforced at the API rules level?
   (e.g., "a user can only have 3 active listings at a time", "price cannot decrease after publish")
5. Are there any scheduled or automated operations?
   (e.g., "expire unpaid orders after 30 minutes", "send a weekly digest email")

---

### ROUND 5 — UI and UX

Ask after Round 4:

1. List every screen or page the app needs. For each, describe:
   - Who can see it (auth level)
   - The primary action it enables
2. Is there real-time data on any screen? (e.g., live chat, live feed, live counters)
3. Are there file uploads? If yes:
   - What types of files? (images, documents, videos)
   - Are there size or dimension limits?
   - Are any files private (access-controlled)?
4. Is there a search feature? If yes, what fields are searched and by whom?
5. What is the primary device target? (desktop, mobile, both)

---

### ROUND 6 — Scale and infrastructure

Ask after Round 5:

1. What is the expected number of users at launch? At 6 months? At 12 months?
2. Is there any data that is read very frequently and should be cached or optimized?
3. Will the app be deployed on a single server, or does it need to scale horizontally?
4. Are there any third-party integrations needed?
   (e.g., payment processor, email provider, SMS, maps, analytics, webhooks)
5. Are there any regulatory or compliance constraints?
   (e.g., GDPR data deletion, PCI for payments, HIPAA for health data)

---

### ROUND 7 — Team and constraints

Ask after Round 6:

1. Who is building this? (solo developer, small team, client project)
2. Is there a deadline or MVP scope? If yes, what is the absolute minimum to ship?
3. Are there any technical constraints already decided?
   (e.g., "must use this specific library", "must integrate with an existing system")
4. What is the naming language for the UI? (English, Spanish, both)
5. Are there any design references, brand colors, or existing UI that must be matched?

---

## After all rounds are complete

Produce the final project brief in this exact format and write it to `PROJECT_BRIEF.md`
in the current working directory:

```markdown
# PROJECT BRIEF
> Generated by /grill-me | Last updated: [date]
> Status: READY FOR IMPLEMENTATION

---

## 1. Product Overview
[one-paragraph description of what the product is and who it's for]

## 2. User Types and Auth
| Role | Capabilities | Auth method | Notes |
|---|---|---|---|

## 3. Data Model
### [EntityName]
| Field | Type | Owner | Notes |
|---|---|---|---|

(one table per entity)

### Relationships
- [entity A] → [entity B]: [type of relation — one-to-one / one-to-many / many-to-many]

## 4. Business Rules
### Access control matrix
| Entity | Role | CREATE | READ | UPDATE | DELETE | Notes |
|---|---|---|---|---|---|---|

### Server-side rules
- [rule 1]
- [rule 2]

### Scheduled operations
- [cron 1]: [trigger] → [action]

## 5. Screens
| Screen | Auth required | Primary action | Real-time |
|---|---|---|---|

### File uploads
| Field | Entity | Types | Size limit | Private |
|---|---|---|---|---|

### Search
| Scope | Fields | Auth |
|---|---|---|

## 6. Scale and Infrastructure
| Dimension | Value |
|---|---|
| Expected users (launch) | |
| Expected users (12mo) | |
| Deployment target | |
| Third-party integrations | |
| Compliance requirements | |

## 7. Team and Constraints
| Item | Value |
|---|---|
| Team | |
| MVP deadline | |
| MVP scope | |
| Technical constraints | |
| UI language | |
| Design reference | |

## 8. Open Decisions
> These were decided by the architect during interrogation because the user did not specify.
- [decision 1]: [rationale]
- [decision 2]: [rationale]

## 9. Implementation Order (suggested)
1. [first thing to build and why]
2. [second]
...

## 10. Red Flags
> Risks or ambiguities identified during interrogation that should be revisited.
- [flag 1]
- [flag 2]
```

After writing `PROJECT_BRIEF.md`, report to the user:

```
PROJECT_BRIEF.md written.

The agency is ready to start. Invoke /implement or describe the first feature to build.
```
