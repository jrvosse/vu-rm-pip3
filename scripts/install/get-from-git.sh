#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

usage() {
  echo "Usage: $0 github_sfx commit_nb targetdir" 1>&2
  exit 1
}

if [ $# -ne 3 ]; then
  usage
fi


#------------------------------------------------
github_sfx=$1
commit_nb=$2
targetdir=$3
module=$(basename ${github_sfx})


# clone and package / install module ------------
cd $targetdir
git clone https://github.com/${github_sfx}.git
cd $module
git checkout $commit_nb

