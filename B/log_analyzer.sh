#!/usr/bin/bash #

#log_analyzer.sh - analyzes log files from a server
#
#input: log file
#output: the average content size and the count of unique response codes
#
#usage: ./log_analyzer.sh <log file>
#
#Grant Bellotti, 1939767, gbellott@ucsc.edu

debug=0
if [ "$debug" -eq 1 ]; then
    echo "parameters needed: $2"
    echo "got: $# parameters"
fi

#check correct number of parameters
if [ $# -ne 1 ]; then
    echo >&2 "Invalid number of arguments"
    #echo >&2 "usage: ./log_analyzer.sh <log file>"
    exit 1
fi

#check if directory exists
if [ ! -f "$1" ]; then
    echo >&2 "Cannot find/read that file"
    exit 2
fi

#ls -ltF --color=auto "$1"
if [ $? -ne 0 ]; then
    echo >&2 "Something went wrong listing files"
    exit 3
fi

unique=()
totalContentSize=0
while IFS= read -r line #loop through all the data and find new response codes and add the content size to the total size
do
    responseCode=$( echo "$line" | awk '{print $9}' )
    contentSize=$( echo "$line" | awk '{print $10}' )

    re='^[0-9]+$'
    if [[ $contentSize =~ $re ]] ; then #if the content size is a number
        totalContentSize=$(($totalContentSize+$contentSize))
    fi


    if ! [[ $(echo ${unique[@]} | fgrep -w $responseCode) ]] #if the response code is a new one add it to the list
    then
        unique+=($responseCode)

    fi

done < "$1"
expr $totalContentSize / $(wc $1 | awk '{print $1}') #take the average
echo ${#unique[@]}
