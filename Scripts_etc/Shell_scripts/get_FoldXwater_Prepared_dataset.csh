#!/bin/csh
#05-2021, Eda Samiloglu

#This script consist from 2 parts. The first part gets FoldX scores (∆G of MUT and WT) from output (.foldx) files. The second part calculates ∆∆G and builds metric analysis.
#Necessary files: .foldx files, volume_change.sh, hydrophobicity_change.sh, flexibility_change.sh, physicochemical_class_change.sh 
# Usage: ./get_FoldXwater_Prepared_dataset.csh


# FIRST PART
# We get FoldX scores (∆G) of MUT and WT models from .foldx files.
# File names: FoldXwater_scores_MUT, FoldXwater_scores_WT 
foreach i(*.foldx)
    echo $i `grep "Total          =" $i | tail -1 | awk '{print $3}'` > score_line
    sed 's/\./ /g' score_line > tmp
    set name =  `awk '{print $1}' tmp`
    set score = `awk '{print $2}' score_line`
    echo $name > name
    echo $score > score
    paste -d" " name score >> FoldXwater_scores
end

grep MUT FoldXwater_scores > FoldXwater_scores_MUT
grep WT FoldXwater_scores > FoldXwater_scores_WT

sed -i 's/_/ /g' FoldXwater_scores_MUT
sed -i 's/_/ /g' FoldXwater_scores_WT

echo "#case_id protein mutation_type predictor model_type FoldXwater_score" > header


cat header FoldXwater_scores_MUT > tmp
mv tmp FoldXwater_scores_MUT

cat header FoldXwater_scores_WT > tmp
mv tmp FoldXwater_scores_WT

rm name score* header tmp*

# SECOND PART
#∆∆G =  [Mutant FoldXwater score] - [Wild type FoldXwater score]
# FoldXwater_Prepared_dataset file was generated. 
paste FoldXwater_scores_MUT FoldXwater_scores_WT > tmp
sed -i 1d tmp
awk '{print $1,$2,$3,$4,$6,$12}' tmp > DG_MUT_WT
#DG_MUT - DG_WT
awk -F ' ' '{$7=($5-$6);} {print $1, $2, $3, $4, $5, $6, $7}' DG_MUT_WT > DDG

#parse dataset according to mutation_type
sed '/MD/d' DDG > tmp
sed '/RD/d' tmp > enriched
grep MD DDG > MD
grep RD DDG > RD
cat MD RD > depleted

#calculate success rate
awk '{if ($7 > 0 ){print $0, "0";} else {print $0, "1";}}' enriched > enriched_success_rate
awk '{if ($7 < 0) {print $0, "0";} else{print $0, "1";}}' depleted > depleted_success_rate

#add header
echo "#case_id protein mutation_type predictor FoldXwater_score_MUT FoldXwater_score_WT ddg succ_rate" > header
cat enriched_success_rate depleted_success_rate  > tmp
sort -k1 tmp > tmp1
cat header tmp1 > FoldXwater_scores_ddg

# Metrics

# #Volume change
./volume_change.sh FoldXwater_scores_ddg
# #Hydrophobicity change
./hydrophobicity_change.sh FoldXwater_scores_ddg
# #Flexibility column
./flexibility_change.sh FoldXwater_scores_ddg
# #Physicochemical class change
./physicochemical_class_change.sh FoldXwater_scores_ddg

#add succ_tag as failure or success
awk '{print $8}' FoldXwater_scores_ddg > tmp
sed 1d tmp > succ_column
cat succ_column | awk '{ if ( $1 == 0 ) {print "failure"} else {print "success"}}' > succ_tag
echo "success_tag" > header
cat header succ_tag > new_column
paste -d' ' FoldXwater_scores_ddg new_column > tmp

#Select columns except FoldX_score_MUT and FoldX_score_WT

awk '{print $1,$2,$3,$4,$7,$8,$9,$10,$11,$12,$13}' tmp > FoldXwater_Prepared_dataset

rm FoldXwater_scores* volume_change tmp* header RD MD enriched* depleted* DDG DG_MUT_WT succ* new*

