# Model Matrix — OpenCode Free-Tier Profiles

Verified profiles of models that have appeared in the OpenCode free-tier roster. Facts are compiled from official model cards, provider docs, and OpenCode's model documentation.

**As of: 2026-10-22**

## Entry Format

When adding a model, follow this schema exactly:

```
### <opencode-model-id>
- Display / owner:
- Released:
- Size: total / active params
- Context / max output:
- Modalities: input -> output
- Reasoning: effort control, thinking behavior
- Tools & output: tool calling, structured output, streaming
- License / price (paid tier):
- Privacy during free period: zero-retention | 30-day retention | data may train | not specified
- Best phases (1-3, per phase-mapping.md):
- Caveats:
- Verified sources + date:
```

Retention-tier definitions:

- **zero-retention** — provider applies a zero-retention policy and does not use data for training during the free period.
- **30-day retention** — provider retains data (typically 30 days) but does not train on it during the free period.
- **data may train** — provider may use collected data to improve the model during the free period.
- **not specified** — no published free-period data policy found; treat as unknown and probe if confidential work is involved.

Weight availability matters for privacy: an open-weight model under a permissive license can be self-hosted, removing the hosted provider's data policy entirely.

---

## Deep Reasoning Tier

### opencode/nemotron-3-ultra-free
- Display / owner: Nemotron 3 Ultra / NVIDIA
- Released: 2026-06-04 (weights; announced 2026-06-01)
- Size: 550B total / 55B active, hybrid Mamba-Transformer MoE
- Context / max output: documented NVIDIA family context up to 1M; OpenCode free-tier effective limit unverified
- Modalities: text -> text
- Reasoning: strong — the deep-reasoning benchmark king of this roster: GPQA Diamond 86.7%, SWE-bench Verified 71.9%, HLE (with tools) 26.7%
- Tools & output: tool use, agentic
- License / price: open weights + training data + recipes
- Privacy during free period: not specified
- Best phases: Planning/architecture, deep security review, hardest analysis
- Caveats: text-only; heavier/slower than flash tier; superseded capability-wise by Nemotron 3.5 Super in some schemes — verify current revision when routing
- Verified sources + date: aireleasetracker.com, NVIDIA research, 2026-10-22

### opencode/beam-free
- Display / owner: Beam 1.0 / Reflection AI
- Released: mid-Oct 2026 (tracked 2026-10-16)
- Size: 501B total / 23B active (a23b)
- Context / max output: 1,048,576 / 131,072 (models.dev)
- Modalities: text -> text
- Reasoning: reflection-style deep deliberation; frontier-class scoring on shared agentic benchmarks
- Tools & output: tool calling, structured output, reasoning variants per models.dev
- License / price: free-tier only here; paid tiers exist on other providers
- Privacy during free period: 30-day retention (no training use)
- Best phases: Planning/architecture, complex development, deep code review
- Caveats: very new model; capabilities still stabilizing in public leaderboards
- Verified sources + date: models.dev OpenCode Go listing, opencode.ai docs, 2026-10-22

---

## Flash-Tier Agentic Coding (Primary Dev Workhorses)

### opencode/glm-5.3-flash-free
- Display / owner: GLM-5.3-Flash / Z.ai (Zhipu AI)
- Released: 2026-08-26 (family: GLM-5.3 flagship 2026-08-14; GLM-5.3-FlashX throughput variant 2026-09-18)
- Size: 320B total / 18B active (MoE)
- Context / max output: 1,048,576 / 131,072
- Modalities: text, image, video -> text (first natively multimodal GLM-5-series model)
- Reasoning: thinking on by default; reasoning, streaming, JSON schema, tool/function calling
- License / price: MIT open weights; ~$0.15-0.195 in / $0.65 out per 1M
- Privacy during free period: zero-retention
- Best phases: Development/coding (primary default), planning/structuring, code review
- Caveats: vendor benchmark claim "approaches Claude Opus 4.8 on coding/agentic" is not independently reproduced
- Verified sources + date: z.ai blog, aimlapi model page, opencode docs, 2026-10-22

### opencode/deepseek-v4.1-flash-free
- Display / owner: DeepSeek-V4.1-Flash / DeepSeek-AI
- Released: 2026-09-10; current revision "1017" (2026-10-17 re-checkpoint)
- Size: 552B total; Causal Encoder-Decoder — 8B active prefill / 16B decode
- Context / max output: 1,048,576 / 384K
- Modalities: native text + image input (DeepSeek-ViT; DocVQA 95.6, RefCOCO 86.0); text throughout
- Reasoning: effort levels low / high / max, thinking on at high by default
- Tools & output: JSON output, tool calls, context caching, FIM, Chat Prefix Completion
- License / price: MIT open weights; ~$0.30 in / $1.20 out per 1M
- Privacy during free period: zero-retention
- Best phases: Debugging (long logs + screenshots), repo-scale development, doc/chart analysis
- Caveats: engine is tuned for input-heavy agent workloads; KV cache 890 B/token makes long-context serving the cheapest of this roster
- Verified sources + date: deepseek.com news, api-docs.deepseek.com, Baseten/DeepInfra, Vals AI, 2026-10-22

### opencode/minimax-m3.1-flash-free
- Display / owner: MiniMax M3.1 Flash / MiniMax
- Released: 2026-10-19 GA (M3.1-Flash-Preview 2026-09-27; internally "Space Bunny"; replaced M2.5/M2.7 routing 2026-10-19)
- Size: unpublished
- Context / max output: 1,048,576 (512K recommended config) / up to 512K
- Modalities: text, image, video -> text
- Reasoning: always-on; effort levels low / medium / high / xhigh / max (default max); `none` unsupported (would 400)
- Tools & output: OpenAI- and Anthropic-compatible endpoints, tool calls, reasoning summaries
- License / price: proprietary (closed weights); ~$0.15 in / $0.60 out per 1M
- Privacy during free period: zero-retention
- Best phases: Deployment/ops automation (computer use), security review (code audit, vuln patching, pentest, rev-eng), enterprise workflow automation
- Caveats: weights closed; speed strong (vendor-reported 200+ TPS); "computer use" applies only where the harness supports it
- Verified sources + date: minimax.io blog + docs, llm-stats, startupfortune, 2026-10-22

### opencode/flint-40b-free
- Display / owner: Flint 40B / Recursive (built with the Eureka Machine)
- Released: 2026-10-21
- Size: 40B total / ~2.5B active (MoE, sliding-window attention)
- Context / max output: 262,144 / unverified
- Modalities: text -> text
- Reasoning: supports reasoning; trained for tool use
- Tools & output: tool calling, agentic harnesses
- License / price: Apache 2.0 open weights (small enough for laptops — also available via Ollama/LM Studio/vLLM locally)
- Privacy during free period: not specified (but the only roster member you can fully self-host cheaply)
- Best phases: QA/test writing, fast dev chores, small-repo coding iterations
- Caveats: 262K context (smaller than 1M-tier peers); benchmarks: SWE-bench Verified 74.2%, Terminal-Bench 2.1 54.9%, top under-50B MoE class; >125 tok/s on a MacBook M4 Pro (local)
- Verified sources + date: sglang cookbook, vllm.ai blog, ollama release notes, gate news, 2026-10-22

---

## Speed / High-Volume Tier

### opencode/nemotron-3.5-lightning-free
- Display / owner: Nemotron 3.5 Lightning 30B-A3B / NVIDIA
- Released: 2026-08-11
- Size: 30B total / 3B active, hybrid Mamba-2 + MoE + attention, native multi-token prediction (MTP)
- Context / max output: 262,144 on most hosted providers (model card claims up to 1M — verify per deployment)
- Modalities: text -> text
- Reasoning: configurable reasoning budget, on/off
- Tools & output: tool calls, RAG-oriented, chat
- License / price: OpenMDW 1.1 + NVFP4 variants; ~$0.08 in / $0.20 out per 1M
- Privacy during free period: not specified
- Best phases: Bulk QA/agentic chores, high-volume tool-calling, fast iteration loops
- Caveats: fastest-first design — up to ~4x output speed of similar-size open models; PinchBench 86% at 30% less task time; SWE-bench Verified 51.56 is below the 1M-depth national-tier models; AA Intelligence Index 24 (mid-tier)
- Verified sources + date: research.nvidia.com, build.nvidia.com model card, jetson-ai-lab, how2shout, OpenRouter endpoint data, 2026-10-22

### opencode/mimo-v2.6-flash-free
- Display / owner: MiMo-V2.6-Flash / Xiaomi
- Released: 2026-09-22 (series announcement)
- Size: 309B total / 15B active (MoE)
- Context / max output: 1M / 128K
- Modalities: omnimodal — text, image, video, audio -> text (audio makes it unique in this roster)
- Reasoning: thinking enabled; supports function calling, structured output, web search, streaming
- Tools & output: function calling, structured output, web search
- License / price: MIT open weights (Flash-RL checkpoint); ~$0.14 in / $0.28 out per 1M
- Privacy during free period: not specified
- Best phases: QA/high-frequency office workflows, multimodal + audio tasks, content generation
- Caveats: positioned as the intelligence/efficiency/cost balance option; outperforms MiMo-V2.5-Pro comprehensively
- Verified sources + date: mimo.xiaomi.com, mimo.mi.com docs, HF XiaomiMiMo card, mindstudio blog, 2026-10-22

---

## Native Vision Tier

### opencode/nemotron-3.5-super-vl-free
- Display / owner: Nemotron 3.5 Super (VL-capable) / NVIDIA
- Released: 2026-10-14 (research publication)
- Size: 120B total / 12B active, hybrid Mamba-Transformer MoE
- Context / max output: 1M class per family docs
- Modalities: text, images, video, interactive tool environments -> text
- Reasoning: distillation + RL from Nemotron 3 Ultra lineage; agentic mid-training
- Tools & output: visual tool use, software-engineering agents, long-running interactive workloads
- License / price: open (NVIDIA open-model family)
- Privacy during free period: not specified (OpenCode notes it is a limited-time free-period model, feedback collection)
- Best phases: UI/design QA, document/chart understanding, vision agents
- Caveats: SWE-bench Pro 51.78% surpassing Nemotron 3 Ultra with ~4.6x fewer active params; strongest native multimodal roster member for interactive visual work
- Verified sources + date: research.nvidia.com, opencode.ai docs, 2026-10-22

### opencode/longcat-2.5-preview-free
- Display / owner: LongCat 2.5 Preview / Meituan
- Released: preview, tracked ~2026-10 (family: LongCat-Flash-Chat 2025-09-09, Flash-Lite 2026-02-05, LongCat-2.0 later 2026)
- Size: family LongCat-Flash base is 560B / ~27B active
- Context / max output: ~1.05M
- Modalities: text, vision -> text (per capability tags)
- Reasoning: tools + reasoning tags on trackers
- Tools & output: tool calling
- License / price: family MIT open weights; ~$0.30 in / $1.20 out per 1M on paid tiers
- Privacy during free period: not specified
- Best phases: giant long-context document analysis, preview-eval of very large corpora
- Caveats: preview/experimental status — treat as UNVERIFIED; benchmark record for the exact 2.5 Preview checkpoint is thin
- Verified sources + date: modelcompare.dev (tags), family specs from Meituan sources, 2026-10-22

---

## Stealth / Unknown

### opencode/big-pickle
- Display / owner: "Big Pickle" — stealth/unnamed model
- Released: present in OpenCode free catalog; identity undisclosed
- Size: unknown
- Context / max output: unknown (catalog lists it alongside 1M-resource free picks; verify per probe)
- Modalities: unknown
- Reasoning: unknown
- Tools & output: catalog lists the standard OpenAI-compatible tooling surface; verify per probe
- License / price: free only
- Privacy during free period: data may train (OpenCode states collected data may be used to improve the model during its free period)
- Best phases: none for confidential or quality-critical phases
- Caveats: always UNVERIFIED — probe with small representative tasks before trusting; never route confidential work here; if vendor docs identify it later, promote it to a full entry
- Verified sources + date: opencode.ai/v2/docs/console/models, 2026-10-22

---

## Privacy Ledger (hosted free tier)

| Model | Free-period data handling |
|---|---|
| glm-5.3-flash-free | zero-retention |
| deepseek-v4.1-flash-free | zero-retention |
| minimax-m3.1-flash-free | zero-retention |
| beam-free | 30-day retention |
| big-pickle | data may train |
| nemotron-3-ultra-free | not specified |
| nemotron-3.5-super-vl-free | not specified |
| nemotron-3.5-lightning-free | not specified |
| mimo-v2.6-flash-free | not specified |
| longcat-2.5-preview-free | not specified |
| flint-40b-free | not specified (but self-hostable; Apache 2.0) |

Route any confidential/internal/regulated work to zero-retention models, or to Flint 40B running locally.

## Extension Checklist

1. Confirm the model actually appears in the user's current `opencode models` roster.
2. Gather specs from official sources (provider docs, Hugging Face model card, OpenCode models page). Record each fact's source date.
3. Fill the entry format above completely; leave `unverified` markers where data is missing.
4. Classify into exactly one tier section above; create a new tier section only when no existing tier fits.
5. Update the privacy ledger row.
6. If a roster change retires a model, move its entry to a "Retired" section at the bottom with its retirement date rather than deleting it (preserves history for project plans).
