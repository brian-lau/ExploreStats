% covariance of sample mean and sample variance
nrep = 10000;
maxsample = 10;
m = zeros(nrep,1);
v = zeros(nrep,1);
sd = zeros(nrep,1);
for i = 1:nrep
   x = poissrnd(100,maxsample,1);
   m(i) = mean(x);
   v(i) = var(x);
   sd(i) = sqrt(v(i));
end
c = cov(m,v);
c(1,2)

100/maxsample % third moment/n

c = cov(m,1./sd);
c(1,2)

