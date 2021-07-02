This repository serves as research archive for the Master's thesis 'MICE to Synthesize: Generating Synthetic Data Sets with MICE for the Analysis of Private Data' by Mirthe Hendriks. The aim of this thesis is to establish a proof-of-concept for generating high-quality partially synthetic data with multiple imputations in MICE for the analysis of privacy-sensitive data.

**Abstract**

The aim of this paper is to present a proof-of-concept for generating high-quality partially synthetic data with multiple imputations in MICE for the analysis of privacy-sensitive data. The synthetic data framework finds its foundation in the multiple imputation of missing data, originally proposed by Rubin (1987; 1993) and Little (1993). We conduct a Monte Carlo simulation to generate synthetic data, by overimputing observed values with multiple draws from the posterior predictive distribution. 
    We found that synthetic data generated with CART in MICE yields unbiased and confidence valid estimates in different scenarios given suitable pooling rules. The simulation study shows that, with the use of CART as an appropriate imputation method, the synthetic data (1) preserves the univariate statistical properties, and (2) yields the same multivariate statistical inferences as the observed data. Moreover, the synthetic data seems to be indistinguishable from the observed data. We therefore conclude that the MICE algorithm appears able to perform well in generating high-quality synthetic data. The results are promising, especially with regard to the practical implications of easily accessible synthetic data on privacy-preservation in data ownership and sharing.

**Contents**

The thesis manunuscript is named [Thesis_SyntheticDataMICE_MHendriks](docs/Thesis_SyntheticDataMICE_MHendriks) There is a seperate bib file for the [references](docs/References.bib). 

This research archive contains all files that are used in the current simulation study to generate synthetic data with the R-package MICE (Van Buuren and Groothuis-Oudshoorn,  2011, version  3.13) in R (R Core Team, 2021, version 4.0.4). First, in the folder [Data](docs/Data) you can find the data set used in this simulation study, the [Pima Indians Diabetes](docs/diabetes.csv) (PID) database originally from the National Institute of Diabetes and Digestive and Kidney Diseases (2016). This data set is also publicly available at https://www.kaggle.com/uciml/pima-indians-diabetes-database. Additionally, you can find the [Ethical and legal considerations of the data](docs/Ethical and legal considerations of the data). 

The [Code](docs/Code) folder contains all of the R code necessary to reproduce the simulation study. 
The  simulation  is  performed  for  two  scenarios. In  the  first  scenario, the values of zero (i.e. NAs) in the PID database are imputed once with MICE to create a complete data set. In the second scenario, the values of zero are not imputed, instead we consider the semicontinuous data. See section 2.1 in the manuscript for more explanation. Therefore, we have:

[1. Data import and analysis model_scenario1 impute data.R](docs/1. Data import and analysis model_scenario1 impute data.R)
[1. Data import and analysis model_scenario2 NA not imputed.R](https://github.com/MMJHendriks/Synthetic_ADS/blob/main/SimulationStudy_MHendriks/Code/1.%20Data%20import%20and%20analysis%20model_scenario2%20NA%20not%20imputed.R)

Currently the [Workspaces](docs/Workspaces) folder is empty, because the saved workspaces were too large to upload. 

**Permission and access**

The entire research archive is available through https://github.com/MMJHendriks/Synthetic_ADS/edit/main/SimulationStudy_MHendriks. The Github repository is public, and therefore completely 'open access'.

- Mirthe Hendriks, 2-7-2021
