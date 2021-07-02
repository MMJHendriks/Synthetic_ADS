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

load("Workspaces/1.5 Generate synthetic data_bootstrapped sample.Rdata")
#OR scenario 2
#load("Workspaces/2.5 Generate synthetic data_bootstrapped sample")

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

# evaluate synthetic data CART
eval_synboot_cart_m <- synboot_cart_m %>%
  map(~.x %$% 
        glm(Outcome~BMI+Glucose+Pregnancies,family=binomial(link = "logit"))) %>%
  map_dfr(pool3.syn) %>%
  ci_cov(., model) %>% 
  datatable() %>% formatRound(columns=column_names,digits=4) %>% formatRound(columns='Coverage',digits=2)

eval_synboot_cart_cpm <- synboot_cart_cpm %>%
  map(~.x %$% 
        glm(Outcome~BMI+Glucose+Pregnancies,family=binomial(link = "logit"))) %>%
  map_dfr(pool3.syn) %>%
  ci_cov(., model) %>% 
  datatable() %>% formatRound(columns=column_names,digits=4) %>% formatRound(columns='Coverage',digits=2)

eval_synboot_cart_mmx1 <- synboot_cart_mmx1 %>%
  map(~.x %$% 
        glm(Outcome~BMI+Glucose+Pregnancies,family=binomial(link = "logit"))) %>%
  map_dfr(pool3.syn) %>%
  ci_cov(., model) %>% 
  datatable() %>% formatRound(columns=column_names,digits=4) %>% formatRound(columns='Coverage',digits=2)

eval_synboot_cart_cpmmx1 <- synboot_cart_cpmmx1 %>%
  map(~.x %$% 
        glm(Outcome~BMI+Glucose+Pregnancies,family=binomial(link = "logit"))) %>%
  map_dfr(pool3.syn) %>%
  ci_cov(., model) %>% 
  datatable() %>% formatRound(columns=column_names,digits=4) %>% formatRound(columns='Coverage',digits=2)

# Try different pooling
  # Since some uncertainty remains about what pooling rules yield the correct inferences in practice, 
  # we also use Rubin's rules (1987) to pool the estimates. These different pooling rules 
  # do not change the synthetic estimates nor the bias, but the estimation of variance is different. 
  # Rubin's pooling rules capture the additional between synthetic data variance. 
eval2_synboot_cart_m <- synboot_cart_m %>%
  map(~.x %$% 
        glm(Outcome~BMI+Glucose+Pregnancies,family=binomial(link = "logit"))) %>%
  map_dfr(pool.normal) %>%
  ci_cov(., model) %>% 
  datatable() %>% formatRound(columns=column_names,digits=4) %>% formatRound(columns='Coverage',digits=2)

eval2_synboot_cart_cpm <-synboot_cart_cpm %>%
  map(~.x %$% 
        glm(Outcome~BMI+Glucose+Pregnancies,family=binomial(link = "logit"))) %>%
  map_dfr(pool.normal) %>%
  ci_cov(., model) %>% 
  datatable() %>% formatRound(columns=column_names,digits=4) %>% formatRound(columns='Coverage',digits=2)

eval2_synboot_cart_mmx1 <-synboot_cart_mmx1 %>%
  map(~.x %$% 
        glm(Outcome~BMI+Glucose+Pregnancies,family=binomial(link = "logit"))) %>%
  map_dfr(pool.normal) %>%
  ci_cov(., model) %>% 
  datatable() %>% formatRound(columns=column_names,digits=4) %>% formatRound(columns='Coverage',digits=2)

eval2_synboot_cart_cpmmx1 <-synboot_cart_cpmmx1 %>%
  map(~.x %$% 
        glm(Outcome~BMI+Glucose+Pregnancies,family=binomial(link = "logit"))) %>%
  map_dfr(pool.normal) %>%
  ci_cov(., model) %>% 
  datatable() %>% formatRound(columns=column_names,digits=4) %>% formatRound(columns='Coverage',digits=2)

# 2. Univariate statistical properties bootstrapped sample
uni <- synboot_cart_m %>% 
  map(~.x %>% 
        complete("all") %>% 
        map(~.x %>% 
              describe()) %>% Reduce("+", .) / 5) %>%
  Reduce("+", .) / 1000
true <- describe(truedata)
uni_synboot_cart_m <- (uni - true) %>% select(c("mean", "sd", "median", "skew", "kurtosis", "se")) %>% 
  datatable() %>% formatRound(columns=c('mean', 'sd','median', 'skew', 'kurtosis','se'), digits=4)

uni_cp <- synboot_cart_cpm %>% #or syn_cart_m
  map(~.x %>% 
        complete("all") %>% 
        map(~.x %>% 
              describe()) %>% Reduce("+", .) / 5) %>%
  Reduce("+", .) / 1000
true <- describe(truedata)
uni_synboot_cart_cpm <- (uni_cp - true) %>% select(c("mean", "sd", "median", "skew", "kurtosis", "se")) %>% 
  datatable() %>% formatRound(columns=c('mean', 'sd','median', 'skew', 'kurtosis','se'), digits=4)

uni_mmx1 <- synboot_cart_mmx1 %>% #or syn_cart_m
  map(~.x %>% 
        complete("all") %>% 
        map(~.x %>% 
              describe()) %>% Reduce("+", .) / 5) %>%
  Reduce("+", .) / 1000
true <- describe(truedata)
uni_synboot_cart_mmx1 <-(uni_mmx1 - true) %>% select(c("mean", "sd", "median", "skew", "kurtosis", "se")) %>% 
  datatable() %>% formatRound(columns=c('mean', 'sd','median', 'skew', 'kurtosis','se'), digits=4)

uni_cpmmx1 <- synboot_cart_cpmmx1 %>% #or syn_cart_m
  map(~.x %>% 
        complete("all") %>% 
        map(~.x %>% 
              describe()) %>% Reduce("+", .) / 5) %>%
  Reduce("+", .) / 1000
true <- describe(truedata)
uni_synboot_cart_cpmmx1 <- (uni_cpmmx1 - true) %>% select(c("mean", "sd", "median", "skew", "kurtosis", "se")) %>% 
  datatable() %>% formatRound(columns=c('mean', 'sd','median', 'skew', 'kurtosis','se'), digits=4)

Eval_SynData_boot <- list(eval_synboot_cart_m = eval_synboot_cart_m, eval_synboot_cart_cpm = eval_synboot_cart_cpm, 
                         eval_synboot_cart_mmx1 = eval_synboot_cart_mmx1, eval_synboot_cart_cpmmx1 = eval_synboot_cart_cpmmx1,
                         eval2_synboot_cart_m = eval2_synboot_cart_m, eval2_synboot_cart_cpm = eval2_synboot_cart_cpm, 
                         eval2_synboot_cart_mmx1 = eval2_synboot_cart_mmx1, eval2_synboot_cart_cpmmx1 = eval2_synboot_cart_cpmmx1,
                         uni_synboot_cart_m = uni_synboot_cart_m, uni_synboot_cart_cpm = uni_synboot_cart_cpm,
                         uni_synboot_cart_mmx1 = uni_synboot_cart_mmx1, uni_synboot_cart_cpmmx1 = uni_synboot_cart_cpmmx1)
                         
  
save(Eval_SynData_boot, file = "Workspaces/1.6 Evaluation synthetic data_bootstrapped sample.Rdata")
#OR scenario 2
#save(Eval_SynData_boot, file = "Workspaces/2.6 Evaluation synthetic data_bootstrapped sample.Rdata")