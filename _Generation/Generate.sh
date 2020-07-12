#!/bin/bash
# CD-ing to the script directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "${DIR}"

# Cloning Alton
function clone {
	git clone https://www.github.com/parsashahzeidi/Alton alton\
			>/dev/null 2>&1

	if [ $? != 0 ]
	then
		echo -en -- "\033[1mCloning failed.\033[0m"
		exit
	fi
	return $?
}

# Compressing a tarfile, then hashing it
# NOTE: The folder ./alton is copied so that there won't be any race
#	collisions with the "compile" function
function hash {
	cp -r ./alton ./compresstemp
	
	tar -c ./compresstemp -O\
			>./compressed.tar
	
	compress_result=$?
	
	if [ compress_result != 0 ]
	then
		echo -en -- "\033[1mCompressing failed.\033[0m\n"
	fi

	# Calculating the Commit ID
	cd ../
	hashed=`sha512sum ./temp.tar`
	
	# Clearing excess output in hashed
	read -ra hashed_split <<<$hashed
	hashed=${hashed_split[0]:0:16}

	echo -en -- "\033[1mHashing succeeded.\033[0m\n"
}

# Calculating the Compile results
# NOTE: The folder ./alton is copied so that there won't be any race
#	collisions with the "hash" function
function compile {
	cp -r ./alton ./compiletemp
	cd compiletemp

	cmake . -Wno-dev -G Ninja >/dev/null && ninja >/dev/null
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
}

# Cleans rubbish
function clean {
	rm -fr ./compressed.tar ./compiletemp ./compresstemp ./alton
}

clone
compress & compile
clean

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

# Commiting
cd ..
git commit -a -m "AutoCommiter v2.0.0" >/dev/null
git push

cd _Generation
