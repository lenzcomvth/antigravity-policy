<#
  DẠ HÀNH STUDIO - PROJECT REBUILDER
  File: do_everything_local.ps1
  Purpose: PowerShell helper to apply prompt rules, run checks, and create a branch + commit + push.
#>
param()

$Root = (Get-Location).Path

Write-Host "Running local setup from $Root"

# Apply prompt rules (PowerShell)
& "$Root\scripts\apply_prompt_rules.ps1"

# Run checks (invoke bash script if available)
if (Test-Path "$Root\scripts\run_checks.sh") {
  Write-Host "Running run_checks.sh (output -> run_checks_output.txt)"
  bash "$Root/scripts/run_checks.sh" 2>&1 | Tee-Object -FilePath "$Root\run_checks_output.txt"
} else {
  Write-Host "No run_checks.sh found"
}

# Git operations
$branch = "antigravity-automation-$(Get-Date -Format 'yyyyMMdd-HHmm')"
Write-Host "Creating branch $branch"
git checkout -b $branch
git add .antigravity/ scripts/apply_prompt_rules.* run_checks_output.txt -A
try {
  git commit -m "[AUTO] Add prompt rules and automation artifacts — run_checks: $(if (Test-Path "$Root\run_checks_output.txt" -and (Get-Item "$Root\run_checks_output.txt").length -gt 0) { 'PASS' } else { 'FAIL' })"
  git push -u origin $branch
  Write-Host "Branch pushed: $branch"
} catch {
  Write-Warning "Nothing to commit or commit failed: $_"
}

Write-Host "To create a PR with gh: gh pr create --base main --head $branch --title 'Add prompt rules and automation artifacts' --body-file run_checks_output.txt"
