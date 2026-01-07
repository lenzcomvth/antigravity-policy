#!/bin/bash
SRC_DIR="$(cd "$(dirname "$0")/.." && pwd)"
GIT_HOOKS_DIR="$(git rev-parse --git-dir 2>/dev/null || echo ".git")/hooks"
if [ ! -d "$GIT_HOOKS_DIR" ]; then echo "No .git/hooks found; run from repo root"; exit 2; fi
cp "$SRC_DIR/.git/hooks/pre-commit" "$GIT_HOOKS_DIR/pre-commit"
chmod +x "$GIT_HOOKS_DIR/pre-commit"
echo "Pre-commit installed."
