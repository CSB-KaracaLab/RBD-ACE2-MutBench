#!/bin/csh

###############################################################
### This script uses specific mutation lists to build single amino acid mutations
### with BuildModel command and after computes complex energy with AnalyseComplex
### by using Foldx 5.0
### individual_list.txt is a mandatory file and should contains FoldX specific mutation format as a single column.
### List format : [Wild type aa][ChainID][residue][mutatedform;] 
### Example list:
### SE477A;
### SE477C;
### QE498H;
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
set foldx_dir = /Users/edasamiloglu/Software/Foldx

mkdir Mutated_PDBs
mkdir WildType_PDBs
mkdir BuildModel_Data

$foldx_dir/foldx --command=RepairPDB --pdb=$1 
mv $1 BuildModel_Data

foreach i(*Repair.pdb)
    $foldx_dir/foldx --command=BuildModel --pdb=$i --mutant-file=individual_list.txt
    mv $i BuildModel_Data
end

mv WT_* WildType_PDBs
mv *pdb Mutated_PDBs

echo All models were produced 
echo Now, Analyzing Complex Chains

cd Mutated_PDBs

mkdir fxout_data

# Runs over mutated pdb files to calculate AnalyseComplex value
# update chain id's if needed
set chain_1 = "A"
set chain_2 = "E"

foreach i(*pdb)
	set name = `echo $i | sed 's/\.pdb//g'`
	$foldx_dir/foldx --command=AnalyseComplex --pdb="$name".pdb --analyseComplexChains="$chain_1","$chain_2" > "$name".foldx
end

foreach i(*.foldx)
	echo $i `grep "Total          =" $i | tail -1 | awk '{print $3}'` >> AnalyzeCom
end

sed 's/\.foldx//g' AnalyzeCom |sort -V > tmp
mv tmp ..
mv *.fxout fxout_data
rm rotabase.txt
rmdir molecules
cd ..


paste tmp individual_list.txt > AnalyzeCom
rm tmp

cd WildType_PDBs
mkdir fxout_data

# update chain id's same as before
set chain_1 = "A"
set chain_2 = "E"

foreach i(*pdb)
	set name = `echo $i | sed 's/\.pdb//g'`
	$foldx_dir/foldx --command=AnalyseComplex --pdb="$name".pdb --analyseComplexChains="$chain_1","$chain_2" > "$name".foldx
end

foreach i(*.foldx)
	echo $i `grep "Total          =" $i | tail -1 | awk '{print $3}'` >> WT_AnalyzeCom
end

sed 's/\.foldx//g' WT_AnalyzeCom |sort -V > tmp
mv tmp ..
mv *.fxout fxout_data
rm rotabase.txt
rmdir molecules
cd ..

paste tmp AnalyzeCom > AnalyzeComplex_DG_Energies

rm tmp
rm AnalyzeCom
mv *.fxout BuildModel_Data
mv individual_list.txt BuildModel_Data
rm rotabase.txt
rmdir molecules

echo All Done


