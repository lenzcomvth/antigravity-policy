#!/usr/bin/env python3
"""
scripts/signed_prompt_verify.py
Simple verifier for signed prompts using RSA (PKCS1 v1.5 + SHA256).
Usage:
  1) Sign a prompt (example using OpenSSL):
     openssl dgst -sha256 -sign private.pem -out prompt.sig prompt.txt
     base64 < prompt.sig > prompt.sig.b64

  2) Verify:
     python3 scripts/signed_prompt_verify.py --pubkey public.pem --prompt prompt.txt --signature prompt.sig.b64

Notes:
- This is a skeleton verifier for audit/trust. Extend to support Ed25519 or custom schemes if needed.
"""
import argparse
import base64
import sys
from pathlib import Path

try:
    from cryptography.hazmat.primitives import hashes, serialization
    from cryptography.hazmat.primitives.asymmetric import padding
    from cryptography.hazmat.backends import default_backend
except Exception as e:
    print("Missing dependency: cryptography. Install with: pip install cryptography", file=sys.stderr)
    sys.exit(2)

def load_public_key(path: Path):
    data = path.read_bytes()
    return serialization.load_pem_public_key(data, backend=default_backend())

def verify_rsa_sha256(pubkey, message: bytes, signature: bytes):
    try:
        pubkey.verify(
            signature,
            message,
            padding.PKCS1v15(),
            hashes.SHA256()
        )
        return True
    except Exception:
        return False

def main():
    p = argparse.ArgumentParser(description="Verify signed prompt")
    p.add_argument("--pubkey", required=True, help="Path to PEM public key (RSA PEM)")
    p.add_argument("--prompt", required=True, help="Path to prompt text file")
    p.add_argument("--signature", required=True, help="Path to base64-encoded signature file")
    args = p.parse_args()

    pubkey_path = Path(args.pubkey)
    prompt_path = Path(args.prompt)
    sig_path = Path(args.signature)

    if not pubkey_path.exists() or not prompt_path.exists() or not sig_path.exists():
        print("Error: one or more input files not found", file=sys.stderr)
        sys.exit(3)

    pubkey = load_public_key(pubkey_path)
    message = prompt_path.read_bytes()
    sig_b64 = sig_path.read_text().strip()
    try:
        signature = base64.b64decode(sig_b64)
    except Exception:
        print("Error: signature file is not valid base64", file=sys.stderr)
        sys.exit(4)

    ok = verify_rsa_sha256(pubkey, message, signature)
    if ok:
        print("OK: signature verification succeeded")
        sys.exit(0)
    else:
        print("FAIL: signature verification failed", file=sys.stderr)
        sys.exit(5)

if __name__ == "__main__":
    main()