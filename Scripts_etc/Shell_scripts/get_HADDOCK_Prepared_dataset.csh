#!/bin/csh
#2021-01 by Eda Samiloglu

#This script consists of 2 parts. The first part extracts HADDOCK scores from HADDOCK run files. The second part calculates ∆∆G value and builds metric analysis.
#The HADDOCK run files, volume_change.sh, hydrophobicity_change.sh, flexibility_change.sh, physicochemical_class_change.sh files are necessary to run this script.
#Usage: ./get_HADDOCK_Prepared_dataset.csh

# FIRST PART
#This part of the script used to get HADDOCK score and HADDOCK score components (Evdw, Eelec, bsa, Edesolv) of best HADDOCK scored structure from the run file. Result of this script we get an 8 column dataset.
#Columns are Run_name, Mutation_label, #struc, haddock-score, Evdw, Eelec, bsa, and Edesolv. 


touch label_score_list
foreach i (*HADDOCK)
    echo $i >> run_name_list
    mv label_score_list $i/structures/it1/water/
    cd $i/structures/it1/water/
    head -2 structures_haddock-sorted.stat > tmp
    awk '{print $1, $2, $7, $8, $21, $23}' tmp > tmp1
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

echo "#case_id protein mutation_type predictor" > tmp3
paste  tmp3 header > header_new

sed 's/_/ /g' run_name_list > tmp4
mv tmp4 run_name_list
#sorting
paste run_name_list label_score_list > tmp5
sort -k1 tmp5 > tmp6
awk '{print $1,$2,$3,$4,$6,$7,$8,$9,$10,$11}' tmp6 > tmp7
cat header_new tmp7 > tmp8 
sed 's/\t#/ /g' tmp8 > HADDOCK_scores

rm header* label_score_list tmp* run_name_list


# SECOND PART
#This script calculates differences of Mutant HADDOCK score and Wild type HADDOCK score for all mutations (∆∆G). It calculates success rate of predictor for each mutations. Then it calculates the value changes of the metrics for all mutations (hydrophobicity changes, volume changes, physicochemcal property). 

#remove header
sed 1d HADDOCK_scores >tmp

#Find the WT HADDOCK score
#grep WT HADDOCK_scores
#case_id protein mutation_type predictor struc haddock-score Evdw Eelec bsa Edesolv
#NA NA WT HADDOCK complex_180w.pdb -143.8481 -65.286 -261.566 1953.22 -26.2489

sed '/WT/d' tmp > HADDOCK_scores_mut

# ∆∆G =  [Mutant HADDOCK score] - [Wild type HADDOCK score]
awk -F ' ' '{$0=($6+143.8481);} {print $0}' HADDOCK_scores_mut > ddg_hd
awk -F ' ' '{$0=($7+65.286);} {print $0}' HADDOCK_scores_mut > ddg_vdw
awk -F ' ' '{$0=($8+261.566);} {print $0}' HADDOCK_scores_mut > ddg_elec
awk -F ' ' '{$0=($9-1953.22);} {print $0}' HADDOCK_scores_mut > ddg_bsa
awk -F ' ' '{$0=($10+26.2489);} {print $0}' HADDOCK_scores_mut > ddg_desolv

paste HADDOCK_scores_mut ddg_hd > tmp1

#parse dataset according to mutation_type
mv tmp1 data
sed '/MD/d' data > tmp
sed '/RD/d' tmp > enriched
grep MD data > MD
grep RD data > RD
cat MD RD > depleted

#calculate success rate
awk '{if ($11 > 0 ){print $0, "0";} else {print $0, "1";}}' enriched > enriched_success_rate
awk '{if ($11 < 0) {print $0, "0";} else{print $0, "1";}}' depleted > depleted_success_rate

#add header
echo "#case_id protein mutation_type predictor struc ddg succ_rate dd_Evdw dd_Eelec dd_bsa dd_Edesolv" > header
cat enriched_success_rate depleted_success_rate > tmp
sort -k1 tmp > tmp1
paste tmp1 ddg_vdw ddg_elec ddg_bsa ddg_desolv > tmp
awk '{print $1,$2,$3,$4,$5,$11,$12,$13,$14,$15,$16}' tmp > tmp1
cat header tmp1 > tmp2
sed 's/\t/ /g' tmp2 > HADDOCK_scores_ddg

# Metrics

#Volume change
./volume_change.sh HADDOCK_scores_ddg

#Hydrophobicity change
./hydrophobicity_change.sh HADDOCK_scores_ddg

#Flexibility column
./flexibility_change.sh HADDOCK_scores_ddg

#Physicochemical class change
./physicochemical_class_change.sh HADDOCK_scores_ddg

#add succ_tag as failure or success
awk '{print $7}' HADDOCK_scores_ddg > tmp
sed 1d tmp > succ_column
cat succ_column | awk '{ if ( $1 == 0 ) {print "failure"} else {print "success"}}' > succ_tag
echo "success_tag" > header
cat header succ_tag > new_column
paste -d' ' HADDOCK_scores_ddg new_column > tmp
mv tmp HADDOCK_scores_ddg

#select desired columns
awk '{print $1,$2,$3,$4,$6,$7,$12,$13,$14,$15,$16}' HADDOCK_scores_ddg > HADDOCK_Prepared_dataset

rm data volume_change HADDOCK_scores_ddg ddg_* HADDOCK_scores_mut *_resi *changes *_column tmp* enriched MD RD depleted enriched_success_rate *header *tag depleted_success_rate HADDOCK_scores
