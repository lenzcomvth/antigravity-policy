/**
 * DẠ HÀNH STUDIO - PROJECT REBUILDER
 * File: docs/QUICK_SUMMARY.md
 */

# Tóm tắt nhanh — mục đích & cách dùng (Tiếng Việt, ngắn gọn)

Mục đích:
- Đây là repo "policy bundle" để định nghĩa và thực thi luật cho agent/IDE (Antigravity): những prompt được phép, cấm thao tác file/shell, audit.

Tác dụng ngắn gọn:
- Ngăn agent/IDE chạy lệnh trái quy tắc. Mọi prompt có thể bị wrapper (`agent_wrapper.py`) kiểm tra trước khi thực hiện.
- Cung cấp file máy đọc `.antigravity/allowed_prompts.json` và hướng dẫn `.antigravity/prompt_rules.md`.
- Có scripts để áp luật, chạy kiểm tra, và helper để tạo branch/commit/push tự động.

Các file quan trọng (vị trí):
- `policy.yaml` — cấu hình chính của policy.
- `.antigravity/allowed_prompts.json` — policy dạng machine-readable.
- `.antigravity/prompt_rules.md` — giải thích ngắn, người đọc.
- `agent_wrapper.py` — wrapper kiểm soát prompt (bắt buộc phải dùng wrapper để thực thi an toàn).
- `scripts/apply_prompt_rules.*` — viết/đồng bộ `.antigravity/`.
- `scripts/run_checks.sh` — script kiểm tra (hiện là placeholder).
- `scripts/setup_full_config.ps1` / `do_everything_local.*` — helper tự động.

Làm gì ngay (copy/paste vào PowerShell từ thư mục repo):

1) Áp prompt rules (ghi `.antigravity/`):
```powershell
Set-Location -Path 'H:\AnhCoGiao\antigravity-policy-bundle'
pwsh .\scripts\apply_prompt_rules.ps1
```

2) Chạy kiểm tra và lưu output:
```powershell
bash ./scripts/run_checks.sh 2>&1 | tee run_checks_output.txt
```

3) Chạy toàn bộ tự động (xóa BOM nếu cần, run checks, tạo branch, commit, push):
```powershell
pwsh .\scripts\setup_full_config.ps1
# hoặc tạo PR tự động (yêu cầu gh CLI đã login)
pwsh .\scripts\setup_full_config.ps1 -CreatePR
```

Nếu muốn hủy/loại branch auto đã tạo (an toàn):
```powershell
# chuyển về main
git checkout main
# xóa local
git branch -D antigravity-automation-YYYYMMDD-HHMM
# xóa remote
git push origin --delete antigravity-automation-YYYYMMDD-HHMM
```

Ghi chú nhanh:
- `run_checks.sh` hiện là placeholder — CI trả OK nhưng không chạy linters/tests thực sự. Nếu cần build thật, tôi sẽ thêm `package.json`/lint/test phù hợp.
- Nếu muốn IDE buộc phải qua wrapper: cấu hình extension hoặc workflow gửi prompt tới `agent_wrapper.py` thay vì gọi model trực tiếp.
- Mọi thay đổi tôi thêm đều nằm trên branch `antigravity-automation-<timestamp>` — main không bị thay đổi.

Nếu bạn muốn tôi làm tiếp 1 việc cụ thể (xóa branch, tạo PR, hoặc triển khai checks thực tế), nói đúng một từ: `DeleteBranch` / `CreatePR` / `ImplementJSChecks` / `Stop`.
