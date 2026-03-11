#!/bin/bash

RED='\033[0;31m'
NOCOLOR='\033[0m'

if [ ! -f dci.yml ]; then
    echo -e "${RED}You seems to be in the wrong directory"
    echo -e "Execute this script from the root of dci-dev-env with ./utils/${0##*/}${NOCOLOR}"
    exit 1
fi

cat utils/projects.lst | while read project
do
    ([ -d "$project" ] || [ -L "$project" ]) || git clone git@github.com:distributedci/${project}.git
done
