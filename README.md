# Antigravity Policy — repository root README

Mục tiêu repository
- Tạo tập các file policy, hooks, wrapper và CI để:
  1) Buộc IDE/agent "Antigravity" chỉ hoạt động theo policy (allowlist prompt).
  2) NGĂT mọi thao tác sửa/xóa file dự án.
  3) Triển khai nhiều lớp phòng vệ (pre-commit, pre-receive, CI, container read-only, audit).

Sau khi chạy script này, bạn sẽ có:
- antigravity-policy-bundle/ (thư mục chứa toàn bộ file)
- antigravity-policy-bundle.zip (nén toàn bộ nội dung)
