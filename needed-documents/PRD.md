# Product Requirements Document (PRD)

> **Defines what to build.** Aligns goals, users, and scope, and guides product
> decisions. This is the source of truth for *what* the product does and *why* —
> it deliberately avoids *how* (that lives in the [TRD](./TRD.md)).

- **Product name:** _<Product / project name>_
- **Author / owner:** _<Name>_
- **Status:** `Draft` | `In Review` | `Approved`
- **Last updated:** _<YYYY-MM-DD>_
- **Related docs:** [TRD](./TRD.md) · [App Flow](./APP-FLOW.md) · [Design Brief](./DESIGN-BRIEF.md) · [Implementation Plan](./IMPLEMENTATION-PLAN.md)

---

## 1. Overview

A short paragraph (3–6 sentences) that anyone — engineer, designer, or
stakeholder — can read to understand the product. Cover:

- **Problem:** What pain or gap exists today?
- **Solution:** What are we building, in one sentence?
- **Value:** Why does it matter / why now?

> **Example** — *TaskFlow is a lightweight project and task management app for
> small teams. Today, small teams juggle work across scattered spreadsheets and
> chat threads, losing track of ownership and deadlines. TaskFlow gives them a
> single place to create projects, assign tasks, track status, and discuss work
> inline. It matters because small teams want clarity without the overhead of
> heavyweight enterprise tools.*

---

## 2. Goals

What success looks like. Keep each goal outcome-oriented and measurable where
possible. Separate what's in scope now from what is explicitly deferred.

### Primary goals
- _<Goal 1 — e.g., Let a user create a project and add tasks in under 60 seconds>_
- _<Goal 2>_
- _<Goal 3>_

### Non-goals (out of scope)
Listing these prevents scope creep and tells the AI agent what **not** to build.
- _<Non-goal 1 — e.g., No real-time collaborative editing in v1>_
- _<Non-goal 2 — e.g., No mobile native apps in v1 (responsive web only)>_

---

## 3. Target Users

Who this is for. Define 1–3 personas. For each:

### Persona: _<Name / role>_
- **Who they are:** _<role, context, technical level>_
- **Needs / jobs-to-be-done:** _<what they are trying to accomplish>_
- **Pain points today:** _<what frustrates them now>_
- **How this product helps:** _<the relief we provide>_

> **Example — "Maya, team lead at a 6-person agency"**
> - **Needs:** assign work, see what's blocked, know what ships this week.
> - **Pain today:** status lives in her head and in Slack; nothing is a system of record.
> - **How we help:** one dashboard showing every project, task status, and owner.

---

## 4. Key Features

The core capabilities, prioritized. Use `P0` (must-have for launch), `P1`
(should-have), `P2` (nice-to-have). Each feature gets a user-story framing and
clear acceptance criteria so the AI agent knows when it's "done."

| ID | Feature | Priority | User story |
|----|---------|----------|------------|
| F1 | _<Feature>_ | P0 | As a _<user>_, I want _<action>_ so that _<benefit>_ |
| F2 | _<Feature>_ | P0 | … |
| F3 | _<Feature>_ | P1 | … |

### F1 — _<Feature name>_
- **Description:** _<what it does>_
- **Acceptance criteria:**
  - [ ] _<Given / When / Then condition>_
  - [ ] _<Edge case handled>_
- **Depends on:** _<other features / data>_

> **Example features for TaskFlow**
> - **F1 (P0) Authentication** — users sign up, log in, and log out securely.
> - **F2 (P0) Projects** — create, rename, and delete projects; each has an owner.
> - **F3 (P0) Tasks** — create tasks under a project with title, description,
>   status (`todo`/`in_progress`/`done`), and an assignee.
> - **F4 (P1) Comments** — leave threaded comments on a task.
> - **F5 (P2) Dashboard filters** — filter tasks by status/assignee.

---

## 5. Success Metrics

How we'll know it's working after launch. Tie each metric to a goal.

| Metric | Type | Target | Measured by |
|--------|------|--------|-------------|
| _<e.g., Activation: % of signups who create a first task>_ | Adoption | _<60%>_ | _<analytics event>_ |
| _<e.g., Weekly active teams>_ | Engagement | _<target>_ | _<analytics>_ |
| _<e.g., Time-to-first-task>_ | Usability | _<< 60s>_ | _<instrumentation>_ |

---

## 6. Assumptions, Constraints & Open Questions

- **Assumptions:** _<what we believe to be true — e.g., users have email accounts>_
- **Constraints:** _<budget, deadline, platform, compliance>_
- **Open questions:** _<unresolved decisions that need an answer before/ during build>_

---

## 7. Release Scope

What ships in the first release vs. later.

- **v1 (MVP):** _<feature IDs>_
- **v1.1 / Later:** _<feature IDs>_

---

### How the AI agent should use this doc
1. Treat **Goals** and **Key Features (P0)** as the contract for the MVP.
2. Respect **Non-goals** — do not build them unless asked.
3. When a feature is ambiguous, prefer the **acceptance criteria** over assumptions.
4. Cross-check every feature against the [TRD](./TRD.md), [App Flow](./APP-FLOW.md),
   and [Database Schema](./DATABASE-SCHEMA.md) before implementing.
