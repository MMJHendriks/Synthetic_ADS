#Functions synthetic data 

# pool function partially synthetic data
pool3.syn <- function(mira) {
  if(class(mira)[1] == "mira") { # if the input object is of class mira
    fitlist <- mira %$% analyses # extract the analyses from the mira object
  } 
  else {
    fitlist <- mira              # and otherwise, just take the input list
  }
  
  vars <- fitlist[[1]] %>% coef() %>% names()
  
  m <- length(fitlist)           # number of imputations
  
  pooled <- fitlist %>% 
    map_dfr(broom::tidy) %>%
    group_by(term) %>%
    summarise(est     = mean(estimate),
              bm      = sum((estimate - est)^2) / (m - 1),
              ubar    = mean(std.error^2),
              var     = ubar + bm/m, # new variance estimate
              df      = (m - 1) * (1 + (ubar * m)/bm), # and new df estimate
              lower   = est - qt(.975, df) * sqrt(var),
              upper   = est + qt(.975, df) * sqrt(var), .groups = 'drop') %>% 
    arrange(factor(term, levels=vars)) #order rows by values of selected columns 
  pooled
}


# Function confidence interval coverage 
ci_cov <- function(pooled, true_fit = NULL, coefs = NULL, vars = NULL) {
  
  if (!is.null(true_fit)) {
    coefs <- coef(true_fit)
    vars   <- diag(vcov(true_fit))
  }
  
  nsim <- nrow(pooled) / length(unique(pooled$term))
  
  pooled %>% mutate(true_coef = rep(coefs, times = nsim),
                    true_var  = rep(vars, times = nsim),
                    cover     = lower < true_coef & true_coef < upper) %>%
    group_by(term) %>%
    summarise("True Est" = unique(true_coef),
              "Syn Est"  = mean(est),
              "Bias"     = mean(est - true_coef),
              #"True SE"  = unique(sqrt(true_var)),
              #"Syn SE"   = mean(sqrt(var)),
              #"df"       = mean(df),
              #"Lower"    = mean(lower),
              #"Upper"    = mean(upper),
              "CIW"      = mean(upper - lower),
              "Coverage" = mean(cover), .groups = "drop")
}



# POOL NORMAL 
pool.normal <- function(mira) {
  
  if(class(mira)[1] == "mira") { # if the input object is of class mira
    fitlist <- mira %$% analyses # extract the analyses from the mira object
  }
  else {                         # and otherwise, just take the input list
    fitlist <- mira
  }
  
  vars <- fitlist[[1]] %>% coef() %>% names()
  
  m <- length(fitlist)           # number of imputations
  
  pooled <- fitlist %>% 
    map_dfr(broom::tidy) %>%     # tidy estimates
    group_by(term) %>%           # group per variable
    summarise(est     = mean(estimate),
              bm      = sum((estimate - est)^2) / (m - 1),
              ubar    = mean(std.error^2),
              var_u   = (1 + 1/m) * bm + ubar,
              var     = if_else(var_u > 0, var_u, ubar), # restrict variance to be positive
              df      = max(1, (m - 1) * (1 - ubar / (bm + bm/m))^2), # restrict df > 1
              lower   = est - qt(.975, df) * sqrt(var),
              upper   = est + qt(.975, df) * sqrt(var), .groups = 'drop') %>%
    arrange(factor(term, levels = vars))
  pooled
}

