# Tổng hợp & Hướng dẫn sử dụng — Antigravity Policy Bundle

Phiên bản: 2026-01-07  
Mục đích: Tài liệu này mô tả đầy đủ nội dung bundle "antigravity-policy-bundle" — giải thích chức năng của từng file/thư mục, cách chạy các script chính, kiểm tra an toàn và các bước tiếp theo để đưa lên GitHub.

--------------------------------------------------------------------------------
1) Tổng quan cấu trúc (vị trí tương đối trong bundle)
--------------------------------------------------------------------------------
antigravity-policy-bundle/
├── .antigravity/
│   └── config.json                # Cấu hình runtime cho agent
├── .git                           # (nếu có - thường xóa trước khi đẩy)
├── .github/
│   ├── CODEOWNERS
│   └── workflows/
│       └── pr-guard.yml           # Workflow chặn PR sửa/xóa file (PR)
├── ACT_AS_RULES.md                # Quy tắc "ACT AS" (Studio rules)
├── LICENSE
├── PROJECT_ORGANIZATION_RULES.md  # Quy tắc tổ chức dự án
├── README.md
├── UI_GUIDELINES.md
├── UI_SPEC_TEMPLATE.md
├── agent_wrapper.py               # Wrapper bắt buộc cho agent -> kiểm tra prompt
├── hooks/
│   └── pre-receive.sh             # Server-side hook mẫu cho bare repo
├── policy.yaml                    # Policy allowlist/deny (agent + wrapper)
├── scripts/
│   ├── run_checks.sh              # Chạy kiểm tra tự động (linters/tests) — placeholder
│   ├── install-hooks.sh
│   └── signed_prompt_verify.py    # Skeleton: verify signed prompts (RSA + SHA256)
├── src/
│   ├── services/
│   │   └── ApiKeyService.js       # Lấy/ghi API key (localStorage -> env)
│   ├── hooks/
│   │   └── useApiKey.js           # React hook hiển thị badge trạng thái key
│   └── components/
│       └── DonateModal/
│           ├── DonateModal.jsx
│           └── DonateModal.styles.css
├── UI_SPEC_payment_modal.md       # Ví dụ UI_SPEC cho PaymentModal
├── PR_BODY.md                      # Mẫu body PR (dùng khi mở PR)
├── .github/workflows/header-check.yml  # Workflow kiểm tra Studio Header (nếu đã thêm)
└── antigravity-policy-bundle.zip  # (nếu bạn đã tạo)

--------------------------------------------------------------------------------
2) Giải thích chi tiết từng file / chức năng quan trọng
--------------------------------------------------------------------------------

- .antigravity/config.json
  - Chứa cấu hình runtime cho agent/IDE: pattern prompt được phép, bật/tắt từ chối thao tác file, đường dẫn audit log, v.v.
  - Agent/wrapper phải đọc file này trước khi quyết định forward prompt.

- policy.yaml
  - Policy human-editable (YAML): allowlist cho prompt, các flag deny file ops, deny shell exec.
  - Thay đổi file này phải đi qua PR + codeowner review.

- ACT_AS_RULES.md
  - Bộ luật bắt buộc cho "ACT AS: Elite React Reverse-Engineering Architect & Code Enforcer (Dạ Hành Studio Edition)".
  - Định nghĩa: preconditions (UI_SPEC, FILES ALLOWED), Studio Header, branding, ApiKey policy, verify traceability.

- agent_wrapper.py
  - Điểm entry duy nhất (khuyến nghị) để forward prompt tới mô hình.
  - Kiểm tra: chứa UI_SPEC, FILES ALLOWED trong prompt cho những tác vụ "ACT AS"; kiểm tra code-block có Studio Header; từ chối prompt có token thao tác file/shell.
  - Hiện là stub — cần kết nối với API thực để forward.

- scripts/signed_prompt_verify.py
  - Skeleton script verify chữ ký prompt (RSA PKCS#1 v1.5 + SHA256).
  - Dùng để kiểm tra prompt được ký bởi private key đáng tin.
  - Docs: docs/SIGNED_PROMPT.md (mô tả cách tạo key/sign/verify).

- .git/hooks/pre-commit (có trong bundle .git/hooks)
  - Hook local ngăn commit sửa (M) hoặc xóa (D) file theo policy. (Chạy bằng scripts/install-hooks.sh để cài trên máy dev).

- hooks/pre-receive.sh
  - Hook server-side (bare repo) để chặn push có modification/delete theo policy.

- .github/workflows/pr-guard.yml
  - CI job chạy trên PR để fail PR nếu có MODIFY/DELETE file.

- .github/workflows/header-check.yml
  - CI job (nếu đã thêm) kiểm tra tất cả file code thay đổi trong PR có chứa Studio Header ở đầu file. Nếu thiếu sẽ fail PR.

- scripts/run_checks.sh
  - Script tổng hợp chạy formatter/linter/typechecker/tests/jscpd (duplication). Hiện là placeholder/khung; bạn có thể bổ sung lệnh cài dependencies phù hợp vào CI.
  - Dùng để agent "auto-verify" output trước khi mở PR.

- src/services/ApiKeyService.js
  - Logic lấy API key: kiểm tra localStorage ("USER_API_KEY") trước; nếu không có fallback sang env var (import.meta.env.VITE_API_KEY or process.env.VITE_API_KEY).
  - Hàm: getApiKey(), setApiKey(), removeApiKey().

- src/hooks/useApiKey.js
  - Hook React trả badgeText: "🟢 Using Personal Key (Storage)" or "🔵 Using System Key (Env)" or "🔴 No API Key".
  - Cung cấp set/clear API key.

- src/components/DonateModal/*
  - Modal đóng góp (Donate) theo branding Dạ Hành: chứa QR (image URL đã cung cấp), nội dung cần hiển thị.
  - Styles đã tối ưu cho dark theme "Neon Cyber".

- UI_SPEC_payment_modal.md
  - Mẫu UI_SPEC bắt buộc khi agent/dev làm UI: mockups, acceptance criteria, file list chính xác (FILES ALLOWED), test commands.

- PR_BODY.md
  - Mẫu body PR để copy/paste khi bạn mở PR. Yêu cầu paste outputs của ./scripts/run_checks.sh và wrapper output khi agent chạy.

--------------------------------------------------------------------------------
3) Quy tắc quan trọng / Checklist an toàn (trước khi push/merge)
--------------------------------------------------------------------------------
- Xóa thư mục .git nội bộ (nếu bundle có chứa .git) trước khi push lên remote:
  - PowerShell: `Remove-Item -Recurse -Force .git`
  - Bash: `rm -rf .git`
- Quét secrets: tìm token/secret trông giống PAT/private key:
  - PowerShell:  
    `Select-String -Path * -Pattern "TOKEN|PASSWORD|PRIVATE_KEY|SECRET|ghp_|GITHUB_TOKEN" -SimpleMatch -List | Select Path,LineNumber`
- Yêu cầu PR:
  - Mọi thay đổi UI phải kèm UI_SPEC file trong PR.
  - Mọi file agent-generated phải bắt đầu bằng Studio Header (ACT_AS_RULES.md quy định).
  - Agent phải chạy ./scripts/run_checks.sh và dán output vào PR body.
- Nếu bạn từng public PAT trong chat/commit trước: revoke token ngay (GitHub → Settings → Developer settings → Personal access tokens).

--------------------------------------------------------------------------------
4) Các lệnh cơ bản (Windows PowerShell + Git Bash / WSL)
--------------------------------------------------------------------------------

A) Kiểm tra nội dung bundle
PowerShell:
```powershell
cd "H:\AnhCoGiao\antigravity-policy-bundle"
Get-ChildItem -Recurse | Select-Object FullName,Length | Out-Host
```

B) Tạo repo local + tạo branch + push (HTTPS)
```bash
# nếu chưa init
git init
git checkout -b antigravity-policy
git add .
git commit -m "Add antigravity policy bundle"
# đổi remote sang HTTPS (nếu cần)
git remote set-url origin https://github.com/lenzcomvth/antigravity-policy.git
git push -u origin antigravity-policy
```
(Gợi ý: nếu chưa tạo repo trên GitHub, tạo trước qua web hoặc dùng `gh repo create`).

C) Cài pre-commit hooks (trên máy dev)
Git Bash / WSL:
```bash
chmod +x .git/hooks/pre-commit scripts/*.sh
./scripts/install-hooks.sh
```

D) Chạy wrapper (kiểm tra prompt)
```bash
# kiểm tra prompt missing UI_SPEC (mong nhận REJECTED)
printf "ACT AS: Elite React Reverse-Engineering Architect\nTASK: test\n" | python3 agent_wrapper.py
```

E) Chạy run_checks (kịch bản CI)
- Trên WSL/Git Bash:
```bash
chmod +x scripts/run_checks.sh
./scripts/run_checks.sh
```
- Trên Windows PowerShell (nếu script bash): chạy trong WSL hoặc Git Bash:
```powershell
bash ./scripts/run_checks.sh
```

F) Chạy signed-prompt verifier (skeleton)
- Tạo cặp key (OpenSSL), sign prompt, verify:
```bash
# tạo key
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out private.pem
openssl rsa -in private.pem -pubout -out public.pem

# sign
openssl dgst -sha256 -sign private.pem -out prompt.sig prompt.txt
base64 prompt.sig > prompt.sig.b64

# verify using script
python3 scripts/signed_prompt_verify.py --pubkey public.pem --prompt prompt.txt --signature prompt.sig.b64
```

--------------------------------------------------------------------------------
5) Mẫu hành động cho bạn (gợi ý thứ tự thực hiện)
--------------------------------------------------------------------------------
1. Kiểm tra bundle, xóa .git nếu tồn tại.  
2. Chạy `./scripts/run_checks.sh` (trong WSL/Git Bash) — dán output vào PR_BODY.md (mục Auto-verify).  
3. Commit & push branch `antigravity-policy`. (Bạn đã push thành công.)  
4. Mở PR từ branch `antigravity-policy` -> `main` (trong GitHub). Dán PR_BODY.md nội dung + paste outputs.  
5. Bật branch protection và yêu cầu CI checks.  
6. Chờ CI pass (pr-guard, ci-strict, header-check). Nếu header-check fail, chỉnh file theo yêu cầu (thêm Studio Header).

--------------------------------------------------------------------------------
6) Mẹo tóm tắt cho người mới
--------------------------------------------------------------------------------
- UI_SPEC là file yêu cầu: trước khi agent mào mỏ tạo UI code, phải có UI_SPEC nêu rõ file nào được phép thay đổi. Nếu bạn mở PR mà thay đổi UI nhưng không có UI_SPEC, CI sẽ fail.  
- Studio Header: tất cả file mà agent tạo phải có header cố định để CI kiểm tra. Nếu thiếu header, CI fail.  
- Không bao giờ dán PAT / private key trong chat hoặc trong commit — nếu lỡ, revoke ngay.

--------------------------------------------------------------------------------
7) Nếu bạn muốn mình tiếp tục làm (mình sẽ dán lệnh, file, hoặc commit hướng dẫn)
--------------------------------------------------------------------------------
- Mình có thể:  
  - Soạn PR_BODY.md hoàn chỉnh với chỗ bạn chỉ cần paste outputs (mình đã chuẩn bị file PR_BODY.md trong bundle).  
  - Tạo header-check workflow (nếu chưa có, mình đã dán nội dung).  
  - Viết thêm ví dụ component code của PaymentModal (component + styles + tests).  
  - Viết tài liệu ngắn cho admin: cách bật Branch Protection, cách review visual diff.  

Hãy trả lời bằng 1-2 câu ngắn: bạn muốn mình (1) Tạo thêm PaymentModal example, (2) Thêm header-check workflow vào branch (mình chỉ dán lệnh git commands để bạn commit/push), (3) Hướng dẫn từng bước mở PR và kiểm tra CI (mình trình bày chi tiết từng click), hoặc (4) Hoàn tất — không cần thêm gì.

--------------------------------------------------------------------------------
Cảm ơn — mình đã soạn tài liệu này để bạn không cần nhớ nhiều lệnh. Nếu muốn, mình có thể:
- xuất file Markdown này ra console để bạn copy/paste, hoặc
- soạn PR description mẫu đã điền sẵn (một click copy), hoặc
- hướng dẫn bạn qua màn hình từng lệnh (1-by-1).
```