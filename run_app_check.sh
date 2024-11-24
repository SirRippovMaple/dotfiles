#!/usr/bin/env bash
checks=(marksman csharp-ls lua-language-server)
for check in "${checks[@]}"; do
    [[ -x $(command -v "$check") ]] || echo "$check is not installed"
done

# bash-language-server
# tsserver
# docker-langserver
# vscode-langservers-extracted
