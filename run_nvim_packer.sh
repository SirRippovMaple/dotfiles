#!/usr/bin/env /bin/bash
[ -x "$(command -v nvim)" ] && nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
