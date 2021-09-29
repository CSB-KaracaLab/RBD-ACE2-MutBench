#!/bin/csh

#UEP is a standalone tool that predicts binding energy change upon mutation on highly-packed residues. Since UEP output only contains highly-packed residues (>2 inter-contact) may some of our cases have missed. This script finds out intersection of UEP dataset and ACE2-RBD dataset and UEP binding score of those cases. 

#Necessary file: reference, 6m0j_input_UEP_A_E.csv

#Usage:

#Format 6m0j_input_UEP_A_E.csv  file
#Fill the empty cells with NA
cat 6m0j_input_UEP_A_E.csv | sed 's/^,/NA,/g' | sed 's/,,/,NA,/g' | sed 's/,,/,NA,/g' | sed 's/,$/,NA/g' > tmp
sed 's/,/ /g' tmp > tmp1

#cut and copy the first column
awk '{print $1}' tmp1 > first_column
sed 1d first_column > uep_positions
awk '!($1="")' tmp1 > tmp2

#check the dataset that each line contains same number of elements. Result must be 20.
grep -v "#" tmp2 | awk '{print "Each line has ", NF ,"elements. Fine."}' | sort -u

#formatting text file; each column is printed in a same column
fmt -1 tmp2 > tmp3

#get amino acids
head -20 tmp3 > amino_acids

#get values
tail -n 560 tmp3 > tmp4

#print uep positions 20 times
foreach i (`cat uep_positions`)
    printf $i'%.s\n' `seq 20` >> label
end

#print amino acids 28 times since uep has 28 positions
foreach i (`seq 28`)
  cat amino_acids >> amino_acids_column
end

#paste position, mutated amino acid and binding value
paste label amino_acids_column tmp4 > uep_prepared_dataset

#remove NA cases since we do not have binding values at these positions. Number of remained cases are 506.
sed '/NA/d' uep_prepared_dataset > tmp
sed 's/_/ /g' tmp > tmp1
awk '{print $3, $2, $4}' tmp1 > mutation_pos
awk '{print $5}' tmp1 > binding_val

#convert single letter amino acid names
sed 's/\HIS/H/; s/\ARG/R/; s/\LYS/K/; s/\ILE/I/; s/\PHE/F/; s/\LEU/L/; s/\TRP/W/; s/\ALA/A/; s/\MET/M/; s/\PRO/P/; s/\CYS/C/; s/\ASN/N/; s/\VAL/V/; s/\GLY/G/; s/\SER/S/; s/\GLN/Q/; s/\TYR/Y/; s/ASP/D/; s/\GLU/E/; s/\THR/T/g' mutation_pos >> dataset_single_letter
sed 's/ //g' dataset_single_letter > mutation_pos1
paste -d ' ' mutation_pos1 binding_val > uep_prepared_dataset


#get common cases for ACE2-RBD dataset and UEP from reference file.
awk -F'_' '{print $1}' reference > case_id
sed 1d case_id > common_positions

#Select common cases from uep dataset by using common positions.
foreach i (`cat common_positions`)
    grep $i uep_prepared_dataset >> UEP_scores
end

#select protein and mutation type information from reference
awk '{print $1}' UEP_scores > uep_cases
sed 's/_/ /g' reference > ref

foreach i (`cat uep_cases`)
    grep $i ref >> protein_mutationtype 
end

#sorting dataset
sort -k1 UEP_scores > UEP_scores_sorted
sort -k1 protein_mutationtype > labels

paste -d ' ' labels UEP_scores_sorted > labels_UEP_scores 
awk '{print $1,$2,$3,$5}' labels_UEP_scores > UEP_scores_labeled

#add header
echo "#case_id protein mutation_type ddg" > header
cat header UEP_scores_labeled > UEP_scores

#converting csv file
sed 's/ /,/g' UEP_scores > UEP_scores.csv

rm tmp* uep_* mutation_* amino_acids* case_id binding_val dataset_single_letter first_column label*  UEP_scores_sorted header protein_mutationtype ref UEP_scores_labeled UEP_scores common_positions

