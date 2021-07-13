#!/bin/csh
#2021-01 by Eda Samiloglu

#This script consists of 2 parts. The first part reorganizes SSIPe_result.txt file. The second part calculates success rate and builds metric analysis.
#The SSIPe_result.txt, reference, volume_change.sh, hydrophobicity_change.sh, flexibility_change.sh, physicochemical_class_change.sh files are necessary to run this script.
#Usage: ./get_SSIPe_Prepared_dataset.csh

# FIRST PART
#sorting reference
sed 1d reference > tmp
sed 's/_/ /g' tmp > tmp1
sort -k1 tmp1 > tmp2

foreach i (`cat reference`)
    echo "SSIPe" >> SSIPe_tag
end

paste -d' ' tmp1 SSIPe_tag > caseid_predictor

#remove empty lines and header
sed -r '/^\s*$/d' SSIPe_result.txt > tmp_empty
sed 1d tmp_empty > tmp

awk '{print $4}' tmp > 4_column
awk '{print $1,$2,$3}' tmp > 1_2_3_column

#remove chain id 
sed -e 's/\(.\)/\1 /g' 4_column > tmp1
awk '!($2="")' tmp1 > tmp2
cat tmp2 | tr -d "[:blank:]" > tmp3
sed 's/;//g' tmp3 > case_id

paste case_id 1_2_3_column > ssipe
sort -k1 ssipe > ssipe_sorted
paste ssipe_sorted caseid_predictor  > check_the_sorted_lines
awk '{print $5,$6,$7,$8,$2}' check_the_sorted_lines > tmp
sed -r '/^\s*$/d' tmp > data


# SECOND PART
#parse dataset according to mutation_type
sed '/MD/d' data > tmp
sed '/RD/d' tmp > enriched
grep MD data > MD
grep RD data > RD
cat MD RD > depleted

#calculate success rate
awk '{if ($5 > 0 ){print $0, "0";} else {print $0, "1";}}' enriched > enriched_success_rate
awk '{if ($5 < 0) {print $0, "0";} else{print $0, "1";}}' depleted > depleted_success_rate
echo "#case_id protein mutation_type predictor ddg succ_rate" > header
cat enriched_success_rate depleted_success_rate  > tmp
sort -k1 tmp > tmp2
cat header tmp2 > SSIPe_scores_ddg

# Metrics

#Volume change
./volume_change.sh SSIPe_scores_ddg
#Hydrophobicity change
./hydrophobicity_change.sh SSIPe_scores_ddg
#Flexibility column
./flexibility_change.sh SSIPe_scores_ddg
#Physicochemical class change
./physicochemical_class_change.sh SSIPe_scores_ddg

#add succ_tag as failure or success
awk '{print $9}' SSIPe_scores_ddg > tmp
sed 1d tmp > succ_column
cat succ_column | awk '{ if ( $1 == 0 ) {print "failure"} else {print "success"}}' > succ_tag
echo "success_tag" > header
cat header succ_tag > new_column
paste -d' ' SSIPe_scores_ddg new_column > tmp
mv tmp SSIPe_Prepared_dataset

rm caseid_predictor check_the_sorted_lines data SSIPe_scores_ddg *tag *_column *_resi *_changes MD RD enriched* depleted* tmp* header ssipe* volume_change
