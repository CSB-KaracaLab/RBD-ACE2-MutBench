#!/bin/csh
#2021-Eda Samiloglu

###
# This script gets the FoldX interaction score (∆G) from .foldx extension files and pastes it with the related mutation, and model name (mutant or wild-type).
# FoldX produce a wild type model for each mutation, therefore we have a wild type score for each mutation.
# Note that .foldx extension files were named as <case id>_<protein name>_<mutation type>_FOLDX_<MUT of WT> to indicate corresponding case.
# Output of this script  
# This script must be in the same directory with the necessary files to run successfully.
#
# Necessary files: foldx extension files (FoldX outputs)
###

foreach i(*.foldx)
    echo $i `grep "Total          =" $i | tail -1 | awk '{print $3}'` > score_line
    sed 's/\./ /g' score_line > tmp
    set name =  `awk '{print $1}' tmp`
    set score = `awk '{print $2}' score_line`
    echo $name > name
    echo $score > score 
    paste -d ' ' name score >> FoldX_scores
end 

#sorting

sed 's/_/ /g' FoldX_scores > tmp
sort -k1 tmp > tmp1
awk '{print $1,$5,$6}' tmp1 > tmp2

#add header
echo "#case_id model_type foldx-score-wt" > header_wt
echo "#case_id model_type foldx-score-mut" > header_mut
grep WT tmp2 > WT
grep MUT tmp2 > MUT
cat header_wt WT > FoldX_scores_WT
cat header_mut MUT > FoldX_scores_MUT

#paste wt and mut scores into a dataset

paste -d ' ' FoldX_scores_MUT FoldX_scores_WT > FoldX_scores
awk '{print $1,$3,$6}' FoldX_scores > tmp
sed 's/ /,/g' tmp > FoldX_scores.csv

rm score_line score name tmp* FoldX_scores  header* MUT WT FoldX_scores_WT FoldX_scores_MUT
