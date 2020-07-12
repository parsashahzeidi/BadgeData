#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "${DIR}"

git clone https://www.github.com/parsashahzeidi/Alton.git ./alton				\
		>/dev/null 2>&1

if [ $? != 0 ]
then
	echo -e "-- \033[1mCloning failed.\033[0m"
else
	cp -r ./alton ./compresstemp
	cp -r ./alton ./compiletemp
	rm -fr ./alton
	echo -e "-- \033[1mCloning succeeded.\033[0m"
fi
