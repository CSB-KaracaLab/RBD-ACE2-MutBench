#!/bin/bash
#2021-03 by Eda Samiloglu

#This script converts amino acid name to its van der Waals radius and subtracts vdW radius of wild type from mutant. Then adds the column to the end of the dataset. van der Waals radius od amino acids were taken from Lin, Z. H., Long, H. X., Bo, Z., Wang, Y. Q., & Wu, Y. Z. (2008). New descriptors of amino acids and their application to peptide QSAR study. Peptides, 29(10), 1798–1805. https://doi.org/10.1016/j.peptides.2008.06.004
#Usage: ./volume_change.sh dataset.txt
#dataset.txt must contain wild type amino acid name, mutation position, and mutated amino acid name at the first column. For example A111G. (with single letter code).

#take the first column without header
awk 'FNR>1 {print $1}' $1 > case_id

sed 's/A/ 0.05702 /
s/R/ 0.58946 /
s/N/ 0.22972 /
s/D/ 0.21051 /
s/C/ 0.14907 /
s/Q/ 0.34861 /
s/E/ 0.32837 /
s/G/ 0.00279 /
s/H/ 0.37694 /
s/I/ 0.37671 /
s/L/ 0.37876 /
s/K/ 0.45363 /
s/M/ 0.38872 /
s/F/ 0.55298 /
s/P/ 0.2279 /
s/S/ 0.09204 /
s/T/ 0.19341 /
s/W/ 0.79351 /
s/Y/ 0.6115 /
s/V/ 0.25674/
s/*//g' case_id > output

#[mutant vdW radius] - [wt vdW radius]
awk '{$4 = $3 - $1} {print $4}' output > substraction
echo "volume_change" > header
cat header substraction > volume_change
#add the column at the end of the dataset with paste
paste -d " " $1 volume_change > tmp
mv tmp $1
#rm case_id output substraction header volume_change
