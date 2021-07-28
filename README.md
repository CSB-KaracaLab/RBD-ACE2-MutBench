# ACE2 - RBD point mutation benchmark 
Benchmarking the structure-based binding energy predictors on human ACE2 - SARS-CoV-2 RBD binding data set.

## Motivation

Accurate prediction of binding energy change is a question of utmost importance in computational structural biology. There are many approaches developed to this aim to unveil the molecular mechanism underlying binding of two molecules and developing new therapeutic binders. In our study, we benchmarked 5 structure-based binding energy predictors; HADDOCK, FoldX, EvoEF1, MutaBind2 and SSIPe on the ACE2-RBD binding affinity data set. Further we added FoldX with water option (FoldXwater) to contribute water mediated hydrogen bonds in the interface. Thus we benchmarked six different approaches on the dataset that consist of 263 interface-point mutations. We presented prediction performance of the six approaches in this study. Additionally we assessed predictors' nature by using six different metrics which related to amino acid change upon point mutation; van der Waals volume, hydrophobicity, flexibility, physicochemical property and position in the interface.


Presenting prediction performance of binding energy predictors is crucial to reveal what we can do with computationally inexpensive and fast methods in the case of future pandemics.

## The directory structure of the repository

We released the study's files in a structured folder organization. We stored output files of six predictors (Raw data) in Drive due to limitations of GitHub storage quotas. 263 point mutated ACE2-RBD protein complexes and corresponding binding affinity values are available on this **link**. Assorted scripts related to the study were stored at the 'Scripts etc' folder. Shell scripting was used for automatization of mutation generation and file manipulation. Python notebook used for figure generation, performance and metric analyses. 'Output files' folder contains various output files of assorted scripts of the study. The purpose of the scripts and definition of output files explained in detail at the below.


<img src="file_content.png" alt="main" width="600" />

### Scripts etc

#### Shell scripts

- *run_EvoEF1.csh*:
- *run_FoldX.csh*:
- *run_FoldXwater.csh*:
- *get_experimental_values.csh*:
- *get_HADDOCK_Prepared_dataset.csh*:
- *get_FoldX_Prepared_dataset.csh*:
- *get_FoldXwater_Prepared_dataset.csh*:
- *get_EvoEF1_Prepared_dataset.csh*:
- *get_MutaBind2_Prepared_dataset.csh*:
- *get_SSIPe_Prepared_dataset.csh*:
- *volume_change.sh*:
- *hydrophobicity_change.sh*:
- *flexibility_change.sh*:
- *physicochemical_class_change.sh*:
- *UEP_ACE2-RBD_common_case_selection.csh*:
- *plot_dataset_physicochemical_class_change.csh*:
- *plot_dataset_volume_hydrophobicity_flexibility.csh*:

#### Python notebooks
- *Performance_calculation.ipynb*:
- *UEP_performans_calculation.ipynb*:
- *Metric_volume_hydrophobicity_flexibility_change.ipynb*:
- *Metric_physicochemical_class_change.ipynb*:


### Output files

- *reference*:
- *ACE2_Experimental_dataset.csv*:
- *RBD_Experimental_dataset.csv*:
- *HADDOCK_Prepared_dataset.csv*:
- *FoldX_Prepared_dataset.csv*:
- *FoldXwater_Prepared_dataset.csv*:
- *EvoEF1_Prepared_dataset.csv*:
- *MutaBind2_Prepared_dataset.csv*:
- *SSIPe_Prepared_dataset.csv*:
- *Prediction_performances.txt*:
- *Enriched_Success_dataset*:
- *Enriched_Failure_dataset*:
- *Depleted_Success_dataset*:
- *Depleted_Failure_dataset*:
- *Volume_hydrophobicity_flexibility_change_figure.svg*:
- *dataset_physicochemical_class_change.csv*:
- *Physicochemical_class_change_performances.txt*:
- *Physicochemical_class_change_ratios.txt*:
- *Physicochemical_class_change_figure.svg*:
- *UEP_ACE2-RBD_common_dataset.csv*:
- *HADDOCK_UEP_Prepared_dataset.csv*:
- *FoldX_UEP_Prepared_dataset.csv*:
- *FoldXwater_UEP_Prepared_dataset.csv*:
- *EvoEF1_UEP_Prepared_dataset.csv*:
- *MutaBind2_UEP_Prepared_dataset.csv*:
- *SSIPe_UEP_Prepared_dataset.csv*:
- *Performances_on_highly-packed_dataset_UEP.txt*:


## Clone the repository
```
git clone https://github.com/CSB-KaracaLab/ace2-rbd-point-mutation-benchmark
```
## License

## Contact
ezgi.karaca@ibg.edu.tr
