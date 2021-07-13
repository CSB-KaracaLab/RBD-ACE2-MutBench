#!/bin/bash

#####
#2021-03 by Eda Samiloglu
#This script converts the amino acid name to its rotamer number. Rotamer numbers of amino acids are listed below (taken from Shapovalov, M. V., & Dunbrack, R. L., Jr (2011). A smoothed backbone-dependent rotamer library for proteins derived from adaptive kernel density estimates and regressions. Structure (London, England : 1993), 19(6), 844–858. https://doi.org/10.1016/j.str.2011.03.019).
#This script was builded for adding rotamer numbers of changing columns to the end of the dataset. 
#Usage: ./flexibility.sh dataset.txt
#dataset.txt must contain wild type amino acid name, mutation position, and mutated amino acid name at the first column. For example A111G. (with single letter code).
#####

#take the first column without header
awk 'FNR>1 {print $1}' $1 > case_id

#change amino acid name to its rotamer numbers
sed 's/A/ 1 /
s/R/ 81 /
s/N/ 3 /
s/D/ 3 /
s/C/ 3 /
s/Q/ 9 /
s/E/ 9 /
s/G/ 1 /
s/H/ 3 /
s/I/ 9 /
s/L/ 9 /
s/K/ 81 /
s/M/ 27 /
s/F/ 3 /
s/P/ 2 /
s/S/ 3 /
s/T/ 3 /
s/W/ 3 /
s/Y/ 3 /
s/V/ 3 /
s/*//g' case_id > output

#[mutant rotamer number] - [wt rotamer number]
awk '{$4 = $3 - $1} {print $4}' output > substraction
echo "flexibility" > header
cat header substraction > rotamer_number_change

#add the column at the end of the dataset with paste
paste -d " " $1 rotamer_number_change > tmp 
mv tmp $1
rm case_id output substraction header rotamer_number_change
