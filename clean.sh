#!/bin/bash

if [[ $1 == "" ]]; then
    echo "arg1 - projects.txt"
    exit
fi

projfile=$1

resultsfile=$(pwd)/flakytests.csv
rm -rf ${resultsfile}

for p in $(cat ${projfile}); do
    rm -rf ${slug}
done

rm *~
rm -rf run.log
