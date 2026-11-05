# Token usage across agents
No subscription (Claude Pro, ChatGPT, free Gemini) exposes the remaining balance reliably to a script → optimise through **own measurement + periodic review**.

## Components
1. **Lean memory:** `MEMORY.md` = short index; details in `topics/`; closed subjects in `archive/`.
2. **`bin/delegate`:** the single way for one agent to call another; logs every call to `~/shared/usage.csv`.
3. **`bin/usage-report [days]`:** summary per agent/type + Claude Code sessions + fixed cost of the memory.
4. **Review:** every ≥7 days the active agent proposes one; tune the routing rules and log the outcome below.

## Captaincy chains (in `bin/delegate`, function `chain`)
- research, docs: gemini → claude → codex
- termux, network, code: codex → claude → gemini
- review: codex → gemini → claude
- other: claude → codex → gemini

## Review log
- YYYY-MM-DD: …
