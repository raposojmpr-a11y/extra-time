# Contributing

Thanks for your interest! This started as a personal home-lab project, so feedback from people running other setups is the most valuable thing you can give.

- **Bugs:** open an issue with your device / OS, how you called `delegate`, and the last lines of output. Remove any tokens, keys or personal data first.
- **Ideas:** open an issue describing the use case before a large pull request.
- **Pull requests:** keep them small and focused; test `bash -n bin/delegate` and run `delegate --status` before submitting.
- **New agents:** add a branch in `run_agent()` (how to call it, how to read its reply and token usage) and a place in the `chain()` function.

Never commit `usage.csv`, `accounts-state.json`, `.env` files or any credentials.
