#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "${DIR}"

# --- The templates ---
template_commit_hash=`<./TemplateCommitHash.json`

# --- Compressing ---
tar -c ./compresstemp -O\
		>./compressed.tar
compress_result=$?

if [ ${compress_result} != 0 ]
then
	echo -e "-- \033[1mTarring failed.\033[0m"
	exit
fi

# --- Calculating the hash ---
hashed=`sha512sum ./compressed.tar`

# --- Clearing excess output in the summary ---
hashed=${hashed:0:16}

# --- Cleaning files ---
rm -fr ./compresstemp ./compressed.tar

# --- We done here, imma go. ---
echo -e "-- \033[1mHashing succeeded.\033[0m"

# Building the commit hash template
# Writin'
template_commit_hash=`printf "${template_commit_hash}" "${hashed}" "${neutral_colour}"`

# Writin' to the hard drive
echo "${template_commit_hash}" >../CommitHash.json
