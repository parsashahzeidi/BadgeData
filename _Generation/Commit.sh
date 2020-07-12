#!/bin/bash
# CD-ing to the script directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "${DIR}/.."

# Commiting
git commit -a -m "AutoCommiter!" >/dev/null

# --- Pushing ---
git push
while [ $? ]; git push; end
