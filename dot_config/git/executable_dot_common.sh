set -e -o pipefail
trap cleanup SIGINT SIGTERM ERR EXIT
[ "$TRACE" ] && set -x  

memoized_main_branch=""
memoized_upstream_remote=""

get_upstream_remote() {
    if [ -z "$memoized_upstream_remote" ]; then
        if [ -d .git/refs/remotes/upstream ]; then
            memoized_upstream_remote="upstream"
        else
            memoized_upstream_remote="origin"
        fi
    fi
    echo "$memoized_upstream_remote"
}

get_base_branch() {
    if [ -z "$memoized_main_branch" ]; then
        memoized_main_branch=$(jq -r '.base' <(git config "branch.$(git branch --show-current).description"))
        if [ -z "$memoized_main_branch" ]; then
            remote=$(get_upstream_remote)
            memoized_main_branch=$(git remote show "$remote" | sed -n '/HEAD branch/s/.*: //p')
        fi
    fi
    echo "$memoized_main_branch"
}

setup_colors() {
  if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
    NOFORMAT='\033[0m' RED='\033[0;31m' GREEN='\033[0;32m' ORANGE='\033[0;33m' BLUE='\033[0;34m' PURPLE='\033[0;35m' CYAN='\033[0;36m' YELLOW='\033[1;33m'
  else
    NOFORMAT='' RED='' GREEN='' ORANGE='' BLUE='' PURPLE='' CYAN='' YELLOW=''
  fi
}

msg() {
  echo >&2 -e "${1-}"
}

die() {
  local msg=$1
  local code=${2-1} # default exit status 1
  msg "$msg"
  exit "$code"
}

# Initialize colors on source
setup_colors
