#!/bin/bash
#2021-01 by Eda Samiloglu

#This script converts the amino acid name to its physicochemical property and adds the property to at the end of the dataset as a column. According to the mutated amino acid, the case is labeled as charge_gain, charge_loss, polarity_gain, or lose polarity.
#-charge: E D R K
#-polar: H N Q S T Y
#-non-polar: A C G I L M F P W V
#Usage: ./physicochemical_class_change.sh dataset.txt
#dataset.txt must contain wild type amino acid name, mutation position, and mutated amino acid name at the first column. For example A111G. (with single letter code).

#take the first column without header
awk 'FNR>1 {print $1}' $1 > case_id

sed 's/A/ non-polar /
s/R/ charge /
s/N/ polar /
s/D/ charge /
s/C/ non-polar /
s/Q/ polar /
s/E/ charge /
s/G/ non-polar /
s/H/ polar /
s/I/ non-polar /
s/L/ non-polar /
s/K/ charge /
s/M/ non-polar /
s/F/ non-polar /
s/P/ non-polar /
s/S/ polar /
s/T/ polar /
s/W/ non-polar /
s/Y/ polar /
s/V/ non-polar /
s/*//g' case_id > tmp
paste -d' '  tmp case_id > output

#output should be "<physicochemical property of wildtype> <physicochemical property of mutant> <A111G>"

awk '{if ($1 == "non-polar"){print $0;}}' output > non_polar
awk '{if ($3 == "polar") {print $0, "polarity_gain";}}' non_polar > polarity_gain
awk '{if ($3 == "non-polar") {print $0, "no_change";}}' non_polar > NA
awk '{if ($3 == "charge") {print $0, "charge_gain";}}' non_polar > charge_gain

cat polarity_gain NA charge_gain > non_polar

awk '{if ($1 == "polar"){print $0;}}' output > polar
awk '{if ($3 == "polar") {print $0, "no_change";}}' polar > NA
awk '{if ($3 == "non-polar") {print $0, "polarity_loss";}}' polar > polarity_loss
awk '{if ($3 == "charge") {print $0, "charge_gain";}}' polar > charge_gain

cat charge_gain NA polarity_loss > polar

awk '{if ($1 == "charge"){print $0;}}' output > charge
awk '{if ($3 == "polar") {print $0, "charge_loss";}}' charge > charge_loss_polar
awk '{if ($3 == "non-polar") {print $0, "charge_loss";}}' charge > charge_loss
awk '{if ($3 == "charge") {print $0, "no_change";}}' charge > NA

cat charge_loss NA charge_loss_polar> charge

cat non_polar polar charge > tmp
sort -k4 tmp > tmp2
awk '{print $5}' tmp2 > physichem_label

echo "physicochem_class_change" > header
cat header physichem_label > physicochem_class_change

#add the column at the end of the dataset with paste
paste -d " " $1 physicochem_class_change > tmp
mv tmp $1
rm case_id output physichem_label header physicochem_class_change NA tmp* polar* charge* non*
