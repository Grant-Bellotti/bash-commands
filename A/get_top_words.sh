#!/usr/bin/bash #

#get_top_words.sh - lists the top k most used words
#
#input: text file
#output: list of words in a text file thatre used the most
#
#usage: ./get_top_words.sh <text file> <number of words>
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
    #echo >&2 "usage: ./get_top_words.sh <text file> <number of words>"
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

lowercase=$( cat $1 | tr '[:upper:]' '[:lower:]' ) #make a variable with lower case sentence

x=1
while [ $x -le $(wc stopwords | awk '{print $1}') ] #loop through all the words in the stopwords file and remove them from the sentence
do
    remove=$(sed "${x}q;d" stopwords) #make a variable for the word to remove
    lowercase=$( printf " $lowercase " | sed "s/ $remove / /g" ) #remove that word from the sentence
    x=$((x+1))
done

echo $lowercase |  tr -cs '[:alpha:]' '\n' | sort | uniq -c | sort -k1,1nr -k2 | head -$2 | awk '{print $2}' #sort into columns and choose only the word

exit 0