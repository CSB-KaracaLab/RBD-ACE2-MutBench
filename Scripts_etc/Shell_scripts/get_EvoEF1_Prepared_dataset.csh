#!/bin/csh
#2020-12 Eda Samiloglu

#This script consists of 2 part. First part gets EvoEF1 scores from output (.score) files. Second part renders ∆∆G calculation, metric analysis and builds prepared dataset of EvoEF1. 
#Necessary files: .score files, volume_change.sh, hydrophobicity_change.sh, flexibility_change.sh, physicochemical_class_change.sh
#Usage:./get_EvoEF1_Prepared_dataset.sh

# FIRST PART
#Get EvoEF1 scores from .score files and  paste the score with its mutation name.
#mv WT file, no need in foreach loop
mv NA_NA_WT_EvoEF1.score ..
 
foreach i (*.score)
    sed -n '/Total                 =/p' $i > scores_line
    set score = `awk '{print $3}' scores_line`
    echo $i |sed 's/\./ /g' > tmp
    set name = `awk '{print $1}' tmp`
    echo $name > name
    echo $score > score
    paste name score >> EvoEF1_scores 
end

#relocate WT file
mv ../NA_NA_WT_EvoEF1.score .

#sorting
sed 's/_/ /g' EvoEF1_scores > tmp
sed 's/\t/ /g' tmp > tmp1
sort -k1 tmp1 > tmp2

#header
echo "#case_id protein mutation_type predictor EvoEF1_score" > header
cat header tmp2 > EvoEF1_scores

rm header name score tmp* scores_line

# SECOND PART
#Calculates ∆∆G, renders metric analysis and builds prepared dataset of EvoEF1.

#calculate ∆∆G EvoEF1_scores, WT EvoEF1 score of 6m0j is -19.53.
# ∆∆G =  [Mutant EvoEF1 score] - [Wild type EvoEF1 score]
cp EvoEF1_scores tmp
sed 1d tmp > tmp1
awk -F ' ' '{$6=($5+19.53);} {print $1, $2, $3, $4, $5, $6}' tmp1 > tmp2

#parse dataset according to mutation_type
mv tmp2 data
sed '/MD/d' data > tmp
sed '/RD/d' tmp > enriched
grep MD data > MD
grep RD data > RD
cat MD RD > depleted

#calculate success rate
awk '{if ($6 > 0 ){print $0, "0";} else {print $0, "1";}}' enriched > enriched_success_rate
awk '{if ($6 < 0) {print $0, "0";} else{print $0, "1";}}' depleted > depleted_success_rate

echo "#case_id protein mutation_type predictor EvoEF1_score ddg succ_rate" > header
cat enriched_success_rate depleted_success_rate  > tmp
sort -k1 tmp > tmp2
cat header tmp2 > EvoEF1_scores_ddg

#Metrics

#Volume change
./volume_change.sh EvoEF1_scores_ddg
#Hydrophobicity change
./hydrophobicity_change.sh EvoEF1_scores_ddg

#Flexibility column
./flexibility_change.sh EvoEF1_scores_ddg

#Physicochemical class change
./physicochemical_class_change.sh EvoEF1_scores_ddg

#add succ_tag as failure or success
awk '{print $7}' EvoEF1_scores_ddg > tmp
sed 1d tmp > succ_column
cat succ_column | awk '{ if ( $1 == 0 ) {print "failure"} else {print "success"}}' > succ_tag
echo "success_tag" > header
cat header succ_tag > new_column
paste -d' ' EvoEF1_scores_ddg new_column > tmp
mv tmp EvoEF1_scores_ddg

#select desered column
awk '{print $1,$2,$3,$4,$6,$7,$8,$9,$10,$11,$12}' EvoEF1_scores_ddg > EvoEF1_Prepared_dataset
sed 's/ /,/g' EvoEF1_Prepared_dataset > EvoEF1_Prepared_dataset.csv

#remove WT line
sed -i '/,WT,/d' EvoEF1_Prepared_dataset.csv
rm EvoEF1_Prepared_dataset EvoEF1_scores_ddg *tag *_column *_resi header tmp* enriched* MD RD data depleted* volume_change EvoEF1_scores
