#!/usr/bin/env bash

CONFIG="$HOME/.config/aerospace/aerospace.toml"
MARKER="$HOME/.config/aerospace/.tv-mode"

if [ -f "$MARKER" ]; then
    sed -i '' \
        -e "s/^v = 'secondary'/v = 'Sidecar'/" \
        -e "s/^6 = 'main'/6 = 'secondary'/" \
        -e "s/^7 = 'main'/7 = 'secondary'/" \
        -e "s/^8 = 'main'/8 = 'secondary'/" \
        -e "s/^9 = 'main'/9 = 'secondary'/" \
        -e "s/^10 = 'main'/10 = 'secondary'/" \
        "$CONFIG"
    rm "$MARKER"
else
    sed -i '' \
        -e "s/^v = 'Sidecar'/v = 'secondary'/" \
        -e "s/^6 = 'secondary'/6 = 'main'/" \
        -e "s/^7 = 'secondary'/7 = 'main'/" \
        -e "s/^8 = 'secondary'/8 = 'main'/" \
        -e "s/^9 = 'secondary'/9 = 'main'/" \
        -e "s/^10 = 'secondary'/10 = 'main'/" \
        "$CONFIG"
    touch "$MARKER"
fi

aerospace reload-config
