# Signed Prompt Verification — docs/SIGNED_PROMPT.md

Purpose
- Mô tả cách ký và kiểm tra prompt để agent có thể trust một prompt (signed prompts).
- This doc pairs with scripts/signed_prompt_verify.py which verifies RSA-PKCS1v15+SHA256 signatures.

How to create keys (RSA)
- Generate a 2048-bit RSA private key:
  - OpenSSL:
    ```
    openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out private.pem
    openssl rsa -in private.pem -pubout -out public.pem
    ```

How to sign a prompt (example)
1) Save the prompt text to `prompt.txt`.
2) Sign with your private key:
   ```
   openssl dgst -sha256 -sign private.pem -out prompt.sig prompt.txt
   base64 prompt.sig > prompt.sig.b64
   ```
3) Now `prompt.sig.b64` is the signature file (base64).

How to verify using the provided script
```
python3 scripts/signed_prompt_verify.py --pubkey public.pem --prompt prompt.txt --signature prompt.sig.b64
```
- Output `OK: signature verification succeeded` indicates the prompt is signed by the holder of the private key.

Integration notes (recommendations)
- Keep private keys secure (HSM or protected storage). Store public keys for verification in a trusted location (repo secrets or policy server).
- The wrapper (agent_wrapper.py) may be extended to require signed prompts for specific operations (set `require_signed_prompts: true` in policy.yaml).
- For more robust security, prefer Ed25519 signatures (shorter, simpler), but ensure consistent key serialization formats for both signing and verification.

Caveats
- This skeleton uses RSA PKCS1v15 + SHA256. If you want RSA-PSS or Ed25519 support, we can extend the script accordingly.