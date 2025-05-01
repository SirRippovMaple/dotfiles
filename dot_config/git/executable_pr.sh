#!/usr/bin/env bash
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)
source "$script_dir/.common.sh"

usage() {
  cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") [-h] [-v]
🔗 Open a GitHub pull request URL for the current branch in your default browser.

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

msg "${BLUE}🔍 Generating pull request URL...${NOFORMAT}"

# Get the GitHub URL from remote, converting SSH format to HTTPS
github_url=$(git remote -v | awk "/^${remote}.*\\(fetch\\)$/{print \$2}" | 
  sed -E 's#(git@|git://)#https://#' |
  sed -E 's#github.com-[^:]+#github.com#' |
  sed -E 's#com:#com/#' |
  sed -E 's#\.git$##')

branch_name=$(git symbolic-ref HEAD | cut -d"/" -f 3,4)
if [ "$remote" = "upstream" ]; then
  branch_name="trevor-green:$branch_name"
fi

pr_url=$github_url"/compare/$base_branch..."$branch_name
msg "${GREEN}🚀 Opening pull request URL in browser...${NOFORMAT}"
open "$pr_url"
