#!/bin/csh
#31/05/2020

###############################################################
### This script was used to create HADDOCK input structure (6m0j_edited.pdb) with single occupancy (1.0) and temperature factor column ###(10.0). 
### 
### pdb-tools commands:
### pdb_element: Assigns the elements in the PDB file from atom names.
### pdb_b: Modifies the temperature factor column of a PDB file (default 10.0).
### pdb_occ: Modifies the occupancy column of a PDB file (default 1.0).
### pdb_selaltloc: Selects altloc labels for the entire PDB file.
###
### For further information and download pdb-tools: https://github.com/haddocking/pdb-tools
###############################################################

echo $1 > tmp
set name = `sed 's/.pdb//g' tmp`
pdb_element $1 |  pdb_b |  pdb_occ |  pdb_selaltloc > $name"_edited.pdb"

rm tmp


