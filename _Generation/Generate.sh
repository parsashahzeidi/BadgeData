#!/bin/bash
# CD-ing to the script directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "${DIR}"

# Them colours
export error_colour=ff4443
export success_colour=81df7c
export neutral_colour=67add8

./PrintHeader.sh &
./Clone.sh
./Hash.sh
./Compile.sh

# Them Templates
template_test_status=`<./TemplateTestStatus.json`

# Them Caches
cache_colour=""
cache_message=""


# Commiting
git commit -a -m "AutoCommiter v2.0.0" >/dev/null
git push

cd _Generation
