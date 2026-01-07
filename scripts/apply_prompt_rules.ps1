Param()
$ErrorActionPreference = 'Stop'
$Root = Split-Path -Path $PSScriptRoot -Parent
$Dest = Join-Path $Root ".antigravity"
if (!(Test-Path $Dest)) { New-Item -ItemType Directory -Path $Dest | Out-Null }
$allowed = @{ agent_name = 'Antigravity-Strict'; allowed_prompt_patterns = @('^/describe','^/summarize','^/format','^/explain','^/readonly-check'); deny_file_ops = $true; deny_shell_exec = $true; require_signed_prompts = $false; allowed_writable_paths = @('tmp/','scratch/'); enforce_git_policy = $true; audit_enabled = $true }
$allowed | ConvertTo-Json -Depth 4 | Out-File -FilePath (Join-Path $Dest 'allowed_prompts.json') -Encoding UTF8
@'
/**
 * DẠ HÀNH STUDIO - PROJECT REBUILDER
 * File: .antigravity/prompt_rules.md
 */
Mục đích: Xem .antigravity/allowed_prompts.json để áp dụng runtime policy cho wrapper/agent.
'@ | Out-File -FilePath (Join-Path $Dest 'prompt_rules.md') -Encoding UTF8
Write-Output "Prompt rules written to $Dest (allowed_prompts.json + prompt_rules.md)"
