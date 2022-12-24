#!/usr/bin/env /bin/bash
bw get item 'A0D2143A1F988F3A.gpg' | jq -r '.notes' | gpg --import-options restore --import -
gpg --export-ssh-key A0D2143A1F988F3A > ~/.ssh/work.pub

bw get item '8042CE0E6B9CAB67.gpg' | jq -r '.notes' | gpg --import-options restore --import -
gpg --export-ssh-key 8042CE0E6B9CAB67 > ~/.ssh/personal.pub

# https://musigma.blog/2021/05/09/gpg-ssh-ed25519.html
# https://gist.github.com/mcattarinussi/834fc4b641ff4572018d0c665e5a94d3

# # New master key
#
# gpg --quick-generate-key 'Name <email@host>' ed25519 cert never
# gpg -a --export-secret-keys > master-secret-key.gpg
#
# gpg --delete-secret-key <id>
# 
# # New sub keys
# gpg --quick-add-key $KEY_ID ed25519 auth 1y
# gpg --quick-add-key $KEY_ID ed25519 sign 1y
# gpg --quick-add-key $KEY_ID cv25519 encr 1y
# gpg -a --export-secret-subkeys > sub-secret-keys.gpg
