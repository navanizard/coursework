#!/bin/bash

# reformat total counts in googlebooks-eng-all-totalcounts-20120701.txt to a valid csv
#   use tr, awk, or sed to convert tabs to newlines
#   write results to total_counts.csv

#The file starts with a leading space and tab, and ends with a tab, so need
#to remove them before converting tabs to newlines to avoid empty lines.

cat googlebooks-eng-all-totalcounts-20120701.txt | sed 's/^ \t//;s/\t$//' | 
    tr '\t' '\n' > total_counts.csv