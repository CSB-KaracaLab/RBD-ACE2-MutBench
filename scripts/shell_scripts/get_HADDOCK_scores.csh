#!/bin/csh
#2021-Eda Samiloglu

####
# This script collects the best HADDOCK binding score from HADDOCK run-folders.
# Note that HADDOCK run-folders were named as <case id>_<protein name>_<mutation type>_HADDOCK to indicate corresponding mutation.
# Output of this script is a CSV file that contains case id, protein name, mutation type, and HADDOCK score of mutant and wild type ACE2-RBD complex.
# This script must be in the same directory with the necessary files to run successfully.
#
# Necessary files: HADDOCK run folders
# Usage: ./get_HADDOCK_scores.csv
####

# First, get a list of HADDOCK run files to indicate mutations with folder names. Then, extracte HADDOCK score from structures_haddock-sorted.stat files in the /structures/it1/water/ directory. The first line of structures_haddock-sorted.stat file is the header, and the second line is the best HADDOCK score of the corresponding mutation.
touch label_score_list 
foreach i (*HADDOCK)
    echo $i >> run_name_list
    mv label_score_list $i/structures/it1/water/
    cd $i/structures/it1/water/
    head -2 structures_haddock-sorted.stat > tmp
    awk '{print $2}' tmp > tmp1
    head -1 tmp1 > header
    mv header ../../../../
    tail -1 tmp1 > score_line
    echo $i |sed 's/_/ /g' > tmp2
    awk '{print $1}' tmp2 > label
    paste label score_line  >> label_score_list
    mv label_score_list ../../../../
    rm tmp*
    rm label
    rm score_line
    cd ../../../../
end

sed 's/_/ /g' run_name_list > tmp
mv tmp run_name_list

#sorting dataset according to case id 
paste run_name_list label_score_list > tmp
sort -k1 tmp > tmp1
awk '{print $1,$6}' tmp1 > tmp
sed 's/\t#/ /g' tmp > HADDOCK_scores

#converting dataset to CSV file
echo "#case_id,haddock-score" > header
cat header HADDOCK_scores > tmp
sed 's/ /,/g' tmp > HADDOCK_scores.csv

rm tmp* HADDOCK_scores header label_score_list run_name_list

