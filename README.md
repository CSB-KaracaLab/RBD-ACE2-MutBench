# ACE2 - RBD point mutation benchmark 
Benchmarking the structure-based binding energy predictors on human ACE2 - SARS-CoV-2 RBD binding data set.

## Motivation

Accurate prediction of binding energy change is a question of utmost importance in computational structural biology. There are many approaches developed to this aim to unveil the molecular mechanism underlying binding of two molecules and developing new therapeutic binders. In our study, we benchmarked 5 structure-based binding energy predictors; HADDOCK, FoldX, EvoEF1, MutaBind2 and SSIPe on the ACE2-RBD binding affinity data set. Further we added FoldX with water option (FoldXwater) to contribute water mediated hydrogen bonds in the interface. Thus we benchmarked six different approaches on the dataset that consist of 263 interface-point mutations. We presented prediction performance of the six approaches in this study. Additionally we assessed predictors' nature by using six different metrics which related to amino acid change upon point mutation; van der Waals volume, hydrophobicity, flexibility, physicochemical property and position in the interface.


Presenting prediction performance of binding energy predictors is crucial to reveal what we can do with computationally inexpensive and fast methods in the case of future pandemics.

## The directory structure of the repository

We released the study's files in a structured folder organization. We stored output files of six predictors (Raw data) in Drive due to limitations of GitHub storage quotas. 263 point mutated ACE2-RBD protein complexes and corresponding binding affinity values are available on this *link*. Assorted scripts related to the study were stored at the 'Scripts etc' folder. Shell scripting was used for automatization of mutation generation and file manipulation. Python notebook used for figure generation, performance and metric analyses. 'Output files' folder contains various output files of assorted scripts of the study. The purpose of the scripts and the description of output files explained in detail at the below.


<img src="file_content.png" alt="main" width="600" />

### Scripts etc
#### Shell scripts

- *run_EvoEF1.csh*: Builds single amino acid mutations and compute binding affinity by using EvoEF1.
- *run_FoldX.csh*: Builds single amino acid mutations and compute binding affinity by using FoldX (FoldX commands: Repair, BuildModel, AnalyseComplex).
- *run_FoldXwater.csh*: Builds single amino acid mutations and compute binding affinity by using FoldX (FoldX commands: Repair, BuildModel, AnalyseComplex with water)
- *get_experimental_values.csh*: This script selects 263 mutations that were used in the study from binding affinity datasets of RBD and ACE2. 
- *get_HADDOCK_Prepared_dataset.csh*: Prepares HADDOCK dataset of the study from HADDOCK raw data. 
- *get_FoldX_Prepared_dataset.csh*: Prepared FoldX dataset of the study from FoldX raw data. 
- *get_FoldXwater_Prepared_dataset.csh*: Prepared FoldXwater dataset of the study from FoldXwater raw data.
- *get_EvoEF1_Prepared_dataset.csh*: Prepared EvoEF1 dataset of the study from EvoEF1 raw data.
- *get_MutaBind2_Prepared_dataset.csh*: Prepared MutaBind2 dataset of the study from MutaBind2 raw data.
- *get_SSIPe_Prepared_dataset.csh*: Prepared SSIPe dataset of the study from SSIPe raw data.
- *volume_change.sh*: Calculates van der Waals volume changes of amino acid due to point mutation.
- *hydrophobicity_change.sh*: Calculates hydrophobicity changes of amino acid due to point mutation.
- *flexibility_change.sh*: Calculates flexibility changes of amino acid due to point mutation.
- *physicochemical_class_change.sh*: Presents physicochemical class change of amino acid due to point mutation. 
- *UEP_ACE2-RBD_common_case_selection.csh*: UEP is a stand alone tool that we used for determine highly-packed residues. This script selects intersected cases between our dataset (263) and UEP suggested dataset (Raw data). 
- *plot_dataset_volume_hydrophobicity_flexibility.csh*: Prepares the datasets that used to create figure of volume, hydrophobicity, flexibility metrics.
- *plot_dataset_physicochemical_class_change.csh*: Prepares the dataset that used to create figure of physicochemical class metric.


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

## Acknowledgements

## Contact
ezgi.karaca@ibg.edu.tr
