#!/bin/sh
git clone --depth 1 https://github.com/secretgeek/ok-bash ~/.okrepo > /dev/null 2>&1 \
 || git -C ~/.okrepo pull > /dev/null 2>&1
