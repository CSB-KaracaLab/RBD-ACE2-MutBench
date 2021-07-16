#!/bin/csh
#2021-03 by Eda Samiloglu

#This script is used for preparing dataset of the figure of physicochemical class change. 
#Necessary files: HADDOCK_Prepared_dataset FoldX_Prepared_dataset FoldXwater_Prepared_dataset EvoEF1_Prepared_dataset SSIPe_Prepared_dataset MutaBind2_Prepared_dataset
#Usage: ./plot_dataset_physicochemical_class_change.csh

#get list of .csv files
ls *.csv > list

#remove headers
foreach i ( `cat list` )
sed 1d $i > tmp
mv tmp {$i}_predictor
end

#cat all datasets together
cat *_predictor > all_scores

#add two new colums for figure preparation - mutation_tag, subset_label
awk -F "," '{if ($3=="E") {print $0",Enriched,Enriched_"$11} else {print $0",Depleted,Depleted_"$11}}' all_scores > tmp

#add header
echo "#case_id,protein,mutation_type,predictor,ddg,succ_rate,volume_changes,hydroph_changes,flexibility,physichem_property,succ_tag,mutation_tag,subset_label" > header
cat header tmp > tmp1
sed 's/FOLDX/FoldX/g' tmp1 > dataset_physicochemical_class_change.csv 

rm list all_scores  tmp* header *_predictor

