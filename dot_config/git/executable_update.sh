#!/usr/bin/env bash
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)
source "$script_dir/.common.sh"

usage() {
  cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") [-h] [-v]
🔄 Update current branch by rebasing against the upstream base branch and force pushing.

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
remote=$(get_upstream_remote)
base_branch=$(get_base_branch)

msg "${BLUE}📥 Fetching from ${remote} and rebasing against ${base_branch}...${NOFORMAT}"
if git fetch "$remote" && git rebase "$remote/$base_branch"; then
    msg "${GREEN}⚡ Force pushing updated branch...${NOFORMAT}"
    git push -f
    msg "${GREEN}✨ Branch successfully updated!${NOFORMAT}"
else
    die "${RED}💥 Failed to update branch${NOFORMAT}"
fi
