#!/usr/bin/env zsh
rm "${ZDOTDIR:-~}/.zsh_plugins.zsh"
source "${ZDOTDIR:-~}/.antidote/antidote.zsh"
antidote update
