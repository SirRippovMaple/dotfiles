#!/usr/bin/env bash
if [ ! -f ~/.ssh/id_ed25519 ]; then
    bw get item id_ed25519 | jq -r .notes > ~/.ssh/id_ed25519
fi
chmod 600 ~/.ssh/id_ed25519
