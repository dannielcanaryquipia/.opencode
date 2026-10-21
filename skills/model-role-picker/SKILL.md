---
name: model-role-picker
description: This skill should be used when selecting or mapping AI models to project work phases (planning, architecture, development, debugging, QA/testing, deployment, security review, documentation, vision/UI review) in an OpenCode environment — for example when the user runs /models and asks which model to use for which task, asks to build a model decision table, requests a per-project model plan, or reports that the model roster has changed. It discovers the models actually available in the current OpenCode setup, classifies each model's strengths (reasoning depth, speed, multimodality, context length, privacy handling), and generates or updates a per-project decision table at MODEL-PLAN.md.
---

# Model Role Picker

## Overview

Map the models available in the current OpenCode setup to project work phases, producing a per-project decision table at `MODEL-PLAN.md` (project root, or `docs/MODEL-PLAN.md` when the project already uses a `docs/` convention).

The OpenCode free-tier model roster rotates frequently — models appear and retire every few weeks, and stealth/preview models appear without documentation. Availability must always be discovered at runtime; never assume a specific model still exists.

## Workflow

### Step 1 — Discover available models

Run `opencode models` and capture the full list of `provider/model` IDs, one per line. In the OpenCode TUI the equivalent action is the user pressing `/models`.

If the command fails or returns nothing, ask the user to paste their `/models` output and continue from that list.

### Step 2 — Profile each model

- For every model ID detected, check `references/model-matrix.md` for a known profile and reuse its verified facts.
- For unknown IDs, apply the naming heuristics in `references/phase-mapping.md` (`flash`/`lightning` = speed tier, `ultra`/`pro` = flagship depth, `vl`/`super-vl` = native vision, `preview` = experimental, `free` = OpenCode free tier routing).
- When a phase decision hinges on a capability of an unknown model, fetch its official model card (provider docs / Hugging Face) before asserting a spec.
- Missing data is recorded as `unverified`. Never invent benchmarks, context sizes, or modality support.

### Step 3 — Map models to project phases

Load `references/phase-mapping.md` and process it in order:

1. Application rules: match each phase's requirement to roster models that satisfy it.
2. Tie-breakers: when two or more models fit a phase, break ties with the ordering given there (privacy constraints > verified specs > stability).
3. Record `UNVERIFIED` next to any assignment that rests on an unknown or stealth model, and list a probe task to validate it.

### Step 4 — Generate MODEL-PLAN.md

Build the file from `assets/decision-table-template.md` and write it to the project root:

- Header records generation date, the source command, and detected model count.
- Include a roster snapshot table and the phase decision table (Primary / Fallback / Effort variant / Rationale per phase).
- Include the privacy-routing section.
- If `MODEL-PLAN.md` already exists and the roster changed, regenerate the tables and add a "Roster changes" section listing models added and removed since the previous generation. Never silently overwrite without noting the diff.
- Do not create multiple plan files per project; update the existing one.

### Step 5 — Maintain the knowledge base

When the user mentions or the roster surfaces a model absent from `references/model-matrix.md`:

1. Research its official model card or release notes.
2. Append an entry following the entry format defined at the top of `references/model-matrix.md`, including the `As of` date.
3. When a matrix entry is contradicted by newer official data (model retired, pricing changed, revision bump like `.1` or a date-suffix), overwrite the entry facts and bump its `As of` date rather than appending a duplicate.

## Quick Decision Cheatsheet

Distill from the references; details live in `references/model-matrix.md` and `references/phase-mapping.md`:

| Task shape | Reach for | Model families |
|---|---|---|
| Planning, architecture, hardest reasoning | Deep-reasoning tier | `*-fl / -ultra-free`, flagship-class models |
| Repo-scale development, agents, code review | Flash-tier coding models | `glm-5.3-flash-free`, `deepseek-v4.1-flash-free`, `minimax-m3.1-flash-free`, `flint-40b-free` |
| Bulk QA, tests, high-volume chores | Speed tier | `*-lightning-free`, `flint-40b-free`, `mimo-v2.6-flash-free` |
| Debugging from logs/screenshots | Long-context multimodal | `deepseek-v4.1-flash-free`, 1M-context multimodal models |
| Deployment automation, computer use | Agentic computer-use | `minimax-m3.1-flash-free` |
| UI/design QA, document reading, video | Native vision tier | `nemotron-3.5-super-vl-free`, `*super-vl*`, omnimodal models |
| Confidential/zero-retention work | Zero-retention providers | see privacy table in matrix |

## Hard Rules

- Source of truth for availability is `opencode models` at run time. Never route work to a model ID that does not appear in the current roster.
- Never state benchmarks, context limits, or modality support without a source; use `unverified` otherwise.
- Flag privacy tier for every recommendation: zero-retention, retention-limited, or data-used-for-training (see the privacy table in the matrix). Route confidential work to zero-retention models only.
- Stealth and preview models are `UNVERIFIED` by default; recommend a small probe task before assigning them a critical phase.
- One decision table per project; update rather than duplicate.

## Example Invocations

- "update my model plan" — run the workflow steps 1-4 and produce/refresh `MODEL-PLAN.md`.
- "which model should I use to debug this repo" — steps 1-3, answer from the roster plus matrix; cite the phase table row that supports the answer.
- "there's a new model in /models called X" — step 5: profile it, extend the matrix, then refresh the plan if a roster change affects assignments.

## Resources

This skill uses references and assets only (no scripts needed — model discovery is a single `opencode models` call):

- `references/model-matrix.md` — verified profiles of known free-tier models, their strengths, context windows, licenses, and OpenCode data-handling policies, plus the entry format for extending it.
- `references/phase-mapping.md` — per-phase capability requirements, the ordered selection rules, tie-breakers, and heuristics for classifying unknown models.
- `assets/decision-table-template.md` — the skeleton copied into `MODEL-PLAN.md` when generating the per-project decision table.
