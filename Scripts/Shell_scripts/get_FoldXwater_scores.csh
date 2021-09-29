#!/bin/csh
#2020-12 by Eda Samiloglu

# Get the FoldXwater interaction score (∆G) from .foldx files and pastes it with the related mutation name.

foreach i(*.foldx)
    echo $i `grep "Total          =" $i | tail -1 | awk '{print $3}'` > score_line
    sed 's/\./ /g' score_line > tmp
    set name =  `awk '{print $1}' tmp`
    set score = `awk '{print $2}' score_line`
    echo $name > name
    echo $score > score 
    paste -d ' ' name score >> FoldXwater_scores
end 

#sorting

sed 's/_/ /g' FoldXwater_scores > tmp
sort -k1 tmp > tmp1

#add header
echo "#case_id protein mutation_type predictor model_type foldx-score-wt" > header_wt
echo "#case_id protein mutation_type predictor model_type foldx-score-mut" > header_mut
grep WT tmp1 > WT
grep MUT tmp1 > MUT
cat header_wt WT > FoldXwater_scores_WT
cat header_mut MUT > FoldXwater_scores_MUT

#paste wt and mut scores into a dataset

paste -d ' ' FoldXwater_scores_MUT FoldXwater_scores_WT > FoldXwater_scores
awk '{print $1,$6,$12}' FoldXwater_scores > tmp
sed 's/ /,/g' tmp > FoldXwater_scores.csv
rm FoldXwater_scores score_line score name header* tmp* MUT WT FoldXwater_scores_WT FoldXwater_scores_MUT
