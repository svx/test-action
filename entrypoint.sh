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
fi
