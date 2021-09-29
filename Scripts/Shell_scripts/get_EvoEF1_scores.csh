#!/bin/csh
#Necessary files: .score files

foreach i (*.score)
    sed -n '/Total                 =/p' $i > scores_line
    set score = `awk '{print $3}' scores_line`
    echo $i |sed 's/\./ /g' > tmp
    set name = `awk '{print $1}' tmp`
    echo $name > name
    echo $score > score
    paste name score >> EvoEF1_scores
end

#sorting
sed 's/_/ /g' EvoEF1_scores > tmp
sed 's/\t/ /g' tmp > tmp1
sort -k1 tmp1 > tmp2
awk '{print $1,$5}' tmp2 > tmp3

#header
echo "#case_id,evoef1-score" > header
cat header tmp3 > EvoEF1_scores

#converting csv file
sed 's/ /,/g' EvoEF1_scores > EvoEF1_scores.csv

rm header name tmp* score scores_line EvoEF1_scores
