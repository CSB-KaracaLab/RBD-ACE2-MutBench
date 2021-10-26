#!/bin/csh
#Adapted in September 2021

###############################################################
### This script uses specific mutation lists to build single amino acid mutations with BuildModel command and after computes complex
### energy with AnalyseComplex by using Foldx 5.0.
### individual_list.txt is a mandatory file and should contains FoldX specific mutation format as a single column.
### List format : [Wild type aa][ChainID][residue][mutatedform;]
### Example list:
### SE477A;
### SE477C;
### To run the script : ./run_FoldX.csh pdb_file
### Example : ./run_FoldX.csh 6m0j.pdb
### (Do not forget to update your foldx_dir location.)
###############################################################

if ($#argv != 1) then
  echo "----------------------------------------------------------"
  echo "This script changes pdb files according to individual_list.txt file"
  echo "Then, calculates complex analyze ΔG values"
  echo "----------------------------------------------------------"
  echo "Usage:"
  echo "./run_FoldX.csh pdb_file"
  echo "Example:"
  echo "./run_FoldX.csh 6m0j.pdb"
  echo "(Do not forget to update your foldx_dir location.)"
  echo "----------------------------------------------------------"
  exit 0
endif

# update this to your own foldx directory
set foldx_dir = /archive/karacalabshared/Software/foldx5Linux64

mkdir mutant_structures
mkdir wildtype_structures
mkdir output_scores

$foldx_dir/foldx --command=RepairPDB --pdb=$1

foreach i(*Repair.pdb)
    $foldx_dir/foldx --command=BuildModel --pdb=$i --mutant-file=individual_list.txt
end

# rename FoldX structures -FoldX gives order as a name to the structure
ls -lrt *_Repair_*.pdb |awk '{print $9}' > pdb_list
sed 's/;//g' individual_list.txt > caselist
foreach i (`cat caselist`)
	printf "$i\n$i"_WT"\n" >> caseid
end
paste -d ' ' pdb_list caseid > rename_lines
foreach i("`cat rename_lines`")
        echo $i > tmp
        set old_name = `awk '{print $1}' tmp`
        awk '{print $2}' tmp > new
        cut --complement -c2 new > new_name_without_chainid
        set new_name = `cat new_name_without_chainid`
        mv "$old_name" "$new_name"_FoldX.pdb
end
rm rename_lines caseid tmp new caselist pdb_list new_name_without_chainid 

mv *_WT_FoldX.pdb wildtype_structures
mv *_FoldX.pdb mutant_structures

cd mutant_structures
mkdir fxout_data

# Runs over mutated pdb files to calculate FoldX scores
# update chain id's if needed
set chain_1 = "A"
set chain_2 = "E"

foreach i(*pdb)
	set name = `echo $i | sed 's/\.pdb//g'`
	$foldx_dir/foldx --command=AnalyseComplex --pdb="$name".pdb --analyseComplexChains="$chain_1","$chain_2" > "$name".score
end

foreach i(*.score)
	echo $i `grep "Total          =" $i | tail -1 | awk '{print $3}'` >> FoldX_score
end

mv *fxout fxout_data
mv *.score ../output_scores
rm -r molecules
rm rotabase.txt 
mv FoldX_score ../


cd ../wildtype_structures

mkdir fxout_data

# update chain id's same as before
set chain_1 = "A"
set chain_2 = "E"

foreach i(*pdb)
	set name = `echo $i | sed 's/\.pdb//g'`
	$foldx_dir/foldx --command=AnalyseComplex --pdb="$name".pdb --analyseComplexChains="$chain_1","$chain_2" > "$name".score
end

foreach i(*.score)
	echo $i `grep "Total          =" $i | tail -1 | awk '{print $3}'` >> WT_FoldX_score
end

mv *fxout fxout_data
mv *.score ../output_scores
rm -r molecules
rm rotabase.txt 
mv WT_FoldX_score ../

cd .. 
mv *fxout mutant_structures/fxout_data
rm rotabase.txt Unrecognized_molecules.txt
rm -r molecules

paste -d ' ' FoldX_score WT_FoldX_score > data
sed -i 's/_FoldX.score//g' data
awk '{print $1,$2,$4}' data > data1
#add header
echo '#case_id foldx-score-mut foldx-score-wt' > header
cat header data1 > FoldX_score
#convert csv file
sed 's/ /,/g' FoldX_score > FoldX_score.csv
rm WT_FoldX_score FoldX_score data* header

mkdir output_structures
mv mutant_structures/ output_structures/
mv wildtype_structures/ output_structures/






















