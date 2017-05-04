clear;
rng(1234);

T = [5 10 50 100];
reps = 10000;

m = 3;
v = 2;
mu = log((m^2)/sqrt(v+m^2));
sigma = sqrt(log(v/(m^2)+1));

sample_mean = zeros(numel(T),reps);
sample_var = zeros(numel(T),reps);
sample_std = zeros(numel(T),reps);

c = parula(numel(T));
for i = 1:numel(T)
   X = lognrnd(mu,sigma^2,T(i),reps);
   sample_mean(i,:) = mean(X);
   sample_var(i,:) = var(X);
   sample_std(i,:) = std(X);
end
