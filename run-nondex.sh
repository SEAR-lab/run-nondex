#!/bin/bash

if [[ $1 == "" || $2 == "" ]]; then
    echo "arg1 - GitHub project SLUG"
    echo "arg2 - results file, absolute path"
    exit
fi

NUMROUNDS=3

slug=$1
resultsfile=$2

# Download project
git clone https://github.com/${slug} ${slug}

# Integrate NonDex
cd ${slug}
../../pom-modify/modify-project.sh .

# Get the SHA
sha=$(git rev-parse HEAD)

# Run NonDex, NUMROUNDS rounds
mvn nondex:nondex -DnondexRuns=${NUMROUNDS}

# Grab all the detected tests
for t in $(cat $(find -name failures) | sort -u); do
    echo ${slug},${sha},${t} >> ${resultsfile}
done
