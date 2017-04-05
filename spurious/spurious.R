library(nlme)
library(lmerTest)

T = 200
nSim = 100

rhox = 0.99
rhoy = 0.99

bhat = vector("numeric",nSim)
r2 = vector("numeric",nSim)
pval = vector("numeric",nSim)

for (s in 1:nSim) {
  x = arima.sim(n = T, list(ar = c(rhox)))
  y = arima.sim(n = T, list(ar = c(rhoy)))
  
  ols = (lm(y~x))
  bhat[[s]] = coefficients(ols)[[2]]
  r2[[s]] = summary(ols)$r.squared
  
  sumres = summary(ols)
  pval[[s]] = pf(sumres$fstatistic[1L], sumres$fstatistic[2L], sumres$fstatistic[3L], lower.tail = FALSE)
  
  fgls = gls(y~x,correlation=corAR1(form=~1))
}

