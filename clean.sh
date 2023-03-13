#!/bin/bash

if [[ $1 == "" ]]; then
    echo "arg1 - projects.txt"
    exit
fi

projfile=$1

for p in $(cat ${projfile}); do
    rm -rf $(echo ${p} | cut -d'/' -f1)
done

rm -f *~
rm -rf run.log
