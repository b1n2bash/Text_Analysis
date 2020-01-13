#!/bin/bash

# Using a text stream from standard input, output a list 
# of the n (default: 10) most frequently occuring words and
# their frequency counts, in order of descending counts, on
# standard input
# Usage: ./wf.sh [FILE_PATH] (Optional: [NUMBER_OF_LINES])
# Reference: "Classic Shell Scripting": Arnold Robbins, Nelson H.F. Beebe
# Code takes inspiration from their approach to the problem. 

# Variable containing the file to be analyzed
FILEPATH=$1
# Variable representing the number of lines they wish to be printed
NUM=$2
# Variable representing output file destination
OUTPUT=Word_Demographic-$FILEPATH
# Variable representing an intermediate preperation steps that change the 
# word-frequency list into a more easily parsible form for the computer
INTERMEDIATE=intermediate.txt
INTERMEDIATE2=intermediate2.txt
INTERMEDIATE3=parsedListOfWords.txt


# Check if the user supplied a VALID filepath 
if [ ${#FILEPATH} == 0 ] 
then
	echo Please provide valid file\-path
	exit 1
elif [ ! -f $FILEPATH ] 
then
	echo Indicated file was not found.
	exit 1
fi

# If not specified, set the default number of lines to be printed as
# 10
if [ ${#NUM} == 0 ] 
then
	echo Since the number of lines was not specified, a default of 10 has been selected.
	NUM=10
fi


# Clear the output file before anything is written to it.
>$OUTPUT
# Add a line to the start of the file describing formatting:
echo "[Number of Occurences] [String that Occured]" > $OUTPUT



# Print out the contents of the file to be scanned
cat $FILEPATH |
# Replace non-letters/numbers with a new line and delete punctuation.
tr -cs [:alnum:] '\n' | tr -dcs '[:alnum:][:space:]' ' ' |	
# Map uppercase letters to lowercase	
tr '[:upper:]' '[:lower:]' |

# Sort the words in ascending order, eliminate duplicates
# and shows their counts.
sort | uniq -c | 
# Sort by descending count, then by ascending word
sort -k1,1nr -k2 |
# Print only the first n (default: 10) lines
head -n $NUM >> $OUTPUT 
# Explain where the output has been saved.
echo "The output has been successfully saved to: $OUTPUT"


#################### Initiate the Next Step ####################
echo "Parsing for list generator efficiency..."
# Create the Intermediate File to be cleaned up: Parsed
cp $OUTPUT $INTERMEDIATE
sed -i '1d' $INTERMEDIATE
sed "s/^[ \t]*//" -i $INTERMEDIATE
awk '{print $2}' $INTERMEDIATE > $INTERMEDIATE2
sed '/^\s*$/d' $INTERMEDIATE2 > $INTERMEDIATE3
echo "The file to be loaded into the generator is called: $INTERMEDIATE3"
# Clean up the Residual Files
mv $OUTPUT -t Target_Demographics
rm -f $INTERMEDIATE
rm -f $INTERMEDIATE2
