#!/usr/bin/env bash
git fetch upstream
if [ $# -eq 1 ]; then
  main_branch="$(git branch -r | grep "  upstream/$1" | xargs)"
  if [ -z "${main_branch}" ]; then
    main_branch="upstream/$(git remote show upstream | sed -n '/HEAD branch/s/.*: //p')"
  fi
elif [ $# -eq 2 ]; then
  main_branch="upstream/$2"
else
  exit 1
fi

for branch in $(git branch -vv | grep ': gone]' | awk '{print $1}'); do
  git branch -D "$branch"
done
git checkout -b "$1" "$main_branch" && git push -u origin "$1"
git lprune
