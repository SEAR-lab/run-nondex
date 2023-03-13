#!/bin/bash

if [[ $1 == "" ]]; then
    echo "arg1 - flaky tests csv"
    exit
fi

projfile=$1

for p in $(cut -d, -f1 ${projfile} | sort -u); do
    rm -rf $(echo ${p} | cut -d'/' -f1)
    git clone https://github.com/${p} ${p}

    for line in $(grep $p, ${projfile}); do
	class=$(echo $line | cut -d, -f3 | cut -d'#' -f1 | rev | cut -d'.' -f1 | rev)
	classloc=$(find -name $class.java)
	if [[ -z $classloc ]]; then
	    echo $line,NO_CLASS_NAME
	    continue
	fi
	classcount=$(find -name $class.java | wc -l)
	if [[ "$classcount" != "1" ]]; then
	    classloc=$(find -name $class.java | head -n 1)
	    echo $line,MULTI_CLASS_NAME
	fi

	if [[ -z $module ]]; then
	    module=$classloc
	    while [[ "$module" != "." && "$module" != "" ]]; do
		module=$(echo $module | rev | cut -d'/' -f2- | rev)
		if [[ -f $module/pom.xml ]]; then
		    break;
		fi
	    done
	    echo $line,$module
    done
    rm -rf $(echo ${p} | cut -d'/' -f1)
done

rm -f *~

