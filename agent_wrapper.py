#!/usr/bin/env python3
"""
Minimal strict wrapper for prompts (checks for UI_SPEC and FILES ALLOWED in ACT AS prompts).
This is a safe stub; replace forwarding logic with your model API call.
"""
import sys, re, json
from pathlib import Path

def main():
    prompt = sys.stdin.read() if not sys.stdin.isatty() else ""
    if not prompt.strip():
        print("ERROR: empty prompt", file=sys.stderr); sys.exit(2)
    if re.search(r"ACT AS:\s*Elite React Reverse-Engineering Architect", prompt, re.I):
        if "UI_SPEC" not in prompt:
            print("REJECTED: missing UI_SPEC", file=sys.stderr); sys.exit(4)
        if "FILES ALLOWED" not in prompt:
            print("REJECTED: missing FILES ALLOWED", file=sys.stderr); sys.exit(4)
        if "TASK" not in prompt.upper():
            print("REJECTED: missing TASK section", file=sys.stderr); sys.exit(4)
    print("FORWARDED: prompt passed basic checks (stub).")
    sys.exit(0)

if __name__ == "__main__":
    main()
