<#
DẠ HÀNH STUDIO - PROJECT REBUILDER
File: scripts/send_selection_to_wrapper.ps1
Purpose: Read clipboard text and forward it to agent_wrapper.py, then print the wrapper output.

Usage:
  1) Copy the selection you want the agent to process (Ctrl+C)
  2) Run this script in repo root: pwsh .\scripts\send_selection_to_wrapper.ps1
#>

Set-StrictMode -Version Latest
$Root = (Get-Location).Path

$text = $null
try { $text = Get-Clipboard -TextFormatType Text -ErrorAction Stop } catch { }
if (-not $text -or $text.Trim().Length -eq 0) {
    Write-Host "Clipboard is empty. Select text in the editor and press Ctrl+C first."; exit 1
}

$wrapper = Join-Path $Root 'agent_wrapper.py'
if (-not (Test-Path $wrapper)) {
    Write-Host "agent_wrapper.py not found at $wrapper"; exit 1
}

Write-Host "Sending selection to agent_wrapper.py..."
$text | python $wrapper | Out-Host
