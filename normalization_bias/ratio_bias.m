% Ratio bias

clear all;
nrep = 5000;
maxSamples = 50;
mu_hat = zeros(maxSamples,nrep);
yb = zeros(maxSamples,nrep);
ys1 = zeros(maxSamples,nrep);
ys2 = zeros(maxSamples,nrep);
ys3 = zeros(maxSamples,nrep);
for rep = 1:nrep
   for n = 1:maxSamples
      x = .1 + 1*rand(n,1);
      %x = pearsrnd(0.9,.1,2,10,n,1);
      mu_hat(n,rep) = mean(x);
      yb(n,rep) = x(1)/mu_hat(n,rep);
      y = 10 + 1*rand(1,1);
      %y = pearsrnd(.9,.1,2,10,1,1);
      ys1(n,rep) = y/mu_hat(n,rep); % ratio of averages
      ys2(n,rep) = ys1(n,rep) - (1/n)*((y*var(x))/mean(x)^3); % simple corrrection
      ys3(n,rep) = mean(y./x); % average of ratios
   end
end

figure; 
%subplot(211); 
hold on
plot(mean(yb,2));
plot(mean(ys1,2));
plot(mean(ys2,2));
plot(mean(ys3,2));
x = .1 + 1*rand(100000,1);
%plot(1+((mean(x)*moment(x,2))/mean(x)^3)./(1:maxSamples));
% plot(1+((mean(x)*moment(x,2))/mean(x)^3 - (mean(x)*moment(x,3))/mean(x)^4)./(1:10));
plot(1+((mean(x)*moment(x,2))/mean(x)^3 - (mean(x)*moment(x,3))/mean(x)^4 + (mean(x)*moment(x,4))/mean(x)^5)./(1:maxSamples));
% plot(1+((mean(x)*moment(x,2))/mean(x)^3 - (mean(x)*moment(x,3))/mean(x)^4 + (mean(x)*moment(x,4))/mean(x)^5 - (mean(x)*moment(x,5))/mean(x)^6)./(1:10));
% plot(1+((mean(x)*moment(x,2))/mean(x)^3 - (mean(x)*moment(x,3))/mean(x)^4 + (mean(x)*moment(x,4))/mean(x)^5 - (mean(x)*moment(x,5))/mean(x)^6 + (mean(x)*moment(x,6))/mean(x)^7)./(1:10));
mx = .6;
%plot(1+((mx*moment(x,2))/mx^3 + (mx*moment(x,4))/mx^5 + (mx*moment(x,6))/mx^7 + (mx*moment(x,8))/mx^9 + (mx*moment(x,10))/mx^11)./(1:maxSamples));

