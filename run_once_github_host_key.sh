#!/usr/bin/env bash
touch ~/.ssh/known_hosts
if ! grep github.com ~/.ssh/known_hosts > /dev/null
then
    cat <<EOF >> ~/.ssh/known_hosts
# github.com:22 SSH-2.0-babeld-b447314b
|1|dWt1RJ7v3J3M4HbYzB4Oa731ihU=|J7m80wowzjeZY+dMP0rAQEDyr0c= ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==
# github.com:22 SSH-2.0-babeld-b447314b
# github.com:22 SSH-2.0-babeld-b447314b
# github.com:22 SSH-2.0-babeld-b447314b
# github.com:22 SSH-2.0-babeld-b447314b
EOF
fi