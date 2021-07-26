#!/bin/csh
#2020-12 by Eda Samiloglu

#This script selects mutations that were used in the study from deep mutagenesis datasets of RBD and ACE2.
#Necessary files:RBD_from_literature.csv, ACE2_from_literature.csv, reference
#All these files and the script should be in the same folder.
#Usage: ./get_experimental_values.csh

#divide reference into RBD and ACE2
sed 's/_/ /g' reference| grep RBD | awk '{print $1}' > case-id_list_rbd

sed 's/_/ /g' reference| grep ACE2 | awk '{print $1}' > ACE2 

# We need prepared case-id_list_ace2 file as <wt residue> <position> <mutated residue>; for instance A 111 C
sed 's/.\{1\}/& /g' ACE2 > seperated_ACE2
awk '{ print $1, $NF }' seperated_ACE2 > wt_and_mutated_resi
awk 'NF{NF-=1};1' seperated_ACE2 > remove_last_column_ACE2
awk '{print $2,$3,$4,$5}' remove_last_column_ACE2 > positions
sed 's/ //g' positions > positions1
paste wt_and_mutated_resi positions1 > tmp
awk '{print $1,$3,$2}' tmp > case-id_list_ace2 

#RBD
foreach i ("`cat case-id_list_rbd`") 
    sed -n '/'$i'/p' RBD_from_literature.csv >> selected_rbd
end

sed 's/\,/ /g' selected_rbd > tmp
sed 's/"//g' tmp > tmp1
sort -k1 tmp1 > tmp2
awk '{print $5,$9,$12}' tmp2 > experimental_values_of_selected_RBD_cases

#ACE2
#First, remove the header of ACE2 deep mutagenesis dataset.
tail -2457 ACE2_from_literature.csv > tmp
#There is a position list at the end of the ACE2_from_literature.csv. This list must be removed.
#2457-117=2340
head -2340 tmp > tmp1
sed 's/Nonsynonymous//g' tmp1 >tmp2
sed 's/\;/ /g' tmp2 > split_dataset


mkdir ACE2_split
mv split_dataset ACE2_split/
cp case-id_list_ace2 ACE2_split/
cd ACE2_split/

split -20 split_dataset


foreach i (x*) 
    head -1 $i  > name_line
    set k = `awk '{print $1}' name_line`
    mv $i $k
end

    
foreach i ("`cat case-id_list_ace2`") 
    echo $i >tmp
    awk '{print $2}' tmp > mut_number
    set k = `cat mut_number`
    awk '{print $3}' tmp > mut_resi
    set e = `cat mut_resi` 
    sed -n '/'$e'/p' $k >>  cases
    echo $k$e >> pos_mut-resi
end  

sed '/WT/d' cases > cases_witout_wt
paste pos_mut-resi cases_witout_wt > experimental_values_of_selected_ACE2_cases

rm tmp* 
rm mut*

mv experimental_values_of_selected_ACE2_cases ..
cd ..
rm -r ACE2_split/ 


#remove numbers in first column

sed 's/30 D//g' experimental_values_of_selected_ACE2_cases > tmp
sed 's/35 E//g' tmp > tmp1
sed 's/34 H//g' tmp1 > tmp2
sed 's/353 K//g' tmp2 > tmp3
sed 's/357 R//g' tmp3 > tmp4
sed 's/393 R//g' tmp4 > tmp5
sed 's/41 Y//g' tmp5 > tmp6
sed 's/27 T//g' tmp6 > tmp7
sed 's/324 T//g' tmp7 > columned_dataset
rm tmp*

awk '{print $1}' columned_dataset > 1_column
awk '{print $4, $5}' columned_dataset > 4_5_column

awk -F ' ' '{$3=($1+$2)/2;} {print $3}' 4_5_column > binding

paste 1_column binding > experimental_values_of_selected_ACE2_cases

cat case-id_list_ace2 | tr -d "[:blank:]" > new_case-id_list_ace2 

paste new_case-id_list_ace2 experimental_values_of_selected_ACE2_cases > column_exchange
awk '{print $1,$3}' column_exchange > experimental_values_of_selected_ACE2_cases

#sorting
sort -k1 experimental_values_of_selected_ACE2_cases > tmp3
mv tmp3 experimental_values_of_selected_ACE2_cases

#add header

echo "#case_id RBD_bind_avg RBD_expr_avg" > header_rbd
echo "#case_id ACE2_exp_ddg" > header_ace2

cat header_rbd experimental_values_of_selected_RBD_cases > RBD
cat header_ace2 experimental_values_of_selected_ACE2_cases > ACE2
sed 's/ /,/g' ACE2 > ACE2_Experimental_dataset.csv
sort -k1  RBD > experimental_values_of_selected_RBD_cases
sed 's/ /,/g' experimental_values_of_selected_RBD_cases > RBD_Experimental_dataset.csv

rm header* ACE2 RBD case-id* position* remove_last_column_ACE2 wt_and_mutated_resi seperated_ACE2 1_column 4_5_column binding columned_dataset column_exchange new_case-id_list_ace2 selected_rbd experimental_values_of_selected_* 
