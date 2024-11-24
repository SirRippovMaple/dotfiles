#!/usr/bin/env bash
sync_user_service() {
    if command -v "$1" &> /dev/null; then
        systemctl --user enable --now "$2.timer"
    else
        systemctl --user disable --now "$2.timer"
    fi
}

if [ "$CHEZMOI_OS" == "linux" ]; then
    sync_user_service getmail get_mail
    sync_user_service vdirsyncer vdirsyncer
    sync_user_service docker docker_prune
fi
