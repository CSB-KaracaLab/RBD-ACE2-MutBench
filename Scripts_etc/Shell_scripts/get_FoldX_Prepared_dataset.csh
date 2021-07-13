#!/bin/csh
#2020-12 by Eda Samiloglu

#This script consists of 2 parts. The first part extracts FoldX interaction score from .foldx files and pastes it with the related mutation name. The second part calculates the ∆∆G FoldX score and success rate of predictor for all mutations. ∆∆G FoldX score is equal to the difference between Mutant and Wild type FoldX scores. Note that, since mutations are modeled with FoldX's BuildModel option, all mutant structures have their own wild type model and score. Then it calculates the value that depends on the metrics for all mutations.
#The .foldx files, volume_change.sh, hydrophobicity_change.sh, flexibility_change.sh, physicochem_class_change.sh files are necessary to run this script.
#Usage: ./get_FoldX_Prepared_dataset

# FIRST PART
# Get the FoldX interaction score (∆G) from .foldx files and pastes it with the related mutation name.

foreach i(*.foldx)
    echo $i `grep "Total          =" $i | tail -1 | awk '{print $3}'` > score_line
    sed 's/\./ /g' score_line > tmp
    set name =  `awk '{print $1}' tmp`
    set score = `awk '{print $2}' score_line`
    echo $name > name
    echo $score > score 
    paste name score >> FoldX_scores
end 

#sorting

sed 's/_/ /g' FoldX_scores > tmp
sort -k1 tmp > tmp1

#add header
echo "#case_id protein mutation_type predictor model_type FoldX_score" > header
sed 's/\t/ /g' tmp1 > tmp2
cat header tmp2 > FoldX_scores_all
grep WT tmp2 > WT
grep MUT tmp2 > MUT
cat header WT > FoldX_scores_WT
cat header MUT > FoldX_scores_MUT

rm score_line score name tmp* header MUT WT FoldX_scores

# SECOND PART
#Calculation of ∆∆G FoldX score, success rate and metrics related columns (volume, hydrophobicity, flexibility, and physicochemical class change).

sed 1d FoldX_scores_MUT > MUT
sed 1d FoldX_scores_WT > WT
paste MUT WT > tmp
awk '{print $1,$2,$3,$4,$6,$12}' tmp > tmp1

# ∆∆G =  [Mutant FoldX score] - [Wild type FoldX score]
awk -F ' ' '{$7=($5-$6);} {print $1, $2, $3, $4, $5, $6, $7}' tmp1 > tmp2
sort -k1 tmp2 > tmp3

#parse dataset according to mutation_type
mv tmp3 data
sed '/MD/d' data > tmp
sed '/RD/d' tmp > enriched
grep MD data > MD
grep RD data > RD
cat MD RD > depleted

#calculate success rate
awk '{if ($7 > 0 ){print $0, "0";} else {print $0, "1";}}' enriched > enriched_success_rate
awk '{if ($7 < 0) {print $0, "0";} else{print $0, "1";}}' depleted > depleted_success_rate

#add header
echo "#case_id protein mutation_type predictor FoldX_score_MUT FoldX_score_WT ddg succ_rate" > header
cat enriched_success_rate depleted_success_rate  > tmp
sort -k1 tmp > tmp1
cat header tmp1 > tmp2
sed 's/\t/ /g' tmp2 > FoldX_scores_ddg

#Metrics

#Volume change
./volume_change.sh FoldX_scores_ddg 
#Hydrophobicity change
./hydrophobicity_change.sh FoldX_scores_ddg

#Flexibility column
./flexibility_change.sh FoldX_scores_ddg

#Physicochemical class change
./physicochemical_class_change.sh FoldX_scores_ddg

#add succ_tag as failure or success
awk '{print $9}' FoldX_scores_ddg > tmp
sed 1d tmp > succ_column
cat succ_column | awk '{ if ( $1 == 0 ) {print "failure"} else {print "success"}}' > succ_tag
echo "success_tag" > header
cat header succ_tag > new_column
paste -d' ' FoldX_scores_ddg new_column > tmp
mv tmp FoldX_scores_ddg

rm *tag *_column *_resi MUT WT header tmp* enriched* MD RD data depleted* volume_change FoldX_scores_MUT FoldX_scores_WT FoldX_scores_all

#Select columns except FoldX_score_MUT and FoldX_score_WT

awk '{print $1,$2,$3,$4,$7,$8,$9,$10,$11,$12,$13}' FoldX_scores_ddg > FoldX_Prepared_dataset
rm FoldX_scores_ddg
