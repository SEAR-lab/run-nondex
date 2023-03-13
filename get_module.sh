#!/bin/bash

if [[ $1 == "" ]]; then
    echo "arg1 - flaky tests csv"
    exit
fi

projfile=$1
dir=$(pwd)

for p in $(cut -d, -f1 ${projfile} | sort -u); do
    cd $dir
    mkdir -p projs/
    if [[ ! -d "projs/${p}" ]]; then
	git clone https://github.com/${p} projs/${p}
    fi

    for line in $(grep $p, ${projfile}); do
	class=$(echo $line | cut -d, -f3 | cut -d'#' -f1 | rev | cut -d'.' -f1 | rev)
	cd $dir/projs/$p

	classloc=$(find -name $class.java)
	if [[ -z $classloc ]]; then
	    echo $line,NO_CLASS_NAME
	    continue
	fi

	classcount=$(find -name $class.java | wc -l)
	if [[ "$classcount" != "1" ]]; then
	    echo $line,MULTI_CLASS_NAME
	    continue
	fi

	module=$classloc

	while [[ "$module" != "." && "$module" != "" ]]; do
	    module=$(echo $module | rev | cut -d'/' -f2- | rev)
	    if [[ -f $module/pom.xml ]]; then
		break;
	    fi
	done
	echo $line,$module
    done
done

rm -f *~

