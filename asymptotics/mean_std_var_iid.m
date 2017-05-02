clear;
rng(1234);

T = [5 10 50 100];
reps = 10000;

mu = 1;
sigma = 2;

sample_mean = zeros(numel(T),reps);
sample_var = zeros(numel(T),reps);
sample_std = zeros(numel(T),reps);

c = parula(numel(T));
for i = 1:numel(T)
   X = sigma*randn(T(i),reps) + mu;
   sample_mean(i,:) = mean(X);
   sample_var(i,:) = var(X);
   sample_std(i,:) = std(X);
   
   dx = 0.05;
   xl = max(abs(sample_mean(i,:)));
   x = [-xl:dx:xl];
   n = hist(sample_mean(i,:),x);
   pdf_sample_mean = n/(sum(n)*dx);
   
   subplot(231); hold on
   plot(x,pdf_sample_mean,'-',...
      x,normpdf(x,mu,sqrt(sigma^2/T(i))),'--','Color',c(i,:));
   
   dx = 0.05;
   xl = max(sample_var(i,:));
   x = [0:dx:xl];
   n = hist(sample_var(i,:),x);
   pdf_sample_var = n/(sum(n)*dx);
   
   % Theorem 6.13 Mittelhammer (2013)
   % Section 7.6 Kenney & Keeping (1951)
   % More typically presented result is that the normalized
   % variance is asymptotically chi-squared with T-1 dof
   subplot(232); hold on
   plot(x,pdf_sample_var,'-',...
      x,gampdf(x,(T(i)-1)/2,(2*sigma^2)/T(i)),'--','Color',c(i,:));

   dx = 0.05;
   xl = max(sample_std(i,:));
   x = [0:dx:xl];
   n = hist(sample_std(i,:),x);
   pdf_sample_std = n/(sum(n)*dx);
   
   % Section 7.8 Kenney & Keeping (1951)
   subplot(233); hold on
   N = T(i);
   C = 2*((N/(2*sigma^2))^((N-1)/2)) / gamma((N-1)/2);
   f = @(s) C .* exp(-N*s.^2./(2.*sigma^2)) .* s.^(N-2);
   plot(x,pdf_sample_std,'-',...
      x,f(x),'--','Color',c(i,:));

   subplot(234); hold on
   plot(T(i),var(sample_mean(i,:)),'o','Color',c(i,:));
   plot(T(i),sigma^2/T(i),'x','Color',c(i,:));
   set(gca,'xscale','log');
   title('Variance of sample mean');
   
   subplot(235); hold on
   plot(T(i),var(sample_var(i,:)),'o','Color',c(i,:));
   plot(T(i),(2*sigma^4*(T(i)-1))/T(i)^2,'x','Color',c(i,:));
   set(gca,'xscale','log');
   title('Variance of sample variance');
   
   subplot(236); hold on
   plot(T(i),var(sample_std(i,:)),'o','Color',c(i,:));
   N = T(i);
   %plot(T(i),(sigma^2/N)*(N - 1 - (2*gamma(N/2)^2)/(gamma((N-1)/2)^2)),'x','Color',c(i,:));
   plot(T(i),sigma^2*(1/(2*N) - 1/(8*N^2) - 3/(16*N^3)),'x','Color',c(i,:));
   set(gca,'xscale','log');
   title('Variance of sample standard deviation');
end
