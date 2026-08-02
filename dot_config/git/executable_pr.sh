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

gh_host=$(git remote get-url "$remote" | sed -n 's|.*@\([^:]*\):.*|\1|p')

branch_name=$(git symbolic-ref HEAD | cut -d"/" -f 3,4)
if [ "$remote" = "upstream" ]; then
  branch_name="trevor-green:$branch_name"
fi

gh_args=(--base "$base_branch" --head "$branch_name")

# Generate PR title and description using Claude
if command -v claude &>/dev/null; then
  msg "${BLUE}📝 Generating PR title and description with Claude...${NOFORMAT}"

  claude_output=$(claude -p "Run git log and git diff to understand the changes on this branch relative to $remote/$base_branch, then generate a pull request title and description.
Don't include a work item in the title (\`@W-XXXXXXX\`). This will be prepended manually.

Output EXACTLY in this format with no other text:
---TITLE---
<concise PR title, under 70 chars>
---BODY---
<markdown PR description with a short summary and bullet points of what changed>" --allowedTools "Bash(git log:*)" --allowedTools "Bash(git diff:*)" 2>/dev/null) || true

  if [[ -n "$claude_output" ]]; then
    pr_title=$(echo "$claude_output" | sed -n '/^---TITLE---$/,/^---BODY---$/{ /^---/d; p; }' | head -1)
    pr_body=$(echo "$claude_output" | sed -n '/^---BODY---$/,$ { /^---BODY---$/d; p; }')

    if [[ -n "$pr_title" && -n "${GIT_WORKFLOW_HOOKS_PATH-}" ]]; then
      hook="$GIT_WORKFLOW_HOOKS_PATH/pre-pr-title.sh"
      if [[ -x "$hook" ]]; then
        pr_title=$("$hook" "$pr_title")
      fi
    fi

    if [[ -n "$pr_title" ]]; then
      msg "${CYAN}📝 PR title:${NOFORMAT}"
      msg "$pr_title"
      msg ""
      msg "${CYAN}📝 PR description:${NOFORMAT}"
      msg "$pr_body"
      msg ""

      gh_args+=(--title "$pr_title" --body "$pr_body")
    else
      msg "${YELLOW}⚠️  Could not parse Claude output, creating PR without pre-filled fields.${NOFORMAT}"
    fi
  else
    msg "${YELLOW}⚠️  Claude returned no output, creating PR without pre-filled fields.${NOFORMAT}"
  fi
else
  msg "${YELLOW}⚠️  claude CLI not found, creating PR without pre-filled fields.${NOFORMAT}"
fi

msg "${GREEN}🚀 Creating pull request...${NOFORMAT}"
pr_url=$(GH_HOST="$gh_host" gh pr create "${gh_args[@]}")
msg "${GREEN}✅ $pr_url${NOFORMAT}"

if [[ -n "${GIT_WORKFLOW_HOOKS_PATH-}" ]]; then
  hook="$GIT_WORKFLOW_HOOKS_PATH/post-pr.sh"
  if [[ -x "$hook" ]]; then
    "$hook" "$pr_url"
  fi
fi
