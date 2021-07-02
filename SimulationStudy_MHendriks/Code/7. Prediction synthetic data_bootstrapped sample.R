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

load("Workspaces/1.6 Evaluation synthetic data_bootstrapped sample.Rdata")
#OR scenario 2
#load("Workspaces/2.6 Evaluation synthetic data_bootstrapped sample.Rdata")

#Fix random seed. In this simulation study, we will be using random numbers. 
#We set the seed of the random number generator in order to be able to reproduce the results.
set.seed(123) 

#Let us define the number of simulations for this Monte Carlo experiment.
nsim = 1000
plan(multisession)

### Prediction bootstrap: true or synthetic 
# We assess the ability to discriminate between the observed and synthetic data using a prediction model. 

pred_boottruesyn <- synboot_cart_m %>%
  map(~.x %>% 
        complete("all") %>%  
        map(~.x %>% 
              rbind(truedata) %>% 
              mutate(indic = as.factor(c(rep(0, 768), rep(1, 768)))) %$% #50/50 true syn 
              glm(Outcome~BMI+Glucose+Pregnancies, family=binomial(link = "logit"))) %>% pool() %>% summary() %>% as.data.frame() %>% column_to_rownames(var = "term")) %>% 
  Reduce("+", .) %>% round(digits = 4)
pred_truesyn_out <- datatable(pred_boottruesyn / 1000)

pred_boottruesyn2 <- synboot_cart_cpm %>%
  map(~.x %>% 
        complete("all") %>%  
        map(~.x %>% 
              rbind(truedata) %>% 
              mutate(indic = as.factor(c(rep(0, 768), rep(1, 768)))) %$% #50/50 true syn 
              glm(Outcome~BMI+Glucose+Pregnancies, family=binomial(link = "logit"))) %>% pool() %>% summary() %>% as.data.frame() %>% column_to_rownames(var = "term")) %>% 
  Reduce("+", .) %>% round(digits = 4)
pred_truesyn2_out <- datatable(pred_boottruesyn2 / 1000) 

pred_boottruesyn3 <- synboot_cart_mmx1 %>%
  map(~.x %>% 
        complete("all") %>%  
        map(~.x %>% 
              rbind(truedata) %>% 
              mutate(indic = as.factor(c(rep(0, 768), rep(1, 768)))) %$% #50/50 true syn 
              glm(Outcome~BMI+Glucose+Pregnancies, family=binomial(link = "logit"))) %>% pool() %>% summary() %>% as.data.frame() %>% column_to_rownames(var = "term")) %>% 
  Reduce("+", .) %>% round(digits = 4)
pred_truesyn3_out <- datatable(pred_boottruesyn3 / 1000) 

pred_boottruesyn4 <- synboot_cart_cpmmx1 %>%
  map(~.x %>% 
        complete("all") %>%  
        map(~.x %>% 
              rbind(truedata) %>% 
              mutate(indic = as.factor(c(rep(0, 768), rep(1, 768)))) %$% #50/50 true syn 
              glm(Outcome~BMI+Glucose+Pregnancies, family=binomial(link = "logit"))) %>% pool() %>% summary() %>% as.data.frame() %>% column_to_rownames(var = "term")) %>% 
  Reduce("+", .) %>% round(digits = 4)
pred_truesyn4_out <- datatable(pred_boottruesyn4 / 1000) 


do_fun <- function(x){
  dat <- x %>% 
    rbind(truedata) %>% 
    mutate(indic = as.factor(c(rep(0, 768), rep(1, 768)))) 
  fit <- dat %$% 
    glm(Outcome~BMI+Glucose+Pregnancies, family=binomial(link = "logit")) %>% 
    predict(type = "response")
  CM <- confusionMatrix(factor(as.numeric(fit > .5)), factor(dat$indic))
  c(CM$overall, CM$byClass)
}

pred_syn_cart_m <- synboot_cart_m %>%
  map(~.x %>% 
        complete("all") %>%  
        map(~.x %>% do_fun()) %>% 
        do.call("rbind", .) %>% colMeans()) %>% 
  do.call("rbind", .) %>% colMeans() %>% .[c(1, 2, 8, 9, 15, 18)] %>% round(digits = 4)

pred_syn_cart_cpm <- synboot_cart_cpm %>%
  map(~.x %>% 
        complete("all") %>%  
        map(~.x %>% do_fun()) %>% 
        do.call("rbind", .) %>% colMeans()) %>% 
  do.call("rbind", .) %>% colMeans() %>% .[c(1, 2, 8, 9, 15, 18)] %>% round(digits = 4)

pred_syn_cart_mmx1 <- synboot_cart_mmx1 %>%
  map(~.x %>% 
        complete("all") %>%  
        map(~.x %>% do_fun()) %>% 
        do.call("rbind", .) %>% colMeans()) %>% 
  do.call("rbind", .) %>% colMeans() %>% .[c(1, 2, 8, 9, 15, 18)] %>% round(digits = 4)

pred_syn_cart_cpmmx1 <- synboot_cart_cpmmx1 %>%
  map(~.x %>% 
        complete("all") %>%  
        map(~.x %>% do_fun()) %>% 
        do.call("rbind", .) %>% colMeans()) %>% 
  do.call("rbind", .) %>% colMeans() %>% .[c(1, 2, 8, 9, 15, 18)] %>% round(digits = 4)


Pred_SynData_boot <- list(pred_truesyn_out = pred_truesyn_out, pred_truesyn2_out = pred_truesyn2_out,
                              pred_truesyn3_out = pred_truesyn3_out, pred_truesyn4_out = pred_truesyn4_out,
                              pred_syn_cart_m = pred_syn_cart_m, pred_syn_cart_cpm = pred_syn_cart_cpm,
                              pred_syn_cart_mmx1 = pred_syn_cart_mmx1, pred_syn_cart_cpmmx1 = pred_syn_cart_cpmmx1)

save(Pred_SynData_boot, file = "Workspaces/1.7 Prediction synthetic data_bootstrapped sample.Rdata")
#OR scenario 2
#save(Pred_SynData_boot, file = "Workspaces/2.7 Prediction synthetic data_bootstrapped sample.Rdata")
