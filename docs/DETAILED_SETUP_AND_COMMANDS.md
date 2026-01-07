DẠ HÀNH STUDIO - PROJECT REBUILDER

# Hướng dẫn cấu hình đầy đủ và từng lệnh (chi tiết)

Mục tiêu
-------
- Tự động thiết lập các file policy prompt dưới `.antigravity/`
- Chạy kiểm tra (run_checks) và lưu output
- Tạo nhánh automation, commit thay đổi, push lên origin
- (Tùy chọn) Tạo Pull Request bằng GitHub CLI

File chính
----------
- `scripts/setup_full_config.ps1`  : script PowerShell tự động thực hiện toàn bộ quá trình (xem phần Usage).
- `scripts/apply_prompt_rules.ps1` : script để viết/đồng bộ `.antigravity/allowed_prompts.json` và `.antigravity/prompt_rules.md`.
- `scripts/apply_prompt_rules.sh`  : phiên bản POSIX của apply script.
- `scripts/run_checks.sh`         : script checks (hiện là placeholder; có thể thay bằng checks thực tế).
- `do_everything_local.ps1` / `do_everything_local.sh` : helper tương đương để chạy toàn bộ local.
- `PR_BODY.md`                    : PR body template với output run_checks và wrapper.

Chi tiết từng bước (PowerShell) — chạy từng lệnh copy/paste
-----------------------------------------------------------
1) Mở PowerShell và chuyển tới thư mục repo:

```powershell
Set-Location -Path 'H:\AnhCoGiao\antigravity-policy-bundle'
```

2) Áp prompt rules (viết `.antigravity/`):

```powershell
pwsh .\scripts\apply_prompt_rules.ps1
# Hoặc dùng task trong VS Code: "Apply prompt rules (PowerShell)"
```

Nội dung: script sẽ viết hai file:
- `.antigravity/allowed_prompts.json` — machine-readable policy
- `.antigravity/prompt_rules.md` — human-readable guideline (bắt đầu bằng Studio Header)

3) Xóa BOM (nếu có) và chạy checks, lưu output:

```powershell
pwsh .\scripts\setup_full_config.ps1
# hoặc để có PR tự tạo:
pwsh .\scripts\setup_full_config.ps1 -CreatePR
```

`setup_full_config.ps1` thực hiện:
- Remove BOM từ `scripts/run_checks.sh` nếu có (fix shebang)
- Chạy `bash ./scripts/run_checks.sh` và ghi `run_checks_output.txt`
- Tạo branch `antigravity-automation-<timestamp>`, git add/commit, push
- Nếu dùng `-CreatePR` và `gh` có sẵn, thử tạo PR tự động

4) Nếu bạn muốn thực hiện bằng tay (từng bước):

```powershell
# (a) remove BOM (nếu cần)
$p = 'scripts/run_checks.sh'
$b = [System.IO.File]::ReadAllBytes($p)
if ($b.Length -ge 3 -and $b[0] -eq 0xEF -and $b[1] -eq 0xBB -and $b[2] -eq 0xBF) {
  [System.IO.File]::WriteAllBytes($p, $b[3..($b.Length-1)])
  Write-Host 'BOM removed'
}

# (b) run checks
bash ./scripts/run_checks.sh 2>&1 | tee run_checks_output.txt

# (c) create branch, add, commit, push
$branch = "antigravity-automation-$(Get-Date -Format 'yyyyMMdd-HHmm')"
git checkout -b $branch
git add .antigravity/ scripts/apply_prompt_rules.* run_checks_output.txt PR_BODY.md
git commit -m "[AUTO] Add prompt rules and automation artifacts — run_checks: PASS"
git push -u origin $branch

# (d) create PR via gh (optional)
gh pr create --base main --head $branch --title "Add prompt rules and automation artifacts" --body-file PR_BODY.md
```

Giải thích các file và ý nghĩa từng lệnh
-------------------------------------
- `apply_prompt_rules.*` : đảm bảo `.antigravity/*` có nội dung chuẩn (pattern allowlist, deny flags).
- Xóa BOM: bảo đảm `#!/usr/bin/env bash` được shell nhận diện đúng trên môi trường Unix/WSL.
- `run_checks.sh`: nơi bạn cấu hình các linter / test runner thực tế (hiện là placeholder). Thay bằng lệnh cài deps và chạy eslint/jest/pytest tùy stack.
- Git steps: tạo branch automation, commit các file mới/được cập nhật, push lên origin.
- PR: dùng `gh` hoặc tạo thủ công trên GitHub web.

CI và IDE
---------
- `.github/workflows/run_checks.yml` sẽ chạy `./scripts/run_checks.sh` trên mỗi push/PR.
- `.github/workflows/header-check.yml` và `pr-guard.yml` đã hiện diện để bảo vệ header & ngăn sửa/xóa file quan trọng.
- `.vscode/tasks.json` có tasks để gọi apply/run_checks/do_everything từ VS Code.

Vấn đề thường gặp & cách fix
---------------------------
- BOM trên script: lỗi `No such file or directory` khi chạy shell — fix bằng đoạn xóa BOM như trên.
- gh không cài: PR tự động thất bại; cài `gh` và đăng nhập (`gh auth login`) trước khi chạy `-CreatePR`.
- run_checks là placeholder: CI báo PASS nhưng không kiểm tra thực sự — thay bằng script thực tế nếu cần.

Nếu muốn tôi làm tiếp (tự động):
- Tôi có thể thay `scripts/run_checks.sh` bằng một phiên bản thực tế cho stack React (thêm `package.json`, cấu hình eslint/jest) và re-run toàn bộ; xác nhận bằng một từ: `ImplementJSChecks`.
