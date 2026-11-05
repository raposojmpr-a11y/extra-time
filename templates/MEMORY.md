# Shared memory — Claude + Codex + Gemini (index)
Read by every agent at startup. Details live in `~/shared/topics/<topic>.md` — **read only the topic relevant to the request**.

## Rules
- ALL memories are shared here. Nothing in an agent's private memory.
- Short facts, YYYY-MM-DD dates, author `[claude]`/`[codex]`/`[gemini]`. Edit the right topic; do not duplicate.
- Keep this index short (< ~1,000 tokens): new detail → its topic file; here only one line. Closed subjects → `archive/`.
- **Never** store passwords, tokens or keys here. Destructive / SSH / network actions → ask the user first.

## User
<!-- Name, how to address them, language, goals. -->

## Environment (summary) → `topics/environment.md`
<!-- e.g. Termux (Codex, Gemini) → Ubuntu proot-distro (Claude Code). -->

## Division of labour (work together when useful; tell the user when calling another agent)
- **Claude:** coordinates; Ubuntu; architecture, docs, memory; reviews.
- **Codex:** Termux/Android; network; focused code.
- **Gemini:** web research, long documents, third opinion (tie-breaker).
- Critical changes (SSH, network, boot, security): another agent reviews first.
- Call another agent: `~/shared/bin/delegate <codex|gemini|claude|auto> -t <type> "..."` (read-only by default; `-w` to write).

## Who is writing
🟠 **Claude** · 🟢 **Codex** · 🔵 **Gemini**. Text from another agent shown to the user is always labelled.

## Captain's armband
- **Captain (coordinates):** Claude → Codex → Gemini. If the user opens another agent because the captain is out of tokens, that agent takes over: read "Work in progress" and continue.
- `delegate` automatically passes the request to the next agent in the chain when one hits its limit, and puts it "on the bench" for a few hours (`delegate --status`).
- Check your own balance (`~/shared/bin/balance <agent>`, 0 tokens) at session start and before long tasks: ≥80% warn the user; ≥90% suggest "call the squad".
- **"call the squad"** (the user saw the CLI's usage-limit warning): the captain updates "Work in progress", hands the task to the next agent via `delegate` and, if it is long, tells the user which agent to open.

## Work in progress (update at every milestone)
- Nothing in progress.

## Token routing rules → `topics/token-usage.md`
- Do not delegate small tasks. Research / long reading → Gemini first.
- Requests to another agent: closed, exact files/lines, short answer.
- Read parts of files, not whole files. Topics only when relevant.
- Last usage review: **YYYY-MM-DD**.

## Topics
- `environment.md` — hardware, layers, access.
- `token-usage.md` — token optimisation and reviews.
