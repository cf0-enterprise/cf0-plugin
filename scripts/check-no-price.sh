#!/usr/bin/env bash
# Fails when the listing text names a price, trial or discount.
# Scope: skills/, README.md, plugin.json and .claude-plugin/plugin.json.
# The one allowed hit is plugin.json's commerce_description, and only for the words price or pricing.
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
  (cd "$1" && jq -r '.description, .extensions["com.openai"].interface.shortDescription, .extensions["com.openai"].interface.longDescription' plugin.json
    jq -r '.description' .claude-plugin/plugin.json
    jq -r '.plugins[].description' .claude-plugin/marketplace.json) | grep -Ei "$LISTING" | sed 's/^/listing description: /' || true
}

found="$(hits "$ROOT")"
if [[ -n "$found" ]]; then
  echo "Price, trial or discount wording in the listing text:"
  printf '%s\n' "$found"
  exit 1
fi
echo "No price, trial or discount wording in ${SCOPE[*]} (0 hits)."
