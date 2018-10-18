#!/bin/bash
#
# component: vua-heideltime
#----------------------------------------------------

workdir=$(cd $(dirname "${BASH_SOURCE[0]}") && cd ../.. && pwd)
modulesdir=$workdir/components/java
resdir=$workdir/components/resources/ixa-heideltime
cd $modulesdir
iconv -t utf-8//IGNORE | java -Xmx1000m -jar $modulesdir/ixa.pipe.time.jar -m $resdir/alpino-to-treetagger.csv -c $resdir/config.props
cd $workdir