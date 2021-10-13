# ACE2 - RBD point mutation benchmark 
Benchmarking the structure-based binding energy predictors on human ACE2 - SARS-CoV-2 RBD binding data set.

## Motivation

Accurate prediction of binding energy change is a question of utmost importance in computational structural biology. There are many approaches developed to this aim to unveil the molecular mechanism underlying binding of two molecules and developing new therapeutic binders. In our study, we benchmarked 5 structure-based binding energy predictors; HADDOCK, FoldX, EvoEF1, MutaBind2 and SSIPe on the ACE2-RBD binding affinity dataset. Further we added FoldX with water option (FoldXwater) to contribute water mediated hydrogen bonds in the interface. Thus we benchmarked six different approaches on the dataset that consist of 263 interface-point mutations. We presented prediction performance of the six approaches in this study. Additionally we assessed predictors' nature by using five different metrics which related to amino acid change upon point mutation; van der Waals volume, hydrophobicity, flexibility, physicochemical property and position in the interface.


Presenting prediction performance of binding energy predictors is crucial to reveal what we can do with computationally inexpensive and fast methods in the case of future pandemics.

## The directory structure of the repository

We released the study's files in a structured folder organization. We stored study related files as input and ouput files. Input files contain only binding energy outputs of predictors and experimental dataset. Raw data of six predictors were stored at Drive due to limitations of GitHub storage quotas. 263 point mutated ACE2-RBD protein complexes and corresponding binding affinity values are available on this [*link*](https://drive.google.com/drive/u/1/folders/1Gfyen1dTXD25WPKyAPDmQdzrbAEhW3cq). 

Assorted scripts related to the study were stored at the 'scripts' folder. Shell scripting was used for automatization of mutation generation and file manipulation -generating input files of study. Python notebooks were used for figure generation, performance and metric analyses. Generated figures and benchmarking dataset stored at 'output files' folder. The purpose of the scripts and the description of output files explained in detail at the below.


<img src="file_content.png" alt="main" width="600" />

### Scripts etc

There is two kinds of shell scripts. The first one is run scripts, these scripts used for automatization of mutation generation of standalone tools. We generated FoldX and EvoEF1 models by using these scripts. HADDOKC, MutaBind2, and SSIPe models produced via their web server. Lastly UEP is a standalone tool which is produce all possible mutations at once -no need automatization. 

The second is get scripts, these scripts used for grepping predicted binding energy values from output files of predictor. 
#### Shell scripts

- *run_EvoEF1.csh*: Builds single amino acid mutations and computes binding affinity by using EvoEF1.
- *run_FoldX.csh*: Builds single amino acid mutations and computes binding affinity by using FoldX (FoldX commands: Repair, BuildModel, AnalyseComplex).
- *run_FoldXwater.csh*: Builds single amino acid mutations and computes binding affinity by using FoldX (FoldX commands: Repair, BuildModel, AnalyseComplex with water)
- *get_HADDOCK_scores.csh*
- *get_FoldX_scores.csh*
- *get_FoldXwater_scores.csh*
- *get_EvoEF1_scores.csh*
- *get_MutaBind2_scores.csh*
- *get_SSIPe_scores.csh*
-
-rwxr-xr-x  1 edasamiloglu  staff   935 29 Eyl 09:49 
-rwxr-xr-x  1 edasamiloglu  staff  1149 29 Eyl 09:50 get_SSIPe_scores.csh
-rwxr-xr-x  1 edasamiloglu  staff  3176 29 Eyl 10:00 get_UEP_scores.csh



#### Python notebooks


### Output files



## Clone the repository
```
git clone https://github.com/CSB-KaracaLab/ace2-rbd-point-mutation-benchmark
```
## License

## Acknowledgements

## Contact
ezgi.karaca@ibg.edu.tr
