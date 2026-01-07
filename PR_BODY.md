# Pull Request: Add Antigravity policy bundle

Summary
- Thêm toàn bộ bundle policy/CI/wrapper/templates cho "Antigravity" agent.
- Nội dung chính: policy.yaml, ACT_AS_RULES.md, agent_wrapper.py, .antigravity/config.json, CI workflows, templates (ApiKeyService, useApiKey, DonateModal), scripts và docs.

Why
- Thiết lập nguyên tắc nghiêm ngặt cho agent và developer: bắt buộc UI_SPEC cho mọi thay đổi UI, bắt buộc Studio Header trong file code do agent sinh, chặn sửa/xóa file không rõ ràng, cung cấp kiểm tra tự động.

Files added
- (List of top-level added files)
  - PROJECT_ORGANIZATION_RULES.md
  - ACT_AS_RULES.md
  - policy.yaml
  - agent_wrapper.py
  - .antigravity/config.json
  - .github/workflows/* (pr-guard, ci-strict, header-check)
  - scripts/run_checks.sh, scripts/install-hooks.sh, scripts/signed_prompt_verify.py
  - src/services/ApiKeyService.js, src/hooks/useApiKey.js, src/components/DonateModal/**

Auto-verify (Required before merging)
1) Run local checks and paste outputs here:
   - Run: `./scripts/run_checks.sh` (on WSL / Git Bash)  
   - If on Windows PowerShell, run: `bash ./scripts/run_checks.sh` (or run via WSL)

   Paste run_checks output here (copy-paste): 
   ```
   [PASTE run_checks.sh OUTPUT HERE]
   ```

2) Wrapper check (basic)
   - Command:
     ```
     printf "ACT AS: Elite React Reverse-Engineering Architect\nTASK: verify\n" | python3 agent_wrapper.py
     ```
   - Expected: REJECTED due to missing UI_SPEC and FILES ALLOWED. Attach the wrapper output below:
     ```
     [PASTE wrapper output here]
     ```

PR checklist (maintainer must validate)
- [ ] No secrets committed (run secret scan).
- [ ] .git folder from bundle removed if existed (do not keep embeded .git).
- [ ] CODEOWNERS assigned and required reviewer(s) listed.
- [ ] CI workflows triggered and passed: pr-guard, ci-strict, header-check.
- [ ] Studio Header present in any generated source file introduced by this PR (if any).
- [ ] UI changes (if present) include UI_SPEC_*.md file(s) and acceptance tests.
- [ ] Agent-generated changes include run_checks.sh output in PR body or artifact link.
- [ ] Branch protection & required status checks configured prior to merge.

Notes for reviewers
- If the PR contains UI changes, check UI_SPEC referenced in PR body and ensure `FILES ALLOWED` matches the files changed.
- Revoke any tokens you find unexpectedly before merging.
- If header-check CI fails, require author to add Studio Header to the top of missing files.

Signed-off-by: lenzcomvth (author placeholder)