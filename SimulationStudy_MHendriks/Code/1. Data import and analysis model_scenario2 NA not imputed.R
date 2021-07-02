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

#Fix random seed
#In this simulation study, we will be using random numbers. 
#We set the seed of the random number generator in order to be able to reproduce the results.
set.seed(123) 

#True data
#The following data are obtained from #https://www.kaggle.com/uciml/pima-indians-diabetes-database
truedata <- read_csv("diabetes.csv", 
                     col_types = cols(Pregnancies = col_integer(), 
                                      Glucose = col_integer(), 
                                      BloodPressure = col_integer(), 
                                      SkinThickness = col_integer(), 
                                      Insulin = col_integer(), 
                                      Age = col_integer(), 
                                      Outcome = col_factor(levels = c("0", "1"))))

#Get descriptive statistics of the data 
describe(truedata) %>% select(c('mean', 'sd', 'median', 'skew', 'kurtosis','se')) %>% 
  datatable() %>% formatRound(columns=c('mean', 'sd', 'skew', 'kurtosis','se'), digits=4)

#Define the analysis model for the simulation
model <- truedata %$% 
  glm(Outcome~BMI+Glucose+Pregnancies,family=binomial(link = "logit"))
summary(model)

save(truedata, file = "Workspaces/2.1 Data import and analysis model_scenario2 NA not imputed.Rdata")