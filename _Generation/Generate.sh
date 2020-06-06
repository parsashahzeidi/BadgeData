#!/bin/bash
# CD-ing to the script directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "${DIR}"

# Cloning Alton
git clone https://www.github.com/parsashahzeidi/Alton alton >/dev/null 2>&1

if [ $? != 0 ]
then
	echo cloning failed.
	exit
fi

# Compressing
tar -c ./alton -O > ./temp.tar

# Backing up
# TODO: <

cd ./alton

# Calculating the Compile results
cmake . -G Ninja >/dev/null && ninja >/dev/null
result=$?

# Compile Succeeded.
if [ ${result} == "0" ]
then
	builds=1

	# Calculating the test results
	./Run -i=../../Tests/Tests.lfi >/dev/null 2>&1
	result=$?

	# Tests succeeded.
	if [ ${result} == 0 ]
	then
		tests=1

	# Tests failed.
	else
		tests=0
	fi

# Compile Failed.
else
	builds=0
	tests=nan
fi

# Calculating the Commit ID
cd ../
hashed=`sha512sum ./temp.tar`
rm ./temp.tar
rm -rf ./alton

# Clearing excess output in hashed
read -ra hashed_split <<<$hashed
hashed=${hashed_split[0]:0:16}

# Them Templates
template_build_status=`<./TemplateBuildStatus.json`
template_commit_hash=`<./TemplateCommitHash.json`
template_test_status=`<./TemplateTestStatus.json`

# Them colours
error_colour=ff4443
success_colour=81df7c

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
rm -rf ./alton

# Commiting
cd ..
git commit -a -m "Anotha one!" >/dev/null
git push

cd _Generation
