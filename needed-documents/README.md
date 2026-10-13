# Needed Documents — AI-Assisted Coding Workflow

The essential planning documents to hand an AI coding agent before building a
product. Together they form a complete "context pack": *what* to build, *how*,
*where* users go, *what data* exists, *how it looks*, and *in what order* to ship.

Each document is a reusable template with guidance and a worked example based on
a simple task-management app (users · projects · tasks · comments).

## Documents

| Document | Purpose | One-liner |
|----------|---------|-----------|
| [Technical Guide](./TECHNICAL-GUIDE.md) | How to use this set | Ties the docs together; order of operations + conventions |
| [PRD](./PRD.md) | Product Requirements | Defines **what** to build — goals, users, features, metrics |
| [TRD](./TRD.md) | Technical Requirements | Defines **how** to build — architecture, stack, APIs, NFRs |
| [App Flow](./APP-FLOW.md) | User journey | Maps **screens, navigation, and decisions** |
| [Database Schema](./DATABASE-SCHEMA.md) | Data structure | Defines **tables and relationships** |
| [Design Brief](./DESIGN-BRIEF.md) | Look & feel | Guides **brand, color, type, key screens** |
| [Implementation Plan](./IMPLEMENTATION-PLAN.md) | Execution roadmap | Breaks work into **phases and timeline** |

## How to use

1. Start with the **[Technical Guide](./TECHNICAL-GUIDE.md)** — it explains the
   order the documents should be written and how they reference each other.
2. Fill the templates for your project, replacing the `_<placeholders>_`.
3. Keep names, IDs, and data shapes consistent across all docs.
4. Hand the full set to your AI coding agent and build phase by phase.

> Source: the six "ITPh" reference cards (PRD, TRD, App Flow, Database Schema,
> Design Brief, Implementation Plan), plus an added Technical Guide to tie them
> together.
