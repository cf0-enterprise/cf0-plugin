#!/usr/bin/env bash
# Fails when the listing text names a price, trial or discount.
# Scope: skills/, README.md, plugin.json and .claude-plugin/plugin.json.
# The one allowed hit is plugin.json's commerce_description, and only for the words price or pricing.
# Before checking the repository, it proves itself on known-bad fixtures built in a temp folder.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PATTERN='[$€£][0-9]|(USD|EUR|GBP) ?[0-9]|pric(e|ing)|trial|discount'
STRICT='[$€£][0-9]|(USD|EUR|GBP) ?[0-9]|trial|discount'
LISTING='pays? per|per completed task|subscription|billing'
SCOPE=(skills README.md plugin.json .claude-plugin/plugin.json)

hits() {
  local manifest
  manifest="$(cd "$1" && jq 'del(.extensions["com.openai"].review.test_cases)' plugin.json)" || return 1
  (cd "$1" && grep -rEin "$PATTERN" skills README.md .claude-plugin/plugin.json || true
    printf '%s\n' "$manifest" | grep -Ein "$PATTERN" | sed 's/^/plugin.json:/' || true) | while IFS= read -r line; do
    if [[ "$line" =~ ^plugin\.json:[0-9]+:[[:space:]]*\"commerce_description\": ]] && ! grep -Eiq "$STRICT" <<<"$line"; then
      continue
    fi
    printf '%s\n' "$line"
  done
  (cd "$1" && grep -Ein '"(longDescription|shortDescription)":' plugin.json | grep -Ei "$LISTING" || true)
}

copy_scope() {
  mkdir -p "$2/.claude-plugin"
  cp -R "$1/skills" "$2/skills"
  cp "$1/README.md" "$1/plugin.json" "$2/"
  cp "$1/.claude-plugin/plugin.json" "$2/.claude-plugin/plugin.json"
}

inject() {
  local dir="$1" fixture="$2"
  case "$fixture" in
    skill-dollar) printf '\nEach task Zero completes costs $3.\n' >>"$dir/skills/zero-property-manager/SKILL.md" ;;
    readme-trial) printf '\nStart a free trial today.\n' >>"$dir/README.md" ;;
    manifest-price) sed -i.bak 's/"shortDescription": "[^"]*"/"shortDescription": "See the price per task"/' "$dir/plugin.json" ;;
    manifest-discount) sed -i.bak '1,/"description": "/s/"description": "/"description": "Save with a launch discount. /' "$dir/plugin.json" ;;
    commerce-dollar) sed -i.bak 's/"commerce_description": "/"commerce_description": "Tasks are $3 each. /' "$dir/plugin.json" ;;
    readme-euro) printf '\nZero costs €9 a month.\n' >>"$dir/README.md" ;;
    listing-pays) sed -i.bak 's/"longDescription": "/"longDescription": "Your firm pays per completed task. /' "$dir/plugin.json" ;;
    skill-usd) printf '\nTasks are billed at USD 3.\n' >>"$dir/skills/zero-property-manager/SKILL.md" ;;
    claude-manifest-price) sed -i.bak '1,/"description": "/s/"description": "/"description": "Fair pricing. /' "$dir/.claude-plugin/plugin.json" ;;
  esac
  rm -f "$dir/plugin.json.bak" "$dir/.claude-plugin/plugin.json.bak"
}

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

missed=0
for fixture in skill-dollar readme-trial manifest-price manifest-discount commerce-dollar claude-manifest-price readme-euro skill-usd listing-pays; do
  dir="$WORK/$fixture"
  copy_scope "$ROOT" "$dir"
  inject "$dir" "$fixture"
  found="$(hits "$dir")"
  if [[ -z "$found" ]]; then
    echo "FIXTURE NOT CAUGHT: $fixture"
    missed=1
  else
    echo "known-bad fixture $fixture: caught -> $(head -n 1 <<<"$found")"
  fi
done
if [[ "$missed" -ne 0 ]]; then
  echo "The price check missed a known-bad fixture; fix the check before trusting it."
  exit 2
fi

found="$(hits "$ROOT")"
if [[ -n "$found" ]]; then
  echo "Price, trial or discount wording in the listing text:"
  printf '%s\n' "$found"
  exit 1
fi
echo "No price, trial or discount wording in ${SCOPE[*]} (0 hits)."
