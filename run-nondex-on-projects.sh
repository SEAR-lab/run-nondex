#!/bin/bash

if [[ $1 == "" ]]; then
    echo "arg1 - projects.txt"
    exit
fi

projfile=$1

# Setup the output file
resultsfile=$(pwd)/flakytests.csv
echo "slug,sha,test" > ${resultsfile}

# Run NonDex on all these projects
for p in $(cat ${projfile}); do
    ./run-nondex.sh ${p} ${resultsfile}
    # Cleanup
    rm -rf ${slug}
done
