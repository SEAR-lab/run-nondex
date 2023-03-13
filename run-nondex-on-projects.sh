#!/bin/bash

if [[ $1 == "" ]]; then
    echo "arg1 - projects.txt"
    exit
fi

echo "sha: $(git rev-parse HEAD)"
echo "start date: $(date)"
projfile=$1

# Setup the output file
resultsfile=$(pwd)/flakytests.csv
# echo "slug,sha,test" > ${resultsfile}

# Run NonDex on all these projects
for p in $(comm -23 <( sort -u ${projfile} ) <( sort -u already-run.csv )); do
    ./run-nondex.sh ${p} ${resultsfile}
    # Cleanup
    rm -rf $(echo ${p} | cut -d'/' -f1)
    echo ${p} >> already-run.csv
done

echo "end date: $(date)"
