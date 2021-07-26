#!/bin/csh
#2021-01 Eda Samiloglu

#This script consists of 2 parts. The first part merges MutaBind2 output files (Raw datasets) of SARS-CoV-2 mutations into a file. The second part calculates success rate of predictor for each case and builds metric analysis.
#The MutaBind2 output files, reference, volume_change.sh, hydrophobicity_change.sh, flexibility_change.sh, physicochemical_class_change.sh files are necessary to run this script.
#Usage: ./get_MutaBind2_Prepared_dataset.csh

# FIRST PART
# merges output .csv files
foreach i (*.csv)
    cat $i > tmp
    sed 's/,/ /g' tmp >tmp1
    sed '/#/d' tmp1 > header_score
    head -1 header_score > header 
    sed 1d header_score >> score
end
sed 's/Mutated Chain/Mutated_Chain/g' header >tmp
mv tmp header
mv score All_scores_Mutabind2
echo "#case_id protein mutation_type predictor" > add_header
paste add_header header > new_header
cat header All_scores_Mutabind2 > tmp
sed 's/Mutated Chain/Mutated_Chain/g' tmp > tmp1
sed 's/ /,/g' tmp1 > All_scores_Mutabind2.csv

#sort reference
sed 's/_/ /g' reference > tmp
sort -k1 tmp > tmp1
#sort scores
sort -k2 All_scores_Mutabind2 > tmp2
#MutaBind2 lines
foreach i (`cat reference`)
    echo "MutaBind2" >> mutabind2
end

paste tmp1 mutabind2 tmp2 > tmp3
cat new_header tmp3 > header_reference_dataset

#select desired columns
awk '{print $1,$2, $3,$4, $7, $10, $11}' header_reference_dataset > Mutabind2_scores

# SECOND PART
#parse dataset according to mutation_type
sed 1d Mutabind2_scores > tmp
mv tmp data
sed '/MD/d' data > tmp
sed '/RD/d' tmp > enriched
grep MD data > MD
grep RD data > RD
cat MD RD > depleted

#calculate success rate
awk '{if ($5 > 0 ){print $0, "0";} else {print $0, "1";}}' enriched > enriched_success_rate
awk '{if ($5 < 0) {print $0, "0";} else{print $0, "1";}}' depleted > depleted_success_rate

cat enriched_success_rate depleted_success_rate  > tmp
sort -k1 tmp > tmp2
echo "#case_id protein mutation_type predictor ddg DDE_vdw DDG_solv succ_rate" > header
cat header tmp2 > MutaBind2_scores_ddg

# Metrics

#Volume change
./volume_change.sh MutaBind2_scores_ddg
#Hydrophobicity change
./hydrophobicity_change.sh MutaBind2_scores_ddg
#Flexibility column
./flexibility_change.sh MutaBind2_scores_ddg
#Physicochemical class change
./physicochemical_class_change.sh MutaBind2_scores_ddg

#add succ_tag as failure or success
awk '{print $8}' MutaBind2_scores_ddg > tmp
sed 1d tmp > succ_column
cat succ_column | awk '{ if ( $1 == 0 ) {print "failure"} else {print "success"}}' > succ_tag
echo "success_tag" > header
cat header succ_tag > new_column
paste -d' ' MutaBind2_scores_ddg new_column > tmp
mv tmp MutaBind2_scores_ddg

#select desired columns
awk '{print $1,$2,$3,$4,$5,$8,$9,$10,$11,$12,$13}' MutaBind2_scores_ddg > MutaBind2_Prepared_dataset
sed 's/ /,/g' MutaBind2_Prepared_dataset > MutaBind2_Prepared_dataset.csv

rm MutaBind2_Prepared_dataset succ_column succ_tag new_column volume_change enriched* depleted* MD RD mutabind2 All_scores_Mutabind2* header* add_header new_header data Mutabind2_scores MutaBind2_scores_ddg
