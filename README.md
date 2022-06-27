![gitub-sars-cov-2](https://user-images.githubusercontent.com/64282221/163183191-17baa15b-f599-4857-abcb-2bd009dadcf5.png)
Benchmarking the Widely Used Structure-based Binding Affinity Predictors on the Spike-ACE2 Deep Mutational Interaction Set

## Motivation

Since the start of COVID-19 pandemic, a huge effort has been devoted to understanding the Spike(SARS-CoV-2)-ACE2 recognition mechanism. As prominent examples, two deep mutational scanning (DMS) studies (Chan et al., 2020; Starr et al., 2020) traced the impact of all possible mutations/variants across the Spike-ACE2 interface. Expanding on this, we benchmark four widely used structure-based binding affinity predictors (FoldX, EvoEF1, MutaBind2, SSIPe) and two naïve predictors (HADDOCK, UEP) on the variant Spike-ACE2 deep mutational interaction set. Among these approaches, FoldX ranks first with a 64% success rate, followed by EvoEF1 with a 57% accuracy. Upon performing residue-based analyses, we reveal critical algorithmic biases, especially in ranking mutations with increasing/decreasing hydrophobicity/volume. We also show that the approaches using evolutionary-based terms in their scoring functions misclassify most mutations as binding depleting. These observations suggest plenty of room to improve the conventional affinity predictors for guessing the variant-induced binding profile changes of Spike-ACE2. 

For more, please check our preprint [![DOI:10.1101/2022.04.18.488633](https://img.shields.io/badge/DOI-10.1101/2022.04.18.488633-B31B1B.svg)](https://doi.org/10.1101/2022.04.18.488633) and the related files, as outlined below:

Our mutants models and their prediction scores can be visualized at https://rbd-ace2-mutbench.github.io/

## Folder organization of our repository:

In this work, we used the stand-alone packages of [FoldX](http://foldxsuite.crg.eu/products#foldx),[EvoEF1](https://github.com/tommyhuangthu/EvoEF) and [UEP](https://github.com/pepamengual/UEP) and run [HADDOCK](https://alcazar.science.uu.nl/services/HADDOCK2.2/), [MutaBind2](https://lilab.jysw.suda.edu.cn/research/mutabind2/), and [SSIPe](https://zhanggroup.org/SSIPe/) by using the relevant services to generate mutant models and their scores.  

### input-output-files/

#### input files
The mutations are imposed on RBD-ACE2 complex with PDB ID: 6m0j
  - *ACE2_Experimental_dataset.csv*: DMS binding values of ACE2 179 point mutations.
  - *RBD_Experimental_dataset.csv*: DMS binding values of 84 RBD point mutations.
  - *HADDOCK_scores.csv* & *FoldX_scores.csv* & *FoldXwater_scores.csv* & *EvoEF1_scores.csv*: HADDOCK, FoldX, FoldXwater, and EvoEF1 mutant scores (263 mutations) + 6m0j wild-type score.
  - *MutaBind2_scores.csv* & *SSIPe_result.txt* & *6m0j_UEP_A_E.csv*: Predicted ∆∆G changes of each mutation.
  
#### output files

  - *SARS-CoV-2-RBD_ACE2_benchmarking_dataset.csv*: Predicted affinity change scores (∆∆G) of each predictor. 
  - *UEP_SARS-CoV-2-RBD_ACE2_benchmarking_dataset.csv*: UEP calculates ∆∆G when the position of interest has interactions with at least two other residues (highly packed residues within 5Å range). This is a subset of the main prediction scores with 129 mutations (82 ACE2, 47 Spike-RBD mutations).


### Scripts

run_<predictor> scripts were used to generate FoldX and EvoEF1 models, automatically. 

#### Shell scripts

- *run_FoldX.csh*: Applies single amino acid mutations and computes binding affinity by using FoldX. (Called FoldX commands: Repair, BuildModel, AnalyseComplex).
- *run_FoldXwater.csh*: The same as above by using FoldX with water option. 
- *run_EvoEF1.csh*: Applies single amino acid mutations and computes binding affinity by using EvoEF1. (Called EvoEF1 commands: RepairStructure, BuildMutant, ComputeBinding).
- *get_HADDOCK_scores.csh*: Greps the predicted HADDOCK energy scores from the HADDOCK energy files.

#### Notebooks
  
  - *creating_benchmarking_datasets.ipynb*: Creates SARS_CoV_2_RBD_ACE2_benchmarking_dataset.csv and UEP_SARS_CoV_2_RBD_ACE2_benchmarking_dataset.csv files. 
  - *performance_analysis.ipynb*: Calculates success rates of predictors by using SARS_CoV_2_RBD_ACE2_benchmarking_dataset.csv and UEP_SARS_CoV_2_RBD_ACE2_benchmarking_dataset.csv files.
  - *metric_analyses_figure_preparation.ipynb*: Performs metric analyses (volume, hydrophobicity, flexibility, and physicochemical property change upon a mutation) and visualizes the outputs as plots.


## Acknowledgements
All the calculations are carried out at the HPC resources of Izmir Biomedicine and Genome Center. 

## Contact
ezgi.karaca@ibg.edu.tr
  
## References
Chan,K.K., Dorosky,D., Sharma,P., Abbasi,S.A., Dye,J.M., Kranz,D.M., Herbert,A.S. and Procko,E. (2020) Engineering human ACE2 to optimize binding to the spike protein of SARS coronavirus 2. Science (1979), 369, 1261–1265.
Starr,T.N., Greaney,A.J., Hilton,S.K., Ellis,D., Crawford,K.H.D., Dingens,A.S., Navarro,M.J., Bowen,J.E., Tortorici,M.A., Walls,A.C., et al. (2020) Deep Mutational Scanning of SARS-CoV-2 Receptor Binding Domain Reveals Constraints on Folding and ACE2 Binding. Cell, 182, 1295-1310.e20.


