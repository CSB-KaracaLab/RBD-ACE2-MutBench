#!/bin/csh
#2021-01 Eda Samiloglu
#Necessary files: reference

#merges output .csv files: ACE2_E_MutaBind2.csv ACE2_RD_MutaBind2.csv  RBD_E_MutaBind2.csv RBD_RD_MutaBind2.csv ACE2_MD_MutaBind2.csv RBD_MD_MutaBind2.csv

foreach i (*.csv)
    cat $i > tmp
    sed 's/,/ /g' tmp >tmp1
    sed '/#/d' tmp1 > header_score 
    sed 1d header_score >> score
end

sed 1d reference > ref

foreach i (`cat ref`)
    echo $i" MutaBind2" >> reference_mutabind2
end

#sort reference
sed 's/_/ /g' reference_mutabind2 > reference_column
sort -k1 reference_column > reference_sorted
#sort scores
sort -k2 score > scores_sorted
awk '{print $3}' scores_sorted > ddg
paste -d ' ' reference_sorted ddg > tmp

echo "#case_id protein mutation_type predictor ddg" > header
cat header tmp > Mutabind2_scores

#converting csv file
sed 's/ /,/g' Mutabind2_scores > Mutabind2_scores.csv

rm header Mutabind2_scores ref reference_* score* tmp* header_score ddg

