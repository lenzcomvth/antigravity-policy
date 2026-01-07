#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "$ROOT/.antigravity"
cat > "$ROOT/.antigravity/allowed_prompts.json" <<'JSON'
{ "agent_name": "Antigravity-Strict", "allowed_prompt_patterns": ["^/describe","^/summarize","^/format","^/explain","^/readonly-check"], "deny_file_ops": true, "deny_shell_exec": true, "require_signed_prompts": false, "allowed_writable_paths": ["tmp/","scratch/"], "enforce_git_policy": true, "audit_enabled": true }
JSON
cat > "$ROOT/.antigravity/prompt_rules.md" <<'MD'
/**
 * DẠ HÀNH STUDIO - PROJECT REBUILDER
 * File: .antigravity/prompt_rules.md
 */
Mục đích: Xem .antigravity/allowed_prompts.json để áp dụng runtime policy cho wrapper/agent.

MD
echo "Prompt rules written to .antigravity/ (allowed_prompts.json + prompt_rules.md)"
#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "$ROOT/.antigravity"
cat > "$ROOT/.antigravity/allowed_prompts.json" <<'JSON'
{ "agent_name": "Antigravity-Strict", "allowed_prompt_patterns": ["^/describe","^/summarize","^/format","^/explain","^/readonly-check"], "deny_file_ops": true, "deny_shell_exec": true, "require_signed_prompts": false, "allowed_writable_paths": ["tmp/","scratch/"], "enforce_git_policy": true, "audit_enabled": true }
JSON
cat > "$ROOT/.antigravity/prompt_rules.md" <<'MD'
/**
 * DẠ HÀNH STUDIO - PROJECT REBUILDER
 * File: .antigravity/prompt_rules.md
 */
Mục đích: Xem .antigravity/allowed_prompts.json để áp dụng runtime policy cho wrapper/agent.
MD
echo "Prompt rules written to .antigravity/ (allowed_prompts.json + prompt_rules.md)"
