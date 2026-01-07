#!/usr/bin/env python3
"""
Minimal agent_wrapper.py — validate ACT AS prompts for UI_SPEC and FILES ALLOWED.
This is a safe stub; integrate with model API as needed.
"""
import sys, re
def main():
    prompt = sys.stdin.read() if not sys.stdin.isatty() else ""
    if not prompt.strip():
        print("ERROR: empty prompt", file=sys.stderr); sys.exit(2)
    if re.search(r"ACT AS:\s*Elite React Reverse-Engineering Architect", prompt, re.I):
        if "UI_SPEC" not in prompt:
            print("REJECTED: missing UI_SPEC", file=sys.stderr); sys.exit(4)
        if "FILES ALLOWED" not in prompt:
            print("REJECTED: missing FILES ALLOWED", file=sys.stderr); sys.exit(4)
    print("FORWARDED: prompt passed checks (stub).")
if __name__ == "__main__":
    main()
