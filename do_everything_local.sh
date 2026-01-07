#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
echo "Running local setup from $ROOT"

# Ensure scripts are executable
chmod +x "$ROOT/scripts/apply_prompt_rules.sh" || true

# Apply prompt rules (writes .antigravity files)
bash "$ROOT/scripts/apply_prompt_rules.sh"

# Ensure run_checks is executable
chmod +x "$ROOT/scripts/run_checks.sh" || true

echo "Running project checks (this may take a bit). Output -> run_checks_output.txt"
bash "$ROOT/scripts/run_checks.sh" 2>&1 | tee "$ROOT/run_checks_output.txt"

# Git: create branch, add, commit, push
BRANCH="antigravity-automation-$(date -u +%Y%m%d-%H%M)"
echo "Creating branch $BRANCH"
git checkout -b "$BRANCH"
git add .antigravity/ scripts/apply_prompt_rules.* run_checks_output.txt || true
if git commit -m "[AUTO] Add prompt rules and automation artifacts — run_checks: $(if [ -s run_checks_output.txt ]; then echo PASS; else echo FAIL; fi)"; then
  git push -u origin "$BRANCH"
  echo "Branch pushed: $BRANCH"
else
  echo "Nothing to commit or commit failed." >&2
fi

echo "Done. If you want to open a PR locally using gh, run:"
echo "  gh pr create --base main --head $BRANCH --title \"Add prompt rules and automation artifacts\" --body-file run_checks_output.txt"
