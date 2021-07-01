# Load (potentially) required packages
library(mice)     # data imputation
library(magrittr) # piping 
library(dplyr)    # data manipulation
library(purrr)    # functional programming
library(furrr)    # parallel mapping
library(tidyr)    # tidy data 
library(tidyverse)# tidy packages
library(tibble)   # data formats
library(caret)    # classification and regression trees
library(mboost)   # for prediction model with method glmboost for classification 
library(broom)    # tidy tibbles
library(corrplot) # correlation plot 
library(ggplot2)  # plots
library(DT)       # tables

# All code is run two different data scenarios; scenario 1 the values of zero (i.e. NAs) in the PID dataset are imputed 
# scenario 2; the values of zero are not imputed, but taken to be part of the data. See paper for more explanation.
load("Workspaces/1.1 Data import and analysis model_scenario1 impute data.RData")
#OR 
#load("Workspaces/2.1 Data import and analysis model__scenario2 NA not imputed.RData")


#Fix random seed. In this simulation study, we will be using random numbers. 
#We set the seed of the random number generator in order to be able to reproduce the results.
set.seed(123) 

#Let us define the number of simulations for this Monte Carlo experiment.
nsim = 1000

### Generate synthetic data 
plan(multisession)

# 1. PMM method 
#specify pmm method
meth <- make.method(truedata)
meth <- rep('pmm',ncol(truedata))  
names(meth) <- colnames(truedata)
meth['Outcome'] <- 'logreg'
#specify predictor matrix 
pred <- make.predictorMatrix(truedata)

#generate synthetic data PMM
syn_pmm <- future_map(1:nsim, function(x){
  mice(truedata,
       m=5,
       method = meth,
       predictorMatrix = pred,
       where=matrix(TRUE, nrow(truedata), ncol(truedata)),
       print=FALSE)},
  .options=future_options(seed=as.integer(123)), .progress=TRUE)

# 2. CART method
#generate synthetic data cp 1e-4
syn_cart_m <- future_map(1:nsim, function(x){
  mice(truedata, 
       m=5, 
       meth = "cart", 
       where = matrix(TRUE, nrow(truedata), ncol(truedata)), 
       cp = 0.0001,
       minbucket = 3,
       print = FALSE)}, 
  .options = furrr_options(seed = as.integer(123)), .progress = T)

#generate synthetic data cp 1e-32
syn_cart_cpm <- future_map(1:nsim, function(x){
  mice(truedata, 
       m=5, 
       meth = "cart", 
       where = matrix(TRUE, nrow(truedata), ncol(truedata)), 
       cp = 1e-32,
       minbucket = 3,
       print = FALSE)}, 
  .options = furrr_options(seed = as.integer(123)), .progress = T)

SynData_imp_complete <- list(syn_pmm = syn_pmm, syn_cart_m = syn_cart_m, syn_cart_cpm = syn_cart_cpm)

save(SynData_imp_complete, file = "Workspaces/1.2 Generate synthetic data_complete PID.Rdata")
#OR scenario 2
#save(SynData_imp_complete, file = "Workspaces/2.2 Generate synthetic data_complete PID.Rdata")
