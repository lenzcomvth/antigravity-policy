<#
DẠ HÀNH STUDIO - PROJECT REBUILDER
File: scripts/apply_prompt_rules.ps1
Purpose: Write allowed_prompts.json and prompt_rules.md into .antigravity (Windows)
#>
param()

$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
New-Item -ItemType Directory -Force -Path (Join-Path $Root '.antigravity') | Out-Null

$allowed = @{
    agent_name = 'Antigravity-Strict'
    allowed_prompt_patterns = @('^/describe','^/summarize','^/format','^/explain','^/readonly-check')
    deny_file_ops = $true
    deny_shell_exec = $true
    require_signed_prompts = $false
    allowed_writable_paths = @('tmp/','scratch/')
    enforce_git_policy = $true
    audit_enabled = $true
}

$allowed | ConvertTo-Json -Depth 4 | Out-File -FilePath (Join-Path $Root '.antigravity\allowed_prompts.json') -Encoding UTF8

$md = @'
/**
 * DẠ HÀNH STUDIO - PROJECT REBUILDER
 * File: .antigravity/prompt_rules.md
 */
Mục đích: Xem .antigravity/allowed_prompts.json để áp dụng runtime policy cho wrapper/agent.

'@

$md | Out-File -FilePath (Join-Path $Root '.antigravity\prompt_rules.md') -Encoding UTF8

Write-Host "Prompt rules written to .antigravity/ (allowed_prompts.json + prompt_rules.md)"
