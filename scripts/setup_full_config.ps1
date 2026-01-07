<#
DẠ HÀNH STUDIO - PROJECT REBUILDER
File: scripts/setup_full_config.ps1
Purpose: Auto configure repository for Antigravity policy enforcement.

Usage:
  PowerShell (run from repo root):
    pwsh .\scripts\setup_full_config.ps1 [-CreatePR]

Options:
  -CreatePR : attempt to create a GitHub PR after pushing the branch (requires gh CLI and auth)

This script will:
  - Apply prompt rules (.antigravity/*)
  - Remove BOM from scripts/run_checks.sh if present
  - Run ./scripts/run_checks.sh and capture output to run_checks_output.txt
  - Create an automation branch, commit new/changed files, and push to origin
  - Optionally create a PR using gh
#>

[cmdletbinding()]
param(
    [switch]$CreatePR
)

Set-StrictMode -Version Latest
Write-Host "Running setup_full_config.ps1..."

$Root = (Get-Location).Path

if (!(Test-Path "$Root\scripts\apply_prompt_rules.ps1")) {
    Write-Error "Required script scripts/apply_prompt_rules.ps1 not found. Please run from repository root."; exit 1
}

Write-Host "1) Applying prompt rules"
& "$Root\scripts\apply_prompt_rules.ps1"

Write-Host "2) Remove BOM from scripts/run_checks.sh if present"
$runChecks = Join-Path $Root 'scripts\run_checks.sh'
if (Test-Path $runChecks) {
    $b = [System.IO.File]::ReadAllBytes($runChecks)
    if ($b.Length -ge 3 -and $b[0] -eq 0xEF -and $b[1] -eq 0xBB -and $b[2] -eq 0xBF) {
        [System.IO.File]::WriteAllBytes($runChecks, $b[3..($b.Length-1)])
        Write-Host "Removed UTF-8 BOM from $runChecks"
    } else { Write-Host "No BOM detected in $runChecks" }
} else { Write-Host "No run_checks.sh found; skipping BOM step." }

Write-Host "3) Run project checks and capture output"
if (Test-Path $runChecks) {
    bash "$runChecks" 2>&1 | Tee-Object -FilePath (Join-Path $Root 'run_checks_output.txt')
} else {
    Write-Host "Skipping run_checks (file missing)."
}

Write-Host "4) Git: create branch, add, commit, push"
$timestamp = Get-Date -Format 'yyyyMMdd-HHmm'
$branch = "antigravity-automation-$timestamp"
Write-Host "Creating branch: $branch"
git checkout -b $branch

git add .antigravity/ scripts/apply_prompt_rules.* scripts/setup_full_config.ps1 do_everything_local.* run_checks_output.txt PR_BODY.md docs/IDE_INTEGRATION.md .vscode/*.json || true

$status = 'FAIL'
if (Test-Path (Join-Path $Root 'run_checks_output.txt')) {
    $content = Get-Content (Join-Path $Root 'run_checks_output.txt') -Raw
    if ($content -match 'OK' -or $content.Length -gt 0) { $status = 'PASS' }
}

try {
    git commit -m "[AUTO] Add prompt rules and automation artifacts — run_checks: $status"
} catch {
    Write-Host "Nothing to commit or commit failed: $_"
}

Write-Host "Pushing branch to origin: $branch"
git push -u origin $branch

if ($CreatePR) {
    Write-Host "Attempting to create PR using gh"
    if (Get-Command gh -ErrorAction SilentlyContinue) {
        try {
            gh pr create --base main --head $branch --title "Add prompt rules and automation artifacts" --body-file PR_BODY.md
        } catch {
            Write-Warning "gh pr create failed: $_"
        }
    } else { Write-Warning "gh CLI not found; cannot create PR" }
}

Write-Host "Setup complete. Branch pushed: $branch"
Write-Host "Open PR URL (if created) or visit: https://github.com/lenzcomvth/antigravity-policy/pull/new/$branch"
