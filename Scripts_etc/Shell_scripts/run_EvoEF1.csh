#!/bin/csh
# 2020-10-05
# Can Yukruk

###############################################################
### This script uses specific mutation lists to build single amino acid mutations
### and to compute binding affinity by using EvoEF1. 
### mutation_list file should contain EvoEF1 specific mutation format as a single column.
### List format : [Wild type aa][ChainID][residue][mutatedform] 
### Example list:
### HA34A
### FA28A
### FE490A

### To run the script : ./run_EvoEF1.csh model
### Example : ./run_EvoEF1.csh 6m0j.pdb
### (pdb file and script should be in the same folder with EvoEF1.)
###############################################################


if ($#argv != 1) then
  echo "----------------------------------------------------------"
  echo "This script changes pdb files' format to use in EvoEF1."
  echo "----------------------------------------------------------"
  echo "Usage:"
  echo "./run_EvoEF1.csh pdb_file"
  echo "Example:"
  echo "/run_EvoEF1.csh 6m0j"
  echo "----------------------------------------------------------"
  exit 0

endif 

mkdir mutated_structures
mkdir individual_score_files

# The following chunk create individual_list.txt file for each mutation and run mutation program of EvoEF1 one by one.
##############################################################
foreach i(`cat mutation_list`)
	./EvoEF --command=RepairStructure --pdb=$1.pdb
	touch individual_list.txt
	echo "$i;" >> individual_list.txt
	./EvoEF --command=BuildMutant --pdb=$1_Repair.pdb -- mutantfile=individual_list.txt 	
	rm "$1"_Repair.pdb
	rm individual_list.txt
	mv "$1"_Repair_Model_0001.pdb "$i"_Repair_Model_1.pdb	
end

#Each mutations' score files are created and moved to mutated structure and individual score folders.
###############################################################

foreach i(*Model_1.pdb)
	
	touch "$i".score
	./EvoEF --command=ComputeBinding --pdb="$i" >> "$i".score
	mv "$i" mutated_structures
	
end

foreach i(*.score)
	mv "$i" individual_score_files
end

#All scores and corresponding mutation names are combined in all_scores file. The last row of the list is the score of Wild type. 
###############################################################

cd individual_score_files
touch scores
gsettings set org.gnome.nautilus.preferences default-sort-order "name"

foreach i(*.score)
	echo `grep "^Total                 =" $i` | awk '{print $3}'  >> scores 
end



mv scores ../
cd ..
./EvoEF --command=RepairStructure --pdb=$1.pdb
./EvoEF --command=ComputeBinding --pdb=6m0j_Repair.pdb >> WT_score
echo `grep "^Total                 =" WT_score` | awk '{print $3}'  >> scores
sort mutation_list > sorted_mutat_list
echo wildtpe >> sorted_mutat_list
paste sorted_mutat_list scores > all_scores


rm scores
rm sorted_mutat_list
rm WT_score


