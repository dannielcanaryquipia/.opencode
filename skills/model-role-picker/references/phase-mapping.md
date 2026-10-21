# Phase Mapping — Selection Rules

Ordered rules for assigning roster models to work phases. Apply in the order given; earlier rules win.

## Requirements per Phase

| Phase | What must hold | Corroborating capabilities | Weak-fit signals |
|---|---|---|---|
| Planning / Architecture | Deep multi-step reasoning, structured output, large context for whole-repo reading | 1M-class context, tool calls, reflection-style deliberation | Small active-param speed models; context < 262K for monorepos |
| Development / Coding (primary implementation) | Strong coding benchmarks + reliable tool calling + repo-scale context | Native image input (screenshot-driven work), parallel tool calls | Text-only with < 256K for repo-scale work; no tool use |
| Debugging / Incident analysis | Long context (logs, traces), cheap cache for repeated replays, optional screenshot reading | 1M context + vision; low cache/token cost | Small contexts; vision-less when errors are UI-bound |
| QA / Testing | High throughput at low cost, bulk parallel runs, adequate (not maximal) reasoning | Cheap per-token cost, high TPS, tool calls for test harnesses | Flagship-depth reasoning (overkill spend), closed/proprietary when cost matters |
| Deployment / Ops automation | Agentic computer use, long multi-step tool chains, strict instruction following | Computer-use training or strong terminal-bench scores | Non-agentic models; models without tool calling |
| Security review | Vulnerability discovery/patching strength, careful reasoning | Published security/cyber evaluations, high effort ceiling | Speed-tier models; unverified previews |
| Documentation / Content | Fluency, accuracy, moderate context | Streaming, structured output | None critical |
| Vision: UI/design QA, doc & chart reading | Native image/video input | Video ingest, visual tool use | Text-only models |

## Application Rules (in order)

1. **Availability** — only models present in the current roster are candidates. Non-negotiable.
2. **Modality fit** — phases requiring image/video/audio are limited to models with that input modality. No modality, no candidacy.
3. **Privacy gate** — if the project is confidential/regulated/internal, filter to zero-retention models (or a self-hostable open-weight model, e.g., running Flint locally). Only then compare on capability.
4. **Capability depth vs. phase** — assign the deepest-reasoning available candidate to Planning and Security; assign flash-tier coding models to Development; speed-tier to QA/bulk work.
5. **Context vs. corpus** — if the phase reads corpora larger than ~256K tokens (monorepo onboarding, giant logs), prefer 1M-class context models.
6. **Cost/speed** — among equal-capability candidates, prefer cheaper/faster for high-volume phases; prefer deep-thought for low-volume high-stakes phases.
7. **Stability** — for critical phases prefer GA releases over `preview` checkpoints; `stealth`/unknown models are last resort.

## Tie-Breakers (when two or more candidates tie after rule 7)

1. Zero-retention policy beats limited retention beats unknown.
2. Verified public benchmarks beat vendor-only claims beat unverified.
3. Newer release (post-2600 in the same tier) beats older — model generations move fast; an Oct checkpoint beats a May sibling historically.
4. Open weights beat proprietary — preserves the user's ability to self-host and audit.
5. If still tied, record both and mark the assignment `PROBE RECOMMENDED` with the probe task below.

## Effort / Variant Guidance

| Phase | Effort / variant |
|---|---|
| Planning / Architecture | `high` or `max`; never `low` |
| Development | `high` default; `medium` acceptable for routine features |
| Debugging | `high`/`max` for trace-forensics; `low` for trivial repro loops |
| QA / Testing | `low`/`medium` |
| Deployment automation | `high` |
| Security review | `max` where supported; always-on-thought models preferred |
| Documentation | `low`/`medium` |
| Vision review | `medium` (bias to the vision-capable model itself) |

Models that always reason (e.g., effort max by default) cannot take effort `none`; do not route endless bulk chores to them when a thinking-off model exists.

## Unknown-Model Heuristics

Decode capability hints from the model ID when no profile exists:

| ID fragment | Likely meaning | Routing hint |
|---|---|---|
| `flash`, `lightning`, `spark`, `turbo`, `lite` | Speed tier; small active params | QA/bulk, fast dev chores |
| `pro`, `ultra`, `max`, `super-every` | Flagship depth | Planning, security, hard debugging |
| `vl`, `vision`, `omni`, `-m` | Multimodal input | UI/doc/video phases |
| `thinking`, `deepthink` | Always-on reasoning | Planning/analysis |
| `preview`, `exp`, `alpha`, `beta` | Experimental | Last-resort candidate |
| `free` (OpenCode suffix) | Free tier routing — says nothing about the model itself, but signals temporary availability | Verify, do not hard-depend |
| `stealth`/invented names (`big-pickle`-style) | Undisclosed identity | UNVERIFIED — probe first, zero confidential work |
| A/B conventions like `-4b`, `-30b-a3b`, `-501b` | Total/active param hints | Active-param < ~5B = speed tier; > ~10B active = depth tier |

If a decision hinges on an unknown model's real capability, fetch the official model card first; if that fails, probe (next section) before assigning.

## Probe Tasks (for UNVERIFIED / stealth models)

Run each probe on the target model and score pass/fail before trusting a critical assignment:

1. **Tool-use probe** — multi-step task with tool calls across 3+ files; checks harness reliability.
2. **Long-context probe** — feed ~200K-token corpus and ask a needle question early into the tail.
3. **Code probe** — request a repo test-suite fix; diff-check correctness.
4. **Vision probe** (only for multimodal claims) — screenshot of a UI bug; ask to locate and explain.
5. **Private-data sanity** — check the model's catalog/privacy metadata before sending any project-internal data; if "data may train", do not probe with real code.

## Interaction with MODEL-PLAN.md

- Every row chosen via application rules is signed-off as `RULE` with the rule number that decided it (e.g., `R3`, `TB2`).
- Every row resting on a tie-breaker or probe is marked `UNVERIFIED` or `PROBE RECOMMENDED` in the rationale column.
- Phase rows referencing retired models are rewritten on roster change; the retired model stays in the matrix's Retired section.
