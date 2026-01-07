## IDE integration and enforcing Antigravity prompt policy

This document describes how to wire your IDE (VS Code) and CI to ensure the Antigravity policy files are applied and enforced.

1) Apply prompt rules into the repo

 - Windows (PowerShell):
   - Run the PowerShell script to write `.antigravity/allowed_prompts.json` and `.antigravity/prompt_rules.md`:
     ```powershell
     .\scripts\apply_prompt_rules.ps1
     ```

 - Unix (bash):
     ```bash
     ./scripts/apply_prompt_rules.sh
     ```

2) Run checks (CI and locally)

 - Locally (WSL/Git Bash):
     ```bash
     ./scripts/run_checks.sh 2>&1 | tee run_checks_output.txt
     ```

 - CI: a workflow `.github/workflows/run_checks.yml` is included and will run `./scripts/run_checks.sh` on push and PRs.

3) VS Code

 - Recommended extensions: GitHub Pull Requests, PowerShell, Prettier, GitLens (see `.vscode/extensions.json`).
 - Tasks are available in `.vscode/tasks.json`:
   - "Apply prompt rules (PowerShell)"
   - "Run checks (bash)"
   - "Do everything local (PowerShell)"

4) Enforce in the editor / wrapper

 - `agent_wrapper.py` is the runtime gatekeeper. Ensure any editor integration that forwards prompts to an LLM goes through the wrapper (for example, configure your IDE extension to call `python agent_wrapper.py` instead of calling the model directly).
 - The wrapper will look at `policy.yaml` and `.antigravity/*` files to decide whether to accept/execute prompts. If `policy.yaml.require_signed_prompts` is `true`, the wrapper will reject unsigned prompts.

5) PR checks / headers

 - The repo already includes `.github/workflows/header-check.yml` and `pr-guard.yml` to enforce Studio Header and prevent modify/delete.
 - `run_checks.yml` will run `scripts/run_checks.sh` in CI. Replace `run_checks.sh` with real linters/tests for stronger validation.

6) If you want stricter enforcement

 - Replace `scripts/run_checks.sh` with a script that runs linters and tests (example: install node, run `npm ci`, run `npm test`, `npm run lint`). If the repository contains JS/TS, add a `package.json` and standard config.
 - Optionally wire pre-commit hooks (husky/pre-commit) to run `./scripts/run_checks.sh` or formatters on commit.

If you want, I can: (choose)
- Implement a realistic `scripts/run_checks.sh` for JS/React (create a minimal package.json + npm-based checks) and re-run CI locally.
- Prepare instructions/snippets to configure your IDE to route prompts through `agent_wrapper.py`.
