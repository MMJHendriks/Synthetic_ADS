This repository serves as research archive for the Master's thesis 'MICE to Synthesize: Generating Synthetic Data Sets with MICE for the Analysis of Private Data' by Mirthe Hendriks. The aim of this thesis is to establish a proof-of-concept for generating high-quality partially synthetic data with multiple imputations in MICE for the analysis of privacy-sensitive data.

**Abstract**

The aim of this paper is to present a proof-of-concept for generating high-quality partially synthetic data with multiple imputations in MICE for the analysis of privacy-sensitive data. The synthetic data framework finds its foundation in the multiple imputation of missing data, originally proposed by Rubin (1987; 1993) and Little (1993). We conduct a Monte Carlo simulation to generate synthetic data, by overimputing observed values with multiple draws from the posterior predictive distribution. 
    We found that synthetic data generated with CART in MICE yields unbiased and confidence valid estimates in different scenarios given suitable pooling rules. The simulation study shows that, with the use of CART as an appropriate imputation method, the synthetic data (1) preserves the univariate statistical properties, and (2) yields the same multivariate statistical inferences as the observed data. Moreover, the synthetic data seems to be indistinguishable from the observed data. We therefore conclude that the MICE algorithm appears able to perform well in generating high-quality synthetic data. The results are promising, especially with regard to the practical implications of easily accessible synthetic data on privacy-preservation in data ownership and sharing.

**Contents**

The thesis manunuscript is named [Thesis_SyntheticDataMICE_MHendriks](docs/Thesis_SyntheticDataMICE_MHendriks) There is a seperate bib file for the [references](docs/References.bib). 

This research archive contains all files that are used in the current simulation study to generate synthetic data with the R-package MICE (Van Buuren and Groothuis-Oudshoorn,  2011, version  3.13) in R (R Core Team, 2021, version 4.0.4). First, in the folder [Data](https://github.com/MMJHendriks/Synthetic_ADS/tree/main/SimulationStudy_MHendriks/Data) you can find the data set used in this simulation study, the [Pima Indians Diabetes](https://github.com/MMJHendriks/Synthetic_ADS/blob/main/SimulationStudy_MHendriks/Data/diabetes.csv) (PID) database originally from the National Institute of Diabetes and Digestive and Kidney Diseases (2016). This data set is also publicly available at https://www.kaggle.com/uciml/pima-indians-diabetes-database. Additionally, you can find the [Ethical and legal considerations of the data](https://github.com/MMJHendriks/Synthetic_ADS/blob/main/SimulationStudy_MHendriks/Data/Ethical%20and%20legal%20considerations%20of%20the%20data). 

The [Code](https://github.com/MMJHendriks/Synthetic_ADS/tree/main/SimulationStudy_MHendriks/Code) folder contains all of the R code necessary to reproduce the simulation study. 
The  simulation  is  performed  for  two  scenarios. In  the  first  scenario, the values of zero (i.e. NAs) in the PID database are imputed once with MICE to create a complete data set. In the second scenario, the values of zero are not imputed, instead we consider the semicontinuous data. See section 2.1 in the manuscript for more explanation. Therefore, we have:

* [1. Data import and analysis model_scenario1 impute data.R](https://github.com/MMJHendriks/Synthetic_ADS/blob/main/SimulationStudy_MHendriks/Code/1.%20Data%20import%20and%20analysis%20model_scenario1%20impute%20data.R)
* [1. Data import and analysis model_scenario2 NA not imputed.R](https://github.com/MMJHendriks/Synthetic_ADS/blob/main/SimulationStudy_MHendriks/Code/1.%20Data%20import%20and%20analysis%20model_scenario2%20NA%20not%20imputed.R)

With this data you can 2. generate, 3. evaluate, and 4. predict the synthetic data for the complete PID data:
* [2. Generate synthetic data_complete PID.R](https://github.com/MMJHendriks/Synthetic_ADS/blob/main/SimulationStudy_MHendriks/Code/2.%20Generate%20synthetic%20data_complete%20PID.R)
* [3. Evaluation synthetic data_complete PID.R](https://github.com/MMJHendriks/Synthetic_ADS/blob/main/SimulationStudy_MHendriks/Code/3.%20Evaluation%20synthetic%20data_complete%20PID.R)
* [4. Prediction synthetic data_complete PID.R](https://github.com/MMJHendriks/Synthetic_ADS/blob/main/SimulationStudy_MHendriks/Code/4.%20Prediction%20synthetic%20data_complete%20PID.R)

And 5. generate, 6. evaluate, and 7. predict the synthetic data for a boostrapped sample of the PID data:
* [5. Generate synthetic data_bootstrapped sample.R](https://github.com/MMJHendriks/Synthetic_ADS/blob/main/SimulationStudy_MHendriks/Code/5.%20Generate%20synthetic%20data_bootstrapped%20sample.R)
* [6. Evaluation synthetic data_bootstrapped sample.R](https://github.com/MMJHendriks/Synthetic_ADS/blob/main/SimulationStudy_MHendriks/Code/6.%20Evaluation%20synthetic%20data_bootstrapped%20sample.R)
* [7. Prediction synthetic data_bootstrapped sample.R](https://github.com/MMJHendriks/Synthetic_ADS/blob/main/SimulationStudy_MHendriks/Code/7.%20Prediction%20synthetic%20data_bootstrapped%20sample.R)

To run the code, some additional [functions](https://github.com/MMJHendriks/Synthetic_ADS/blob/main/SimulationStudy_MHendriks/Code/SyntheticData_functions.R) are required, these  functions were originally written by [(Volker,  2021)](https://github.com/amices/Federated_imputation/blob/master/mice_synthesizing/simulations/functions.R).

For a quick overview of the structure of the simulation study, you might look at the [Flowchart of the simulation study](https://github.com/MMJHendriks/Synthetic_ADS/blob/main/SimulationStudy_MHendriks/Flowchart%20simulation.PNG) (Figure 1 in the manuscript). 

The [Workspaces](https://github.com/MMJHendriks/Synthetic_ADS/tree/main/SimulationStudy_MHendriks/Workspaces) folder is currently empty, because the saved workspaces were too large to upload. This folder might still be used by others to upload their workspaces.

For this reason, I did upload the [Output](https://github.com/MMJHendriks/Synthetic_ADS/tree/main/SimulationStudy_MHendriks/Output) of the simulation study for both scenarios in the form of two html knits [SyntheticData_simulation_scenario1imputed.html](https://github.com/MMJHendriks/Synthetic_ADS/blob/main/SimulationStudy_MHendriks/Output/SyntheticData_simulation_scenario1imputed.html) and [SyntheticData_simulation_scenario2notimputed.html](https://github.com/MMJHendriks/Synthetic_ADS/blob/main/SimulationStudy_MHendriks/Output/SyntheticData_simulation_scenario2notimputed.html). 

**Permission and access**

The entire research archive is available through https://github.com/MMJHendriks/Synthetic_ADS/edit/main/SimulationStudy_MHendriks. The Github repository is public, and therefore completely 'open access'.

- Mirthe Hendriks, 2-7-2021
