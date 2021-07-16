#!/bin/csh
#2021-05 Eda Şamiloğlu

#This script is used for preparing the dataset of figure of volume, hydrophobicity, and flexibility change.
#Necessary files: HADDOCK_Prepared_dataset FoldX_Prepared_dataset FoldXwater_Prepared_dataset EvoEF1_Prepared_dataset SSIPe_Prepared_dataset MutaBind2_Prepared_dataset 


#Divide datasets into Enriched and Depleted for each predictor

printf "HADDOCK\nFoldX\nFoldXwater\nEvoEF1\nMutaBind2\nSSIPe\n" > list

foreach i (`cat list`)
awk -F ',' '{if ($3=="E") {print $0}}' {$i}_Prepared_dataset.csv > {$i}_Enriched
end

foreach i (`cat list`)
awk -F ',' '{if ($3!="E") {print $0}}' {$i}_Prepared_dataset.csv > {$i}_Depleted
end

#remove header

ls *_Depleted > Dep_list
foreach i (`cat Dep_list`)
sed 1d $i > tmp
mv tmp {$i}
end


# Sub-Divide Enriched Datasets into Success Failure

ls *_Enriched > Enr_list

foreach i (`cat Enr_list`)
awk -F ',' '{if ($6==1) {print $0}}' {$i} > {$i}_Success
end

foreach i (`cat Enr_list`)
awk -F ',' '{if ($6==0) {print $0}}' {$i} > {$i}_Failure
end


foreach i (`cat Dep_list`)
awk -F ',' '{if ($6==1) {print $0}}' {$i} > {$i}_Success
end

foreach i (`cat Dep_list`)
awk -F ',' '{if ($6==0) {print $0}}' {$i} > {$i}_Failure
end


# Change predictor column of one of the (random) Deleted and Enriched dataset to use as Experimental dataset

sed 's/HADDOCK/Experimental/g' HADDOCK_Enriched > Enriched
sed 's/HADDOCK/Experimental/g' HADDOCK_Depleted > Depleted

## Build datasets
# add header
head -1 HADDOCK_Prepared_dataset.csv > header

cat header *_Enriched_Success Enriched > Enriched_Success_dataset
cat header *_Enriched_Failure Enriched > Enriched_Failure_dataset

cat header *_Depleted_Success Depleted > Depleted_Success_dataset
cat header *_Depleted_Failure Depleted > Depleted_Failure_dataset

rm header *list  *_Success *Enriched *Depleted *_Failure
