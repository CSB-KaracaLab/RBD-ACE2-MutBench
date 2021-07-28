#!/bin/csh
#02-2021, Eda Şamiloğlu

#UEP is a standalone tool that predicts binding energy change upon mutation on highly-packed residues. Since UEP output only contains highly-packed residues (>2 inter-contact) may some of our cases have missed. This script finds out intersection of UEP dataset and ACE2-RBD dataset. Also calculates binary success rate of UEP (0/1) for each cases.
#6m0j_input_UEP_A_E.csv, reference
#Usage: ./UEP_ACE2-RBD_common_case_selection.csh 

#Format .csv file
#Fill the empty cells with NA
cat 6m0j_input_UEP_A_E.csv | sed 's/^,/NA,/g' | sed 's/,,/,NA,/g' | sed 's/,,/,NA,/g' | sed 's/,$/,NA/g' > tmp
sed 's/,/ /g' tmp > tmp1
#cut and copy the first column
awk '{print $1}' tmp1 > first_column
sed 1d first_column > uep_positions
awk '!($1="")' tmp1 > tmp2
#check the dataset that each line contains same number of elements. Result must be 20.
grep -v "#" tmp2 | awk '{print "Each line has ", NF ,"elements."}' | sort -u

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
paste mutation_pos1 binding_val > uep_prepared_dataset

#get intersected cases between our dataset (263) and UEP suggested dataset (Raw data).
awk -F'_' '{print $1}' reference > case_id
sed 1d case_id > common_positions

#Select common cases from uep dataset by using common positions.
foreach i (`cat common_positions`)
    grep $i uep_prepared_dataset >> common_cases
end

#SUCCESS RATE CALCULATION

awk '{print $1}' common_cases > common_case_positions
#get protein, mutation type columns from reference.
foreach i (`cat common_case_positions`)
    grep $i reference >> hd
    awk -F'_' '{print $1,$2,$3}' hd > ref
end

paste -d' ' common_cases ref > tmp
awk '{print $1,$4,$5,$2}' tmp > ref_performance

#create success tag for enriched cases
awk '$3 == "E" { print $0 }' ref_performance > enriched
awk '{if ($4 > 0 ){print $0, "0";} else {print $0, "1";}}' enriched > enriched_success_rate 
#create success tag for depleted cases
grep MD ref_performance > MD
grep RD ref_performance > RD
cat MD RD > depleted
awk '{if ($4 < 0) {print $0, "0";} else{print $0, "1";}}' depleted > depleted_success_rate

#paste together
cat enriched_success_rate depleted_success_rate > uep_with_performance
echo 'case_id protein mutation_type binding_value succ_rate' > header
cat header uep_with_performance > UEP_ACE2-RBD_common_dataset
sed 's/ /,/g' UEP_ACE2-RBD_common_dataset > UEP_ACE2-RBD_common_dataset.csv
 
rm depleted_success_rate ref UEP_ACE2-RBD_common_dataset case_id common_positions common_cases ref_performance tmp* x*  header mutation_pos  mutation_pos1 uep_positions  MD RD enriched depleted enriched_success_rate label dataset_single_letter amino_acids first_column hd binding_val common_case_positions  amino_acids_column uep_with_performance uep_prepared_dataset

