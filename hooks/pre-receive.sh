#!/bin/bash
while read oldrev newrev refname; do
  changes=$(git diff --name-status "$oldrev" "$newrev")
  if [ -n "$changes" ]; then
    if echo "$changes" | grep -E "^[MD]" >/dev/null 2>&1; then
      echo "Push rejected: modifications or deletions are forbidden by repository policy."
      echo "$changes" | grep -E "^[MD]"
      exit 1
    fi
  fi
done
exit 0
