clear all;
warning off;

seed = 2436234;
rng(seed);
% plotting
row = 3; % set this to a different integer (1-3), and change correlation below
         % to plot different simulations together
nrows = 3;

%% Multivariate linear model, correlated covariates
reps = 100; % experimental repeats
n = 100; % sample size per experiment

C = [1 0.5; 0.5 1]; % Correlation matrix of covariates
sigmaX = [1 1]; % standard deviation of covariates
Sigma = C.*(sigmaX'*sigmaX); % covariance matrix of covariates
Mu = [0 0]; % covariate means
sigma = .25; % noise standard deviation

beta = [0 1 -1]'; % true coeffients
                  % first element = intercept
                  % remaining must match dimensionality of C

covb = zeros(numel(beta),numel(beta),reps);
corb = zeros(numel(beta),numel(beta),reps);
for i = 1:reps
   X = mvnrnd(Mu,Sigma,n); % stochastic regressors, important properties hold
                           % Fomby et al., Advanced Econometric Methods, ch 5
                           
   y = beta(1) + X*beta(2:end) + sigma*randn(n,1); % sample

%    ind = randperm(numel(y));
%    y = y(ind);
   stats(i) = regstats(y,X,'linear');
   
   % Estimate coefficient variance-covariance matrix & correlation matrix
   X = [ones(n,1),X];
   G = inv(X'*X);
   covb(:,:,i) = sigma^2*G; % could use sigma_hat instead
   D = diag(diag(covb(:,:,i)))^(-1/2); % Finn, A General Model for Multivariate Analysis, ch 4
   corb(:,:,i) = D*covb(:,:,i)*D;
end

%% pairwise scatter plot
b = cat(2,stats.beta);
figure;
[H,AX,BigAx,P,PAx] = plotmatrix(b');
title(AX(1,1),'b0');
title(AX(1,2),'b1');
title(AX(1,3),'b2');
ylabel(AX(1,1),'b0');
ylabel(AX(2,1),'b1');
ylabel(AX(3,1),'b2');
close
% parameter estimates are unbiased
mean(cat(3,stats.covb),3)
% as are the parameter correlations
mean(corb,3')

%% Plot data and beta space, covariances in each space are 90 degree rotations
figure(2);
rng(seed);
X = mvnrnd(Mu,Sigma,n); % design matrix for first repeat
t = linspace(0,2*pi,100);

% look at the first two covariates, with 95% confidence ellipse
subplot(nrows,3,(row-1)*3+1); hold on
plot(X(:,1),X(:,2),'ko');
[V,D] = eig(cov(X));
[D,order] = sort(diag(D),'descend');
D = diag(D);
V = V(:, order);
VV = V*2.447*sqrt(D);
e = [cos(t) ; sin(t)]; % unit circle
e = bsxfun(@plus, VV*e, Mu'); 
plot(e(1,:), e(2,:),'k');

xlim = sigmaX(1)*[-4 4];
ylim = sigmaX(2)*[-4 4];
axis([xlim ylim]); axis square
xlabel('X1');
ylabel('X2');
title('Data space');

% look at the corresponding coefficients, with joint confidence region
subplot(nrows,3,(row-1)*3+2); hold on
plot(b(2,1),b(3,1),'ro','markerfacecolor','r');
VV = sqrt(2*finv(0.95,2,n-2))*sigma*(X'*X)^(-1/2); % Friendly et al. 2013
e = [cos(t) ; sin(t)]; % unit circle
e = bsxfun(@plus, VV*e, b(2:3,1));
plot(e(1,:), e(2,:),'r');
xlim = [min(e(1,:)) max(e(1,:))] + [-.05 .05];
ylim = [min(e(2,:)) max(e(2,:))] + [-.05 .05];
plot([beta(2) beta(2)],ylim,'k');
plot(xlim,[beta(3) beta(3)],'k');
axis([xlim ylim]); axis square
xlabel('b1');
ylabel('b2');
title('Beta space, single repeat');

% same, but show all repeats
subplot(nrows,3,(row-1)*3+3); hold on
plot(b(2,:),b(3,:),'bo');
plot(b(2,1),b(3,1),'ro','markerfacecolor','r');
t = linspace(0,2*pi,100);
e = [cos(t) ; sin(t)];
VV = sqrt(2*finv(0.95,2,n-2))*sigma*(X'*X)^(-1/2);
e = [cos(t) ; sin(t)]; % unit circle
e = bsxfun(@plus, VV*e, b(2:3,1));
plot(e(1,:), e(2,:),'r');
xlim = [min(e(1,:)) max(e(1,:))] + [-.05 .05];
ylim = [min(e(2,:)) max(e(2,:))] + [-.05 .05];
plot([beta(2) beta(2)],ylim,'k');
plot(xlim,[beta(3) beta(3)],'k');
axis([xlim ylim]); axis square
xlabel('b1');
ylabel('b2');
title(sprintf('Beta space, %g repeats',reps));
