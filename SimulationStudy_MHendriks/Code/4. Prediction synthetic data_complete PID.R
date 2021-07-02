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

load("Workspaces/1.3 Evaluation synthetic data_complete PID.Rdata")
#OR scenario 2
#load("Workspaces/2.3 Evaluation synthetic data_complete PID.Rdata")

#Fix random seed. In this simulation study, we will be using random numbers. 
#We set the seed of the random number generator in order to be able to reproduce the results.
set.seed(123) 

#Let us define the number of simulations for this Monte Carlo experiment.
nsim = 1000
plan(multisession)


### Prediction: true or synthetic 
# We assess the ability to discriminate between the observed and synthetic data using a prediction model.

pred_truesyn <- syn_cart_m %>%
  map(~.x %>% 
        complete("all") %>%  
        map(~.x %>% 
              rbind(truedata) %>% 
              mutate(indic = as.factor(c(rep(0, 768), rep(1, 768)))) %$% #50/50 true syn 
              glm(Outcome~BMI+Glucose+Pregnancies, family=binomial(link = "logit"))) %>% pool() %>% summary() %>% as.data.frame() %>% column_to_rownames(var = "term")) %>% 
  Reduce("+", .) %>% round(digits = 4)
pred_truesyn_out <- datatable(pred_truesyn / 1000) %>% formatRound(columns=c('estimate','std.error','statistic','df','p.value'), digits=4)

pred_truesyn2 <- syn_cart_cpm %>%
  map(~.x %>% 
        complete("all") %>%  
        map(~.x %>% 
              rbind(truedata) %>% 
              mutate(indic = as.factor(c(rep(0, 768), rep(1, 768)))) %$% #50/50 true syn 
              glm(Outcome~BMI+Glucose+Pregnancies, family=binomial(link = "logit"))) %>% pool() %>% summary() %>% as.data.frame() %>% column_to_rownames(var = "term")) %>% 
  Reduce("+", .) %>% round(digits = 4)
pred_truesyn2_out <- datatable(pred_truesyn2 / 1000) %>% formatRound(columns=c('estimate','std.error','statistic','df','p.value'), digits=4)

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
pred_syn_cart_m <- syn_cart_m %>%
  map(~.x %>% 
        complete("all") %>%  
        map(~.x %>% do_fun()) %>% 
        do.call("rbind", .) %>% colMeans()) %>% 
  do.call("rbind", .) %>% colMeans() %>% .[c(1, 2, 8, 9, 15, 18)] %>% round(digits = 4)


pred_syn_cart_cpm <- syn_cart_cpm %>%
  map(~.x %>% 
        complete("all") %>%  
        map(~.x %>% do_fun()) %>% 
        do.call("rbind", .) %>% colMeans()) %>% 
  do.call("rbind", .) %>% colMeans() %>% .[c(1, 2, 8, 9, 15, 18)] %>% round(digits = 4)

Pred_SynData_complete <- list(pred_truesyn_out = pred_truesyn_out, pred_truesyn2_out = pred_truesyn2_out,
                                  pred_syn_cart_m = pred_syn_cart_m, pred_syn_cart_cpm = pred_syn_cart_cpm)

save(Pred_SynData_complete, file = "Workspaces/1.4 Prediction synthetic data_complete PID.Rdata")
#OR scenario 2
#save(Pred_SynData_complete, file = "Workspaces/2.4 Prediction synthetic data_complete PID.Rdata")
