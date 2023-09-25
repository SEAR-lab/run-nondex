#!/bin/bash
# Usage: bash get_module.sh flakytests-filtered.csv $(pwd)/flakytests-filtered-w-mod.csv

if [[ $1 == "" ]] || [[ $2 == "" ]]; then
    echo "arg1 - flaky tests csv"
    echo "arg2 - output file name"
    exit
fi

projfile=$1
outfile=$2
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
	    echo $line,NO_CLASS_NAME >> $outfile
	    continue
	fi

	classcount=$(find -name $class.java | wc -l)
	if [[ "$classcount" != "1" ]]; then
	    echo $line,MULTI_CLASS_NAME  >> $outfile
	    continue
	fi

	module=$classloc

	while [[ "$module" != "." && "$module" != "" ]]; do
	    module=$(echo $module | rev | cut -d'/' -f2- | rev)
	    if [[ -f $module/pom.xml ]]; then
		break;
	    fi
	done
	module=$(echo $module | sed 's?./??g')
	ps="$(echo $line | cut -d, -f-2)"
	testname=$(echo $line | cut -d, -f3 | sed 's/#/./g')
	echo "https://github.com/${ps},${module},${testname},ID,,," >> $outfile
    done
done

rm -f *~
