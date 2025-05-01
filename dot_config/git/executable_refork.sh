#!/usr/bin/env bash
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)
source "$script_dir/.common.sh"

usage() {
  cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") [-h] [-v]
🔄 Reset a forked repository to match its upstream source.
🚨 This script will fetch from upstream, hard reset to match it, and force push the changes.

Available options:
-h, --help      Print this help and exit
-v, --verbose   Print script debug info
EOF
  exit
}

cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
  # No specific cleanup needed
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

if [ "$remote" != "upstream" ]; then
    die "${RED}❌ Error: There isn't a remote named 'upstream'. This probably isn't a fork.${NOFORMAT}"
fi

base_branch=$(get_base_branch)
msg "${BLUE}📥 Fetching from upstream...${NOFORMAT}"
if git fetch "$remote"; then
    msg "${YELLOW}⚠️  Performing hard reset to ${base_branch}...${NOFORMAT}"
    if git reset "$remote/$base_branch" --hard; then
        msg "${BLUE}⚡ Force pushing changes...${NOFORMAT}"
        if git push -f; then
            msg "${GREEN}✨ Fork successfully reset to match upstream!${NOFORMAT}"
        else
            die "${RED}💥 Failed to push changes${NOFORMAT}"
        fi
    else
        die "${RED}💥 Failed to reset to upstream branch${NOFORMAT}"
    fi
else
    die "${RED}💥 Failed to fetch from upstream${NOFORMAT}"
fi 