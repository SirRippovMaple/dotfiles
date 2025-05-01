#!/usr/bin/env bash
declare branch_name
declare base_branch
declare remote

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)
source "$script_dir/.common.sh"

usage() {
  cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") [-h] branch_name [base_branch]
🌿 Creates a new branch from the specified or default upstream branch.

Available options:
-h, --help      Print this help and exit

Arguments:
  branch_name   Name of the new branch to create
  base_branch   Optional: Name of the base branch to create from (default: default branch from upstream)
EOF
  exit
}

cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
  # script cleanup here
}

parse_params() {
  while :; do
    case "${1-}" in
    -h | --help) usage ;;
    -?*) die "${RED}🚫 Unknown option: $1${NOFORMAT}" ;;
    *) break ;;
    esac
    shift
  done

  args=("$@")

  # Validate number of arguments
  [[ ${#args[@]} -eq 0 ]] && die "${RED}❌ Missing branch name argument${NOFORMAT}"
  [[ ${#args[@]} -gt 2 ]] && die "${RED}❌ Too many arguments. Expected 1 or 2 arguments but got ${#args[@]}${NOFORMAT}"

  # Validate branch name
  [[ "${args[0]}" == "main" || "${args[0]}" == "master" || "${args[0]}" == "develop" ]] && \
    die "${RED}🔒 Cannot create protected branch '${args[0]}'. Please choose a different branch name.${NOFORMAT}"

  branch_name="${args[0]}"
  remote=$(get_upstream_remote)
  if [[ ${#args[@]} -eq 2 ]]; then
    base_branch="$remote/${args[1]}"
  fi
  return 0
}

create_branch() {
  msg "${BLUE}🔄 Fetching latest changes from $remote...${NOFORMAT}"
  git fetch "$remote"

  if [[ ! -z "${base_branch}" ]]; then
    base_branch="$(git branch -r | grep "  upstream/$branch_name" | xargs)"
  fi

  # Clean up old branches
  msg "${BLUE}🧹 Cleaning up stale branches...${NOFORMAT}"
  while IFS= read -r branch; do
    msg "${ORANGE}🗑️  Removing stale branch: $branch${NOFORMAT}"
    git branch -D "$branch"
  done < <(git branch -vv | grep ': gone]' | awk '{print $1}')

  # Create and configure new branch
  msg "${BLUE}🌱 Creating new branch '$branch_name' from '$base_branch'...${NOFORMAT}"
  if git checkout -b "$branch_name" "$base_branch" && \
     git config "branch.$branch_name.description" "$(jq -n --arg base "$base_branch" '{base: $base}')" && \
     git push -u origin "$branch_name" && \
     git lprune; then
    msg "${GREEN}🎉 Branch '$branch_name' created and configured successfully!${NOFORMAT}"
  else
    die "${RED}💥 Failed to create and configure branch '$branch_name'${NOFORMAT}"
  fi
}

parse_params "$@"

# Main script execution
create_branch
