#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "${DIR}/compiletemp"

# --- The templates ---
template_build_status=`<../TemplateBuildStatus.json`

# --- Compiling ---
cmake . -Wno-dev -G Ninja >/dev/null && ninja >/dev/null
result=$?

# --- Compile Succeeded. ---
if [ ${result} == 0 ]
then
	builds=1

	# --- Calculating the test results ---
	./Run -i=../../Tests/Tests.lfi >/dev/null 2>&1
	result=$?

	# --- Tests succeeded. ---
	if [ ${result} == 0 ]
	then
		tests=1

	# --- Tests failed. ---
	else
		echo -e "-- \033[1mTesting failed.\033[0m"
		tests=0
	fi

# Compile Failed.
else
	echo -e "-- \033[1mCompiling failed.\033[0m"
	builds=0
	tests=nan
fi

rm -fr ../compiletemp && cd ..

# Building the test status template
if [ ${tests} == 1 ]
then
	cache_colour=${success_colour}
	cache_message="Passing"
else
	cache_colour=${error_colour}
	cache_message="Failing"
fi
template_test_status=`printf "${template_test_status}" "${cache_message}" "${cache_colour}"`

# Building the build status template
if [ ${builds} == 1 ]
then
	cache_colour=${success_colour}
	cache_message="Passing"
else
	cache_colour=${error_colour}
	cache_message="Failing"
fi
template_build_status=`printf "${template_build_status}" "${cache_message}" "${cache_colour}"`

# Writin' to the hard drive
echo "${template_build_status}" >../BuildStatus.json
echo "${template_test_status}" >../TestStatus.json
