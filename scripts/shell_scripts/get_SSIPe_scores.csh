#!/bin/csh
The first part reorganizes SSIPe_result.txt file. < ne şekilde organize ettik örneklerle açıkla>

sed 1d reference > ref

foreach i (`cat ref`)
    echo $i" SSIPe" >> reference_ssipe
end

#sort reference
sed 's/_/ /g' reference_ssipe > reference_column
sort -k1 reference_column > reference_sorted

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
paste ssipe_sorted reference_sorted  > check_the_sorted_lines
awk '{print $5,$6,$7,$8,$2}' check_the_sorted_lines > tmp
sed -r '/^\s*$/d' tmp > SSIPe_scores

# add header

echo "#case_id protein mutation_type predictor ddg" > header
cat header SSIPe_scores > dataset

#converting csv file

sed 's/ /,/g' dataset > SSIPe_scores.csv
rm case_id tmp* ssipe* ref reference_* check_the_sorted_lines 1_2_3_column 4_column header dataset SSIPe_scores 

