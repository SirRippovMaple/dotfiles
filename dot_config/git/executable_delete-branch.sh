#!/usr/bin/env bash
script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)
source "$script_dir/.common.sh"

usage() {
  cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") [-h] [-f] [branch_name]
Delete both local and remote git branches safely.

If no branch name is provided, the current branch will be deleted.
The script will prevent deletion of protected branches (main, master, develop).

Available options:
-h, --help      Print this help and exit
-f, --force     Force delete the branch even if it hasn't been merged
EOF
  exit
}

cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
}

parse_params() {
  force=0
  branch=""

  while :; do
    case "${1-}" in
    -h | --help) usage ;;
    -f | --force) force=1 ;;
    -?*) die "Unknown option: $1" ;;
    *) break ;;
    esac
    shift
  done

  args=("$@")
  
  # If a branch name is provided, use it; otherwise use current branch
  if [[ ${#args[@]} -eq 1 ]]; then
    branch="${args[0]}"
  else
    branch=$(git branch --show-current)
  fi

  # Validate branch name
  if [[ -z "$branch" ]]; then
    die "❌ Failed to determine branch name"
  fi

  # Check if branch exists
  if ! git rev-parse --verify "$branch" >/dev/null 2>&1; then
    die "❌ Branch '$branch' does not exist"
  fi

  return 0
}

is_protected_branch() {
  local branch=$1
  local protected_branches=("master" "main" "develop" "$(get_base_branch)")
  
  for protected in "${protected_branches[@]}"; do
    if [[ "$branch" == "$protected" ]]; then
      return 0
    fi
  done
  return 1
}

delete_branch() {
  local branch=$1
  local force=$2
  local current_branch=$(git branch --show-current)
  local remote="origin"

  # Check if local or remote branch exists
  local has_local=false
  local has_remote=false

  # Check local branch
  if git rev-parse --verify "$branch" >/dev/null 2>&1; then
    has_local=true
  fi

  # Check remote branch
  if git ls-remote --exit-code "$remote" "refs/heads/$branch" >/dev/null 2>&1; then
    has_remote=true
  fi

  # Fail if neither branch exists
  if [[ "$has_local" == "false" ]] && [[ "$has_remote" == "false" ]]; then
    die "❌ Neither local nor remote branch '$branch' exists"
  fi

  # Check if it's a protected branch
  if is_protected_branch "$branch"; then
    die "❌ Cannot delete protected branch: $branch"
  fi

  # If we're on the branch to be deleted, switch to base branch
  if [[ "$current_branch" == "$branch" ]]; then
    local base_branch=$(get_base_branch)
    msg "${YELLOW}🔄 Switching from '$branch' to '$base_branch'${NOFORMAT}"
    git checkout "$base_branch" || die "❌ Failed to switch to $base_branch"
  fi

  # Delete local branch if it exists
  if [[ "$has_local" == "true" ]]; then
    local delete_flag="-d"
    if [[ "$force" -eq 1 ]]; then
      delete_flag="-D"
    fi
    
    msg "${YELLOW}🗑️  Deleting local branch '$branch'${NOFORMAT}"
    if ! git branch "$delete_flag" "$branch"; then
      die "❌ Failed to delete local branch. Use -f to force delete if branch is not fully merged."
    fi
  else
    msg "${CYAN}ℹ️  No local branch '$branch' found${NOFORMAT}"
  fi

  # Delete remote branch if it exists
  if [[ "$has_remote" == "true" ]]; then
    msg "${YELLOW}🌐 Deleting remote branch '$branch' from '$remote'${NOFORMAT}"
    if ! git push "$remote" --delete "$branch"; then
      die "❌ Failed to delete remote branch"
    fi
  else
    msg "${CYAN}ℹ️  No remote branch '$branch' found on '$remote'${NOFORMAT}"
  fi

  msg "${GREEN}✅ Successfully deleted branch '$branch'${NOFORMAT}"
}

parse_params "$@"
delete_branch "$branch" "$force" 