#!/bin/bash
# CD-ing to the script directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "${DIR}"

echo -en "\n\033[1m    AutoCommitter v0.1.0\n\033[0;2m\nPlease wait ti"
echo -en "ll the process finishes.\nOn some slow internet connections,"
echo -en " the\nfirst step may take around a minute.\n\n"
