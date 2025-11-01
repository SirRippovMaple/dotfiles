#!/usr/bin/env bash
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)
source "$script_dir/.common.sh"

usage() {
  cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") [-h] [-v]
🧹 Delete local branches that have been deleted from origin (marked as [gone]).

Available options:
-h, --help      Print this help and exit
-v, --verbose   Print script debug info
EOF
  exit
}

cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
}

parse_params() {
  while :; do
    case "${1-}" in
    -h | --help) usage ;;
    -v | --verbose) set -x ;;
    --no-color) NO_COLOR=1 ;;
    -?*) die "${RED}🚫 Unknown option: $1${NOFORMAT}" ;;
    *) break ;;
    esac
    shift
  done

  args=("$@")
  return 0
}

parse_params "$@"

# Script logic
msg "${BLUE}🔍 Fetching from origin and checking for gone branches...${NOFORMAT}"
git fetch origin
gone_branches=$(git branch -v | grep '\[gone\]' | grep -v '^+' | grep -v '^*' | awk '{print $1}' || true)

# Only try to delete if we found any gone branches
if [ -n "$gone_branches" ]; then
    msg "${GREEN}🗑️  Deleting gone branches:${NOFORMAT}"
    echo "$gone_branches" | xargs git branch -D
else
    msg "${YELLOW}✨ No gone branches found - workspace is clean${NOFORMAT}"
fi 
