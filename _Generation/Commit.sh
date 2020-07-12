#!/bin/bash
# CD-ing to the script directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "${DIR}/.."

# Commiting
echo -e "\033[0m\033[2m"
echo "You will now be asked for your Git credentials."
echo "If you enter the incorrect password and the git"
echo "command fails, you can retry, by going into the"
echo "_Generation folder, and running Commit.sh. Note"
echo "that the executable asking for your password is"
echo -e "your instance of the git client.\033[0m\n"

git commit -a -m "AutoCommiter!" >/dev/null
git push
