#!/usr/bin/env /bin/bash

git -C ~/Documents rev-parse
retVal=$?
if [ $retVal -ne 0 ]; then
    [ -f ~/Documents ] && mv ~/Documents ~/Documents.bak
    git clone git@trumpi-nas:documents ~/Documents
    cd ~/Documents
    git config --local commit.gpgsign false
    git config --local branch.master.sync true
fi
