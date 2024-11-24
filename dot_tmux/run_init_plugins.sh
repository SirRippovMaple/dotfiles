#!/bin/sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm 2> /dev/null || git -C ~/.tmux/plugins/tpm pull
~/.tmux/plugins/tpm/bin/install_plugins
