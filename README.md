# ⚽ EXTRA TIME 🟠🟢🔵

### Three AIs. One phone. Zero downtime.

*Your AI ran out of tokens? The match goes to extra time.*

> 🚧 **Ongoing project — work in progress.** It works and is used daily, but things will change, break and improve. Feedback, issues and PRs are very welcome.

**A squad of AI coding agents — Claude Code, OpenAI Codex and Gemini CLI — working together on an old Android phone, with shared memory, division of labour, and a "captain's armband" that passes the work to the next agent when one runs out of tokens.**

It runs on your **regular subscriptions** (Claude Pro, ChatGPT, free Gemini) through the official CLIs — no pay-per-token APIs required.

> Like in football: when the captain leaves the pitch, the armband goes to the vice-captain, and so on.

## Features
- **Lean shared memory** — one `MEMORY.md` (a short index, < ~1,000 tokens) read by every agent at startup, plus `topics/` files read only when relevant. Each agent points to it from its own instruction file (`CLAUDE.md`, `AGENTS.md`, `GEMINI.md`).
- **`delegate`** — the single way for one agent to call another non-interactively (`codex exec`, `gemini -p`, `claude -p`):
  - read-only by default (`-w` to allow writes);
  - logs input/output/cache tokens, duration and status to `usage.csv`;
  - visual identity of who is replying: 🟠 Claude · 🟢 Codex · 🔵 Gemini.
- **Captain's armband** 🎽 — every task type has a chain (captain → vice → third). If the captain hits its usage limit, the request automatically goes to the next agent, and the exhausted one sits "on the bench" for a few hours so no calls are wasted retrying it.
- **`usage-report`** — usage per agent and task type, so you can tune routing rules with real data over time.

## Tested architecture
```
SSH client (another phone / PC)
  └─ Android → Termux: sshd, Codex CLI, Gemini CLI
       └─ Ubuntu via proot-distro: Claude Code
            ~/shared/ (in the Termux home, visible from both layers)
              MEMORY.md · topics/ · archive/ · bin/delegate · bin/usage-report · usage.csv
```
Claude Code runs inside Ubuntu (PRoot) because its native binary does not run directly on Termux's Bionic libc.

## Requirements
- ARM64 Android with Termux (from F-Droid) and `proot-distro` with Ubuntu.
- Claude Code installed in Ubuntu; Codex CLI and Gemini CLI in Termux (`npm i -g @openai/codex @google/gemini-cli`), each one logged in / with its API key.
- Termux's `bash` and `python3`.

## Install
```bash
git clone https://github.com/raposojmpr-a11y/extra-time
cd extra-time && ./install.sh
```
The installer never deletes anything: it creates `~/shared/`, copies the scripts and **appends** a block to each agent's instructions (only once). Then fill in the *User* and *Environment* sections of `~/shared/MEMORY.md`.

Other systems (Linux PC, Raspberry Pi): set `SQUAD_HOME`, `SQUAD_PREFIX` and `SQUAD_CLAUDE_DIR` before running. Adapting it to a regular Linux box is one of the open items — contributions welcome.

## Usage
```bash
delegate codex -t review "Review bin/script.sh lines 10-40; do not read other files."
delegate auto  -t research "What is the latest stable llama.cpp release?"
delegate --status            # who is on the bench
delegate --release codex     # put an agent back manually
usage-report 7               # usage for the last 7 days
```
Task types: `research · termux · network · code · review · docs · other`.

In a chat with any agent, say **"call the squad"** when the CLI warns you are close to your usage limit: the agent saves the work in progress and hands it to the next one.

## Honest limitations
- There is no official API for the remaining balance of these subscriptions. EXTRA TIME currently detects limits from error-message text, and the "bench" time is an estimate. (Other projects probe Claude Code's `/usage` screen through tmux to switch *before* the limit — on the roadmap here.)
- An interactive agent that runs out of tokens cannot pass the armband by itself — that is why "call the squad" and the *Work in progress* section exist.
- Gemini CLI needs `TERMUX_VERSION` set when called from PRoot (`delegate` handles it).
- Tested on one ARM64 Android phone (Android 16). Other devices may need tweaks.

## Roadmap
- [ ] Proactive switch before the limit (probe `/usage` / `/status`), not only after it.
- [ ] Regular Linux / macOS / WSL support (move from the phone to a home server).
- [ ] More players on the bench: local models (llama.cpp / Ollama), Aider, OpenCode.
- [ ] Per-CLI limit detection tests.
- [ ] Bootstrap script to rebuild the whole squad on a new machine.

## Related projects
Multi-agent orchestration is a growing space — check these out too:
- [selftalk](https://github.com/chkydebug/selftalk) — Claude Code / Gemini CLI / Codex orchestration with usage-based smart routing.
- [coding_agent_orchestrator](https://github.com/manikDH/coding_agent_orchestrator) — Claude Code as a manager of several agent CLIs.
- [cli-orchestrator-mcp](https://github.com/lleontor705/cli-orchestrator-mcp) — MCP server with retries, circuit breaker and fallback.

What EXTRA TIME focuses on: running the whole squad **on an Android phone**, a **token-lean shared memory**, the **bench**, and a **usage log** that you use to tune routing over time.

## Contributing
Ideas, bug reports and pull requests are very welcome — see [CONTRIBUTING.md](CONTRIBUTING.md). Especially wanted:
- support for regular Linux / macOS / WSL paths;
- more agents (local models via llama.cpp / Ollama, Aider, OpenCode…);
- better limit detection per CLI.

## License
MIT
