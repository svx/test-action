#!/bin/sh -l

#echo "Hello $1"
#time=$(date)
#echo "::set-output name=time::$time"
#echo "::set-output name=status::Hello Cool"
FILE=test.log

if [ -s "$FILE" ]
then
    echo ::set-output name=status::failure
    #echo ::set-output name=output::$(cat test.log)
    cat test.log
    jq -nc '{"body": "test comment"}' | \
        curl -sL  -X POST -d @- \
        -H "Content-Type: application/json" \
        -H "Authorization: token ${{ secrets.GITHUB_TOKEN }}" \
        "https://api.github.com/repos/$GITHUB_REPOSITORY/commits/$GITHUB_SHA/comments"
    exit 1
fi
