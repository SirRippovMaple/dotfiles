#!/bin/sh
git clone --depth 1 https://github.com/ryanoasis/nerd-fonts ~/repositories/nerdfonts || git -C ~/repositories/nerdfonts pull
~/repositories/nerdfonts/install.sh
