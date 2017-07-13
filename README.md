# General Psychotherapy Corpus Topic Modeling 

This code reads in psychotherapy sessions from the Alexander General Psychotherapy corpus and infers latent topics that are linked to the subjects and symptoms discussed in each session. The data is proprietary so we don't upload it. 

The main files are: 

```runlabeledlda.m``` which fits a labeled lda model to the data 
```run_LR.m``` which fits a logistic regression model to the data to predict subject and symptom labels
```model_evaluation.m``` 

 Gaut, G., Steyvers, M., Imel, Z., Atkins, D., & Smyth, P. (2015). Content coding of psychotherapy transcripts using labeled topic models. IEEE journal of biomedical and health informatics.


## Installation 

Before running the code, you will have to compile the following files: 

```GibbsSamplerLABELEDLDA.c```
```liblinear-2.11/matlab/train.c```
```liblinear-2.11/matlab/predict.c```

To compile `GibbsSamplerLABELEDLDA.c` type `mex GibbsSamplerLABELEDLDA.c` in the matlab console. You may have to set up a compatible mex compiler before executing this command. 

To compile the liblinear functions, move the `liblinear-2.11` directory and type `make` in the matlab console. 

## Dependencies

This code modified the Labeled LDA Gibbs sampling code from the MATLAB Topic Modeling Toolbox developed by Mark Steyvers and uses the LIBLINEAR package.  

Griffiths, T., & Steyvers, M. (2004).  Finding Scientific Topics. 
    Proceedings of the National Academy of Sciences, 101 (suppl. 1), 5228-5235.

R.-E. Fan, K.-W. Chang, C.-J. Hsieh, X.-R. Wang, and C.-J. Lin. LIBLINEAR: A library for large linear classification Journal of Machine Learning Research 9(2008), 1871-1874.

