#!/usr/bin/env bash
set -euo pipefail

# Change this if your chezmoi source dir is different
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHEZMOI_SRC="${CHEZMOI_SRC:-$SCRIPT_DIR}"

# Where to store the list in your repo
EXT_LIST_FILE="${CHEZMOI_SRC}/windsurf_extensions.txt"

# CLI for Windsurf — adjust if your binary name/flags differ
WINDSURF_CLI="${WINDSURF_CLI:-windsurf}"

mkdir -p "$(dirname "${EXT_LIST_FILE}")"

echo "Querying installed Windsurf extensions..."
"${WINDSURF_CLI}" --list-extensions > "${EXT_LIST_FILE}"

echo "Updated ${EXT_LIST_FILE}"