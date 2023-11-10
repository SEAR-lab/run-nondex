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
rm -rf $(echo ${slug} | cut -d'/' -f1)
git clone https://github.com/${slug} ${slug}

# Integrate NonDex
cd ${slug}
../../pom-modify/modify-project.sh .

# Get the SHA
sha=$(git rev-parse HEAD)

# Run NonDex, NUMROUNDS rounds
timeout 3600s mvn edu.illinois:nondex-maven-plugin:2.1.1:nondex -DnondexRuns=${NUMROUNDS} > nondex_log.txt 2>&1

# Tests that passed without shuffling and failed with shuffling
result=$(sed -n '/Across all seeds:/,/Test results can be found at:/ {/Across all seeds:/! {/Test results can be found at:/! p;};}' nondex_log.txt)

IFS=$'\n'
for line in $result; do
    t=$(echo "$line" | sed 's/\[[^]]*\] //')
    echo "${slug},${sha},${t}" >> "${resultsfile}"
done

rm nondex_log.txt
