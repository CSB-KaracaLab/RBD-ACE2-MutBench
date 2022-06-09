import argparse
import json
import pathlib
import csv


def old_csv_to_new_csv(oldCsvFilePath, newCsvFilePath):
    with open(newCsvFilePath, 'w') as f2:
        fields = ['Names', 'HADDOCK', 'FoldX', 'FoldXwater', 'EvoEF1', 'MutaBind2', 'SSIPe']
        writer=csv.DictWriter(f2,fieldnames=fields)
        writer.writeheader()
        with open(oldCsvFilePath, mode='r') as infile:
            reader = csv.reader(infile)
            for i,rows in enumerate(reader):
                if i == 0:
                    header = rows
                    print(rows)
                else:
                    writer.writerow({'Names': str(rows[2]+"_"+rows[0]), 
                                    'HADDOCK': rows[3],
                                    'FoldX': rows[4],
                                    'FoldXwater': rows[5],
                                    'EvoEF1': rows[6],
                                    'MutaBind2': rows[7],
                                    'SSIPe': rows[8]})
                    
        f2.close()


def csv_to_json(csvFilePath, jsonFilePath):
    jsonArray = []
      
    #read csv file
    with open(csvFilePath, encoding='utf-8') as csvf: 
        #load csv file data using csv library's dictionary reader
        csvReader = csv.DictReader(csvf) 

        #convert each csv row into python dict
        for row in csvReader: 
            #add this python dict to json array
            jsonArray.append(row)
  
    #convert python jsonArray to JSON String and write to file
    with open(jsonFilePath, 'w', encoding='utf-8') as jsonf: 
        jsonString = json.dumps(jsonArray, indent=4)
        jsonf.write(jsonString)



oldCsvFilePath ='C:\\Users\\nzmye\\Documents\\Projects\\ace2-rbd-point-mutation-benchmark\\visualize\\models\\SARS-CoV-2-RBD_ACE2_benchmarking_dataset.csv'
newCsvFilePath = 'C:\\Users\\nzmye\\Documents\\Projects\\ace2-rbd-point-mutation-benchmark\\visualize\\models\\SARS-CoV-2-RBD_ACE2_benchmarking_dataset_newFormat.csv'
jsonFilePath = 'C:\\Users\\nzmye\\Documents\\Projects\\ace2-rbd-point-mutation-benchmark\\visualize\\models\\models.json'
old_csv_to_new_csv(oldCsvFilePath, newCsvFilePath)
csv_to_json(newCsvFilePath, jsonFilePath)
