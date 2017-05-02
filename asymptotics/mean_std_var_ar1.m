% Crack & Ledoit 

clear;

rng(20081103);
% rseed=20081103;
% randn('seed',rseed);

rho = 0.90;
sigmae = 0.50;
mu = 0;
sigma = sigmae/sqrt(1-rho^2); 

N = 50;

NUMBREPS = 1000; 

collect = [ ];

for J=1:NUMBREPS
   %Y=[];
   epsilon = randn(N,1);
   xpf = epsilon*sigmae;
   bpf = 1;
   apf = [1 -rho];
   Y = filter(bpf,apf,xpf);
   collect=[collect' [mean(Y) var(Y)]']';
end

asymeanv = 0; 
asyvarv = 2*(sigma^4)*(1+rho^2)/(1-rho^2);
asymeanv1 = 0; 
asyvarv1 = 2*(sigma^4); 
v = sqrt(N)*(collect(:,2)-sigma^2); 
hpdf = [];
mynormpdf = [];
[M,X] = hist(v,250);
M = M';
X = X';
dx = min(diff(X)); 
hpdf = M/(sum(M)*dx);

figure;
mynormpdf=(1/(sqrt(2*pi)*sqrt(asyvarv))).*exp( -0.5*((X-asymeanv)/sqrt(asyvarv)).^ 2); 
mynormpdf1=(1/(sqrt(2*pi)*sqrt(asyvarv1))).*exp( -0.5*((X-asymeanv1)/sqrt(asyvarv1)).^2);
plot(X,[hpdf mynormpdf mynormpdf1],'k')
xlabel('Asymptotic Sample Variance of the Gaussian AR(1)'); ylabel('Frequency');