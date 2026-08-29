#!/bin/bash

# Lands the Z.ai usage record where the agents panel watches.
# Mirrors omarchy-agent-usage-update: run the collector, sanity-check the
# JSON, then swap the file into place atomically so the panel never reads a
# half-written record.

plugin_dir="$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")"
usage_dir="${XDG_STATE_HOME:-$HOME/.local/state}/omarchy/agents/usage"

record=$("$plugin_dir/omarchy-agent-usage-zai") || exit 1
if [[ -z $record ]] || ! jq -e . >/dev/null 2>&1 <<<"$record"; then
  echo "zai.agent-usage: collector emitted no valid JSON record" >&2
  exit 1
fi

mkdir -p "$usage_dir"
tmp=$(mktemp "$usage_dir/.zai.XXXXXX")
if ! printf '%s\n' "$record" >"$tmp"; then
  rm -f "$tmp"
  exit 1
fi
mv "$tmp" "$usage_dir/zai.json"
