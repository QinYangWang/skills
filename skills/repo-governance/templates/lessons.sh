#!/usr/bin/env bash
# Print the lessons that mention an area or symptom. Silent when there are none,
# so running it costs nothing. Exit 3 on a hit, 0 on a clean area.
#
#   scripts/lessons.sh cache
#   scripts/lessons.sh "restart, empty"
set -uo pipefail
cd "$(dirname "$0")/.."

term="${1:?usage: scripts/lessons.sh <area-or-symptom>}"
files="LESSONS.md docs/code-standards.md"

# Matching: tags lines, headings and rule text, case-insensitive.
pattern=$(printf '%s' "$term" | sed 's/,/|/g; s/ /\\s+/g')
hits=$(grep -inE -- "$pattern" $files 2>/dev/null || true)

if [ -z "$hits" ]; then
  exit 0
fi

printf 'Rules that mention "%s":\n\n' "$term"
printf '%s\n' "$hits"
exit 3