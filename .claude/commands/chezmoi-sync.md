---
description: "Sync home directory edits into the chezmoi source repo with grouped commits"
---

You MUST use plan mode for this command. Call EnterPlanMode before doing anything else.

## Workflow

### Step 1: Gather the diff

First, resolve the 1Password account UUID and set it for all subsequent chezmoi commands:

```bash
export OP_ACCOUNT=$(op account list --format json | jq -r '.[] | select(.url == "my.1password.com") | .account_uuid')
```

All `chezmoi` commands in this workflow must be run with `OP_ACCOUNT` set (either via the export above or inline as `OP_ACCOUNT=<value> chezmoi ...`).

Then run `chezmoi diff` to get the current differences. If the output is empty, tell the user everything is in sync and stop.

The diff format shows:
- `--- a/` = current state on disk (the TARGET, which is the user's desired truth)
- `+++ b/` = what chezmoi source would write (the SOURCE state)

Our goal is to update the SOURCE to match the TARGET (disk). This means applying the REVERSE of each hunk: the `-` lines are what we want the source to produce; the `+` lines are what we're replacing in the source.

### Step 2: Analyze and categorize

For each changed file in the diff:

1. **Identify the chezmoi source file** — map the target path to its source equivalent (e.g. `~/.config/foo/bar` → `dot_config/foo/bar`, with prefixes like `executable_`, `private_`, `.tmpl` etc.)
2. **Check for secrets** — scan for tokens, API keys, passwords, credentials. Flag these to the user and do NOT include them in commits.
3. **Determine change type:**
   - **Disk edit** — the user edited the file on disk and wants to capture it in source
   - **Source-ahead** — the source has an intentional change not yet applied to disk (e.g. from a recent commit)
   - **New file** — exists on disk but not tracked by chezmoi
   - **Deleted file** — chezmoi would create a file that shouldn't exist on disk

### Step 3: Present the plan

Group related changes into logical commits. For each proposed commit, show:
- Commit message
- Files affected
- Summary of what changes

Flag any ambiguous items (could be either disk-edit or source-ahead) and use `AskUserQuestion` to confirm with the user.

### Step 4: Execute (after plan approval)

For each commit group:
1. Edit the chezmoi source files to match the disk state
2. Stage the relevant files with `git add`
3. Create the commit

### Step 5: Verify

Run `chezmoi diff` again. Report what remains (should only be intentional source-ahead changes or template-related differences).

## Important notes

- For `.tmpl` files, you must understand the template syntax — edits need to preserve template directives while updating the static content
- Trailing whitespace differences are cosmetic — don't create commits just for trailing spaces
- Directory mode changes (e.g. `40751` → `40755`) are typically cosmetic and can be skipped
- If `chezmoi diff` still errors on 1Password templates despite OP_ACCOUNT being set, ignore those errors and work with the diff output that was produced
