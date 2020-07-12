#!/bin/bash
# CD-ing to the script directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "${DIR}"

# Them colours
export error_colour=ff4443
export success_colour=81df7c

./Clone.sh
./Hash.sh
./Compile.sh
clean

# Them Templates
template_test_status=`<./TemplateTestStatus.json`

# Them Caches
cache_colour=""
cache_message=""

# Building the build status template
if [ ${builds} == 1 ]
then
	cache_colour=${success_colour}
	cache_message="Passing"

else
	cache_colour=${error_colour}
	cache_message="Failing"

fi

# Writin'
template_build_status=`printf "${template_build_status}" "${cache_message}" "${cache_colour}"`

# Building the test status template
if [ ${tests} == 1 ]
then
	cache_colour=${success_colour}
	cache_message="Passing"

else
	cache_colour=${error_colour}
	cache_message="Failing"

fi

# Writin'
template_test_status=`printf "${template_test_status}" "${cache_message}" "${cache_colour}"`

# Building the commit hash templates
# Writin'
template_commit_hash=`printf "${template_commit_hash}" "${hashed}"`

# Writin' to the hard drive
echo "${template_build_status}" >../BuildStatus.json
echo "${template_test_status}" >../TestStatus.json
echo "${template_commit_hash}" >../CommitHash.json

# Commiting
git commit -a -m "AutoCommiter v2.0.0" >/dev/null
git push

cd _Generation
