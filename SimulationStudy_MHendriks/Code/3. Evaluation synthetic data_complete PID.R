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

load("Workspaces/1.2 Generate synthetic data_complete PID.Rdata")
#OR scenario 2
#load("Workspaces/2.2 Generate synthetic data_complete PID.Rdata")

#Fix random seed. In this simulation study, we will be using random numbers. 
#We set the seed of the random number generator in order to be able to reproduce the results.
set.seed(123) 

#Let us define the number of simulations for this Monte Carlo experiment.
nsim = 1000
plan(multisession)

### Evaluate the synthetic data
# After generating the synthetic datasets we pool the m parameter estimates into a 
# final point estimator with variance. You can find the function we use to pool the 
# synthetic estimates in source("SyntheticData_functions.R"). We use the pooling rules 
# for partially synthetic data as developed by Reiter (2003, p. 5). pool3.syn is a 
# function written by Volker (2021) based on the pooling rules and estimation of 
# variance specified by Reiter (2003, p. 5). Subsequently, we evaluate the pooled 
# synthetic estimates by calculating bias, confidence interval coverage (CIC) and 
# confidence interval width (CIW). The ci_cov function is specified in:
source("SyntheticData_functions.R")

column_names= c('True Est', 'Syn Est', 'Bias', 'CIW')

# 1. Multivariate statistical inferences

# evaluate synthetic data PMM
eval_syn_pmm <- syn_pmm %>%
  map(~.x %$% 
        glm(Outcome~BMI+Glucose+Pregnancies,family=binomial(link = "logit"))) %>%
  map_dfr(pool3.syn) %>%
  ci_cov(., model) %>% 
  datatable() %>% formatRound(columns=column_names,digits=4) %>% formatRound(columns='Coverage',digits=2)

# 2. evaluate synthetic data CART
eval_syn_cart_m <- syn_cart_m %>%
  map(~.x %$% 
        glm(Outcome~BMI+Glucose+Pregnancies,family=binomial(link = "logit"))) %>%
  map_dfr(pool3.syn) %>%
  ci_cov(., model) %>% 
  datatable() %>% formatRound(columns=column_names,digits=4) %>% formatRound(columns='Coverage',digits=2)

eval_syn_cart_cpm <- syn_cart_cpm %>%
  map(~.x %$% 
        glm(Outcome~BMI+Glucose+Pregnancies,family=binomial(link = "logit"))) %>%
  map_dfr(pool3.syn) %>%
  ci_cov(., model) %>% 
  datatable() %>% formatRound(columns=column_names,digits=4) %>% formatRound(columns='Coverage',digits=2)

# 2. Univariate statistical properties
uni <- syn_cart_m %>% 
  map(~.x %>% 
        complete("all") %>% 
        map(~.x %>% 
              describe()) %>% Reduce("+", .) / 5) %>%
  Reduce("+", .) / 1000
true <- describe(truedata)
uni_syn_cart_m <- (uni - true) %>% select(c("mean", "sd", "median", "skew", "kurtosis", "se")) %>% 
  datatable() %>% formatRound(columns=c('mean', 'sd','median', 'skew', 'kurtosis','se'), digits=4)

uni_cp <- syn_cart_cpm %>% #or syn_cart_m
  map(~.x %>% 
        complete("all") %>% 
        map(~.x %>% 
              describe()) %>% Reduce("+", .) / 5) %>%
  Reduce("+", .) / 1000
true <- describe(truedata)
uni_syn_cart_cpm <- (uni_cp - true) %>% select(c("mean", "sd", "median", "skew", "kurtosis", "se")) %>% 
  datatable() %>% formatRound(columns=c('mean', 'sd','median', 'skew', 'kurtosis','se'), digits=4)

Eval_SynData_complete <- list(eval_syn_pmm = eval_syn_pmm, eval_syn_cart_m = eval_syn_cart_m, eval_syn_cart_cpm = eval_syn_cart_cpm,
                                  uni_syn_cart_m = uni_syn_cart_m, uni_syn_cart_cpm = uni_syn_cart_cpm)

save(Eval_SynData_complete, file = "Workspaces/1.3 Evaluation synthetic data_complete PID.Rdata")
#OR scenario 2
#save(Eval_SynData_complete, file = "Workspaces/2.3 Evaluation synthetic data_complete PID.Rdata")
