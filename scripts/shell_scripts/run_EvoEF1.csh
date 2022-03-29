#!/bin/csh
# 2020-10-05
# Can Yukruk
#Adapted in September 2021

###############################################################
### This script uses specific mutation lists to build single amino acid mutations and to compute binding affinity by using EvoEF1. 
### mutation_list file should contain EvoEF1 specific mutation format as a single column.
### List format : [Wild type aa][ChainID][residue][mutatedform] 
### Example list:
### HA34A
### FA28A
### FE490A
### To run the script : ./run_EvoEF1.csh PDBID
### Example : ./run_EvoEF1.csh 6m0j
### (pdb file and script should be in the same folder with EvoEF1.)
###############################################################


if ($#argv != 1) then
  echo "----------------------------------------------------------"
  echo "This script changes pdb files' format to use in EvoEF1."
  echo "----------------------------------------------------------"
  echo "Usage:"
  echo "./run_EvoEF1.csh PDBID"
  echo "Example:"
  echo "/run_EvoEF1.csh 6m0j"
  echo "----------------------------------------------------------"
  exit 0

endif 
# set your own PATH
set EvoEF = /cm/shared/apps/evoef/EvoEF

mkdir output_structures
mkdir output_scores

# The following chunk create individual_list.txt file for each mutation and run mutation program of EvoEF1 one by one.

foreach i(`cat mutation_list`)
	$EvoEF --command=RepairStructure --pdb=$1.pdb
	touch individual_list.txt
	echo "$i;" >> individual_list.txt
	$EvoEF --command=BuildMutant --pdb=$1_Repair.pdb -- mutantfile=individual_list.txt 	
	rm individual_list.txt
	# W-T for wild type
	mv $1_Repair.pdb W-T_Repair.pdb
	mv W-T_Repair.pdb output_structures
	mv "$1"_Repair_Model_0001.pdb "$i"_EvoEF1.pdb	
end

# Each mutations' score files are created and moved to output_structure and output_score folders.

mv *_EvoEF1.pdb output_structures
cd output_structures
foreach i(*.pdb)
	echo $i |sed 's/\./ /; s/_/ /g' > tmp
	set name = `awk '{print $1}' tmp`
	touch "$name"_EvoEF1.score
	$EvoEF --command=ComputeBinding --pdb="$i" >> "$name"_EvoEF1.score
	mv *.score ../output_scores
	rm tmp
end
cd ..


# All scores and corresponding mutation names are combined in EvoEF_score file.

cd output_scores
foreach i (*.score)
    sed -n '/Total                 =/p' $i > scores_line
    set score = `awk '{print $3}' scores_line`
    echo $i |sed 's/\./ /; s/_/ /g' > tmp
    # cut the 2. position to remove chainid from caseid
    cut --complement -c2 tmp > tmp1
    set name = `awk '{print $1}' tmp1`
    echo $name > name
    echo $score > score
    paste name score >> name_score
end

# header
echo "#case_id evoef1-score" > header
cat header name_score > EvoEF1_scores

# converting csv file
awk '{print $1,$2}' EvoEF1_scores > tmp
sed 's/ /,/g' tmp > EvoEF1_scores.csv
mv EvoEF1_scores.csv ..

rm scores_line header name tmp* score name_score EvoEF1_scores
