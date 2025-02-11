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
library(psych)    # rounding
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

### Generate synthetic data for the bootstrapped sample of the PID dataset
# In addition, we also generate synthetic data with CART based on a boostrapped sample of the 
# PID dataset. Using a bootstrapped sample is a method to mimic a sampling from a population. 
# In reality, when we would want to synthesize data, this data will most likely be a 
# sample from a population. Thus, bootstrapping is a method to evaluate how the 
# imputation method would perform in practice. We test multiple parameter specifications for CART: 
# cp fixed at 1e-4 and 1e-32, and the number of iterations maxit at 1 or default 5, for minbucket set to 3.

plan(multisession)

synboot_cart_m <- future_map(1:nsim, function(x){
  mice(truedata[sample(1:768, 768, replace = TRUE), ], 
       m=5, 
       meth = "cart", 
       where = matrix(TRUE, nrow(truedata), ncol(truedata)), 
       cp = 0.0001,
       minbucket = 3,
       print = FALSE)}, 
  .options = furrr_options(seed = as.integer(123)), .progress = T)

synboot_cart_cpm <- future_map(1:nsim, function(x){
  mice(truedata[sample(1:768, 768, replace = TRUE), ],
       m=5, 
       meth = "cart", 
       where = matrix(TRUE, nrow(truedata), ncol(truedata)), 
       cp = 1e-32,
       minbucket = 3,
       print = FALSE)}, 
  .options = furrr_options(seed = as.integer(123)), .progress = T)

synboot_cart_mmx1 <- future_map(1:nsim, function(x){
  mice(truedata[sample(1:768, 768, replace = TRUE), ], 
       m=5,
       maxit = 1,
       meth = "cart", 
       where = matrix(TRUE, nrow(truedata), ncol(truedata)), 
       cp = 0.0001,
       minbucket = 3,
       print = FALSE)}, 
  .options = furrr_options(seed = as.integer(123)), .progress = T)

synboot_cart_cpmmx1 <- future_map(1:nsim, function(x){
  mice(truedata[sample(1:768, 768, replace = TRUE), ], 
       m=5,
       maxit = 1,
       meth = "cart", 
       where = matrix(TRUE, nrow(truedata), ncol(truedata)), 
       cp = 1e-32,
       minbucket = 3,
       print = FALSE)}, 
  .options = furrr_options(seed = as.integer(123)), .progress = T)

SynData_boot <- list(synboot_cart_m = synboot_cart_m, synboot_cart_cpm = synboot_cart_cpm, 
                     synboot_cart_mmx1 = synboot_cart_mmx1, synboot_cart_cpmmx1 = synboot_cart_cpmmx1)

save(SynData_boot, file = "Workspaces/1.5 Generate synthetic data_bootstrapped sample.Rdata")
#OR scenario 2
#save(SynData_boot, file = "Workspaces/2.5 Generate synthetic data_bootstrapped sample.Rdata")