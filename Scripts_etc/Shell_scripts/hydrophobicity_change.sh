#!/bin/bash
#2021-03 by Eda Samiloglu

#This script converts amino acid name to its hydrophobicity value then subtracts hydrophobicity value of wild type from mutant. Then adds the hydrophobicity change column to the end of the dataset. Hydrophobicity values were taken from Eisenberg, D., Schwarz, E., Komaromy, M., & Wall, R. (1984). Analysis of membrane and surface protein sequences with the hydrophobic moment plot. Journal of molecular biology, 179(1), 125–142. https://doi.org/10.1016/0022-2836(84)90309-7)
#Usage: ./hydrophobicity_change.sh dataset.txt
#dataset.txt must contain wild type amino acid name, mutation position, and mutated amino acid name at the first column. For example A111G. (with single letter code).

#take the first column without header
awk 'FNR>1 {print $1}' $1 > case_id

sed 's/R/ -2.53 /
s/K/ -1.50 /
s/D/ -0.90 /
s/Q/ -0.85 /
s/N/ -0.78 /
s/E/ -0.74 /
s/H/ -0.40 /
s/S/ -0.18 /
s/T/ -0.05 /
s/P/ 0.12 /
s/Y/ 0.26 /
s/C/ 0.29 / 
s/G/ 0.48 /
s/A/ 0.62 /
s/M/ 0.64 /
s/W/ 0.81 /
s/L/ 1.06 /
s/V/ 1.08 /
s/F/ 1.19 /
s/I/ 1.38 /
s/*//g' case_id > output

#[mutant hydrophobicity number] - [wt hydrophobicity number]
awk '{$4 = $3 - $1} {print $4}' output > substraction
echo "hydrophobicity_change" > header
cat header substraction > hydrophobicity_change

#add the column at the end of the dataset with paste
paste -d " " $1 hydrophobicity_change > tmp
mv tmp $1
rm case_id output substraction header hydrophobicity_change


