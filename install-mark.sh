#!/bin/bash

# Installs the Z.ai brand mark where the built-in agents panel resolves it
# (assets/<id>.svg inside the omarchy agents plugin). The directory is
# root-owned, so this needs sudo. Both variants ship: the panel picks
# zai.svg or zai-light.svg per surface luminance. refresh.sh re-runs the
# plain (non-sudo) install whenever the mark goes missing and the
# directory happens to be writable; this script is the guaranteed path.

set -euo pipefail

plugin_dir="$(dirname -- "$(readlink -f -- "${BASH_SOURCE[0]}")")"
assets_dir=/usr/share/omarchy/shell/plugins/agents/assets

[[ -d $assets_dir ]] || { echo "agents panel assets dir not found: $assets_dir" >&2; exit 1; }

install -m 644 "$plugin_dir/assets/zai.svg" "$assets_dir/zai.svg"
install -m 644 "$plugin_dir/assets/zai-light.svg" "$assets_dir/zai-light.svg"
echo "Installed the Z.ai panel mark in $assets_dir; reopen the agents panel to see it."
