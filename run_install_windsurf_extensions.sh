#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHEZMOI_SRC="${CHEZMOI_SOURCE_DIR:-$SCRIPT_DIR}"
EXT_LIST_FILE="${CHEZMOI_SRC}/windsurf_extensions.txt"
WINDSURF_CLI="${WINDSURF_CLI:-windsurf}"

if [[ ! -f "${EXT_LIST_FILE}" ]]; then
  echo "Extension list not found: ${EXT_LIST_FILE}" >&2
  exit 1
fi

while IFS= read -r ext; do
  [[ -z "$ext" || "$ext" =~ ^# ]] && continue
  echo "Installing $ext..."
  "${WINDSURF_CLI}" --install-extension "$ext"
done < "${EXT_LIST_FILE}"
