#!/usr/bin/env zsh
source "${ZDOTDIR:-~}/.antidote/antidote.zsh"
rm -rf $(antidote home)
rm "${ZDOTDIR:-~}/.zsh_plugins.zsh"
antidote update
