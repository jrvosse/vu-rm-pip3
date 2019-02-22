#!/bin/bash
set -eo pipefail
IFS=$'\n\t'

usage() {
  echo "Usage: $0 [ -c ]" 1>&2
  exit 1
}

clean=0
while getopts ":c" opt; do
  case "$opt" in
    c)
      clean=1 ;;
    *)
      usage ;;
  esac
done
shift $((OPTIND - 1))

workdir=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)
modulesdir=$workdir/components
javadir=$modulesdir/java
resourcesdir=$modulesdir/resources
pythondir=$modulesdir/python
scriptdir=$workdir/scripts/install
utildir=$workdir/scripts/util
envvars=$workdir/.newsreader

if [ "$clean" -eq 1 ] && [ -d $modulesdir ]; then
  rm -rf $modulesdir
fi

for dir in $pythondir $javadir $resourcesdir
do
  [[ ! -d $dir ]] && mkdir -p $dir
done

function install-mor {
  echo "Installing the Alpino parser and wrapper ..."
  $scriptdir/install-alpino.sh http://www.let.rug.nl/vannoord/alp/Alpino/versions/binary/Alpino-x86_64-Linux-glibc-2.19-21235-sicstus.tar.gz $resourcesdir/Alpino
  echo "export ALPINO_HOME=${resourcesdir}/Alpino" >> $envvars
  source $envvars
  $scriptdir/get-from-git.sh cltl/morphosyntactic_parser_nl 85b7603 $pythondir 
  echo "Finished installing the Alpino wrapper."
}

function install-ixa-pipes {
  echo "Installing the ixa-nerc models ..."
  $scriptdir/get-ixa-pipes.sh $javadir $resourcesdir
  echo "Finished installing the ixa-nerc models."
}

function install-ned {
  echo "Installing NED and dbpedia resources ..."
  wdir=$resourcesdir/spotlight
  mkdir $wdir
  cd $wdir
  wget http://sourceforge.net/projects/dbpedia-spotlight/files/2016-04/nl/model/nl.tar.gz
  tar -zxvf nl.tar.gz
  wget http://ixa2.si.ehu.es/ixa-pipes/models/wikipedia-db.tar.gz
  tar -xzvf wikipedia-db.tar.gz
  rm *tar.gz
  wget https://sourceforge.net/projects/dbpedia-spotlight/files/spotlight/dbpedia-spotlight-0.7.1.jar
  mvn install:install-file -Dfile=dbpedia-spotlight-0.7.1.jar -DgroupId=ixa -DartifactId=dbpedia-spotlight -Dversion=0.7 -Dpackaging=jar -DgeneratePom=true 
  $scriptdir/install-ned.sh ixa-ehu/ixa-pipe-ned 062a983 $javadir $utildir
  echo "Finished installing NED module."
}

function install-vua-resources {
  echo "Installing vua resources..." 
  $scriptdir/get-vua-resources.sh cltl/vua-resources e730ce6 $resourcesdir/vua-resources
  echo "Finished installing vua resources."
}

function install-wsd {
  echo "Installing the WSD module ..."
  $scriptdir/install-wsd.sh cltl/svm_wsd 8bb5319 $pythondir
  echo "Finished installing WSD"
}

function install-heideltime {
  echo "Installing time normalization ..."
  $scriptdir/install-vuheideltimewrapper.sh cltl/vuheideltimewrapper 484ed80 $javadir $resourcesdir $utildir
  echo "Finished installing time normalization."
}

function install-onto {
  echo "Installing OntoTagger..."
  $scriptdir/get-exec-jar-from-distrib.sh https://github.com/cltl/OntoTagger/archive/v3.1.1.tar.gz $javadir
  echo "Finished installing OntoTagger."
}

function install-srl {
  echo "Installing SRL (Sonar)..."
  $scriptdir/get-from-git.sh sarnoult/vua-srl-nl 72ad676 $pythondir
  echo "Finished installing srl module"
}

function install-dutch-nominal-events {
  echo "Installing Dutch nominal event labeller..."
  $scriptdir/get-from-git.sh newsreader/vua-srl-dutch-nominal-events 6115b31 $pythondir
  echo "Finished installing Dutch nominal event labeller."
}

function install-multi-factuality {
  echo "Installing factuality module..."
  $scriptdir/get-from-git.sh cltl/multilingual_factuality cbad484 $pythondir
  echo "Finished installing factuality module."
}

function install-opinmin {
  echo "Installing opinion miner..."
  $scriptdir/install-opinion-miner.sh rubenIzquierdo/opinion_miner_deluxePP 3d99e85 $pythondir
  echo "Finished installing opinion miner"
}

function install-evcoref {
  echo "Installing event coreference module..."
  $scriptdir/install-eventcoreference.sh https://github.com/cltl/EventCoreference/archive/v3.1.1.tar.gz $javadir $utildir
  echo "Finished installing event coreference module."
}

install-mor
install-ixa-pipes
install-ned
install-vua-resources
install-wsd
install-heideltime
install-onto
install-srl
install-dutch-nominal-events
install-multi-factuality
install-opinmin
install-evcoref

echo "Finished."
