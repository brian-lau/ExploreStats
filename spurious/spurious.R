library(nlme)
library(lmtest)
library(sandwich)

set.seed(12345)

T = 500
nSim = 100

rhox = 0.99
rhoy = 0.99

r2 = vector("numeric",nSim)
bhatOLS = vector("numeric",nSim)
bhatGLS = vector("numeric",nSim)
bhatLAG = vector("numeric",nSim)
tval = vector("numeric",nSim)
pval = vector("numeric",nSim)
tvalHAC = vector("numeric",nSim)
pvalHAC = vector("numeric",nSim)
tvalGLS = vector("numeric",nSim)
pvalGLS = vector("numeric",nSim)
tvalLAG = vector("numeric",nSim)
pvalLAG = vector("numeric",nSim)

for (s in 1:nSim) {
  x = arima.sim(n = T, list(ar = c(rhox)))
  y = 0.0*x + arima.sim(n = T, list(ar = c(rhoy)))
  
  # Standard OLS
  ols = (lm(y~x))
  r2[[s]] = summary(ols)$r.squared
  
  sumres = summary(ols)
  # Overall F-test
  #pval[[s]] = pf(sumres$fstatistic[1L], sumres$fstatistic[2L], sumres$fstatistic[3L], lower.tail = FALSE)
  # Slope
  bhatOLS[[s]] = coefficients(ols)[[2]]
  # Slope statistic
  test = coeftest(ols)
  tval[[s]] = test[2,3]
  pval[[s]] = test[2,4]
  
  # HAC corrected standard errors
  #test = coeftest(ols,vcov = vcovHAC)
  # w/ lag length yielding convergent statistic (Sun 2004)
  test = coeftest(ols,vcov = NeweyWest(ols,lag=T*0.05))
  tvalHAC[[s]] = test[2,3]
  pvalHAC[[s]] = test[2,4]
  
  # Feasible generalized least squares
  fgls = gls(y~x,correlation=corAR1(form=~1))
  test = coeftest(fgls)
  tvalGLS[[s]] = test[2,3]
  pvalGLS[[s]] = test[2,4]
  bhatGLS[[s]] = coefficients(fgls)[[2]]
  
  # Lagged variables (Hamilton pg. 562)
  lagx <- c(NA, embed(x,2)[,2])
  lagy <- c(NA, embed(y,2)[,2])
  ols = lm(y~x + lagx + lagy)
  # Slope
  bhatLAG[[s]] = coefficients(ols)[[2]]
  # Slope statistic
  test = coeftest(ols)
  tvalLAG[[s]] = test[2,3]
  pvalLAG[[s]] = test[2,4]
}

