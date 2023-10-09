#!/usr/bin/bash #

#get_top_fully_vaccinated.sh - analyzes vaccine information
#
#input: csv file
#output: counties with highest vaccine count
#
#usage: ./get_top_fully_vaccinated.sh <csv file> <how many shown>
#
#Grant Bellotti, 1939767, gbellott@ucsc.edu

debug=0
if [ "$debug" -eq 2 ]; then 
    echo "parameters needed: $2"
    echo "got: $# parameters"
fi

#check correct number of parameters
if [ $# -ne 2 ]; then 
    echo >&2 "Invalid number of arguments"
    #echo >&2 "usage: ./get_top_fully_vaccinated.sh <csv file> <how many shown>"
    exit 1
fi

#check if directory exists
if [ ! -f "$1" ]; then
    echo >&2 "Cannot find/read covidVaccines.csv"
    exit 2
fi

#ls -ltF --color=auto "$1"
if [ $? -ne 0 ]; then
    echo >&2 "Something went wrong listing files"
    exit 3
fi

IFS=','

date=$( cat $1 | awk -F ',' '{print $1}' | tail -n +2 | head -1 ) #get the newest date
top=$( grep $date $1  | awk -F ',' '{print $6 "," $5 "," $4}' | tail -n +2 | sort -t ',' -k1,1r -k2,1  | head -$2 ) #get the top inputted amount of places sorted by percent, then county name
echo "$top" | while IFS= read -r line ; #loop through to correctly print them
do 
    county=$( echo $line | awk '{print $3 " " $4 "" $5}' )
    state=$( echo $line | awk '{print $2}')
    percent=$( echo $line | awk '{print $1}')
    echo -e "$county,$state,$percent\033[0K\r"
done