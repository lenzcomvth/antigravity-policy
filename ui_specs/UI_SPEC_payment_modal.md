# UI_SPEC_PAYMENT_MODAL.md
Title: Payment Modal — Dạ Hành Studio Example
Component / Screen: src/components/PaymentModal/PaymentModal.jsx
Author: Designer / Developer
Date: 2026-01-07
Related issue: #NNN

Overview
- Purpose: Modal that allows users to complete a payment via QR or credit card entry.
- Location: Global header → "Donate" or Payment feature flows.

Mockups / Assets
- Figma link: (insert Figma link here)
- Assets:
  - /design/assets/qr_payment.png
  - /design/tokens.json (colors, spacing, typography)

User Stories & Acceptance Criteria
- Story 1: As a user, I want to open the Payment Modal and see a QR code and a short message so I can donate quickly.
  - Acceptance:
    - Given the app is open, when I click the Donate button, then PaymentModal appears with title "Dạ Hành Studio - Donate".
    - Visual snapshot must match `stories/PaymentModal/Default` story baseline.
    - Keyboard: ESC closes modal. Focus trapped inside modal while open.
    - ARIA: Modal has role="dialog" and aria-modal="true".

Testing commands (example)
- Unit test:
  - `npm run test -- -t "PaymentModal renders QR and message"`
- Storybook visual:
  - Start storybook: `npm run storybook`
  - Snapshot: use Playwright script to capture story `/iframe.html?id=paymentmodal--default` and compare with baseline.
- Run checks:
  - `./scripts/run_checks.sh` (should pass globally)

Data model / Props / API contract
- Props:
  - isOpen: boolean (required)
  - onClose: function (required)
  - amountSuggested: number (optional)
- No backend API required for static QR donate; if payment intent is server-driven include:
  - POST /api/payments/create-intent { amount } -> { clientSecret }

Accessibility requirements
- Modal header has id and the modal container uses `aria-labelledby` referencing it.
- All interactive controls keyboard accessible and screen-reader friendly.
- Color contrast must use tokens (no hard-coded colors).

Edge cases & Error states
- If QR image fails to load, show fallback message and alternate payment instructions.
- If network fails on dynamic payment intent, show inline error and retry button.

Visual design tokens used
- Colors:
  - --token-primary: var(--neon-purple) (#8A2BE2)
  - --token-bg: var(--obsidian) (#0d0a13)
- Spacing: use tokens (spacing-sm, spacing-md)
- Typography: use tokens from /design/tokens.json

Testing & Verification
- Unit tests:
  - tests/payment_modal.test.jsx
- Storybook:
  - stories/PaymentModal/PaymentModal.stories.jsx -> `Default` story
- E2E:
  - cypress/integration/payment_modal.spec.ts -> check open, close, fallback behavior

Proposed files to change/create (paths) — EXACT paths listed (agent MUST NOT change files outside this list)
- src/components/PaymentModal/PaymentModal.jsx
- src/components/PaymentModal/PaymentModal.styles.css
- src/components/PaymentModal/README.md
- src/components/PaymentModal/__tests__/payment_modal.test.jsx
- stories/PaymentModal/PaymentModal.stories.jsx
- design/assets/qr_payment.png

Sign-off
- Designer: @designer-name
- Developer: @developer-name
- QA: @qa-name