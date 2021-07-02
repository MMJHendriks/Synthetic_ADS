This repository serves as research archive for the Master's thesis 'MICE to Synthesize: Generating Synthetic Data Sets with MICE for the Analysis of Private Data' by Mirthe Hendriks.

**Abstract**

The aim of this paper is to present a proof-of-concept for generating high-quality partially synthetic data with multiple imputations in MICE for the analysis of privacy-sensitive data. The synthetic data framework finds its foundation in the multiple imputation of missing data, originally proposed by Rubin (1987; 1993) and Little (1993). We conduct a Monte Carlo simulation to generate synthetic data, by overimputing observed values with multiple draws from the posterior predictive distribution. 
    We found that synthetic data generated with CART in MICE yields unbiased and confidence valid estimates in different scenarios given suitable pooling rules. The simulation study shows that, with the use of CART as an appropriate imputation method, the synthetic data (1) preserves the univariate statistical properties, and (2) yields the same multivariate statistical inferences as the observed data. Moreover, the synthetic data seems to be indistinguishable from the observed data. We therefore conclude that the MICE algorithm appears able to perform well in generating high-quality synthetic data. The results are promising, especially with regard to the practical implications of easily accessible synthetic data on privacy-preservation in data ownership and sharing.

**Contents**

The thesis manunuscript is named 

This folder contains all files that are used in the current study to generate synthetic data with the R-package mice. First, there are the .Rmd files synthesizing_partially_synthetic_data_rules.Rmd containing simulations and information on getting inferences 
[Code](docs/Code)

**Permission and access**

The entire research archive is available through https://github.com/MMJHendriks/Synthetic_ADS/edit/main/SimulationStudy_MHendriks. The Github repository is public, and therefore completely 'open access'.

- Mirthe Hendriks, 2-7-2021
