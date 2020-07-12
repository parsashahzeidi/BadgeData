#!/bin/bash
# CD-ing to the script directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "${DIR}"

# Them colours
export error_colour=ff4443
export success_colour=81df7c
export neutral_colour=67add8

#./PrintHeader.sh & p1=$!
#./Clone.sh & p2=$!

#wait ${p1} || exit

#./Hash.sh & p1=$!
#./Compile.sh & p2=$!

#wait || exit

#./Commit.sh

./PrintHeader.sh	& ./Clone.sh	; wait || exit
./Hash.sh			& ./Compile.sh	; wait || exit

./Commit.sh
