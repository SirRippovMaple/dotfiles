#!/usr/bin/env bash
app="$1"
raw_message="$2"

title="$(jq -r .title <<< "$raw_message")"
actions_in="$(jq -c .actions[] <<< "$raw_message")"
actions=""
declare -A actions_map

while IFS= read -r line; do
    action_name="$(jq -r .action <<< "$line")"
    action_label="$(jq -r .label <<< "$line")"
    action_url="$(jq -r .url <<< "$line")"

    actions+="--action=$action_name,$action_label"
    actions_map[$action_name]="$action_url"
done <<< "$actions_in"

action_out="$(dunstify "$actions" "$title")"
if [[ -n "${actions_map[$action_out]}" ]]; then
    xdg-open "${actions_map[$action_out]}"
fi
