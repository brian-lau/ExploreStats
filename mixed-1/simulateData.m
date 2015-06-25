nSubjects = 15;
nSamples = 50;
cSubject = 0.0; % Inter-subject correlation
cSample = 0.5; % Intra-subject correlation

% Subject & Sample covariance matrices
sigmaX = [2 2];
SigmaSubject = [1 cSubject; cSubject 1].*(sigmaX'*sigmaX);
sigmaX = [1 1];
SigmaSample = [1 cSample; cSample 1].*(sigmaX'*sigmaX);

% Subject means
X = mvnrnd([0 0],SigmaSubject,nSubjects);
% Subject samples
for i = 1:nSubjects
   data{i} = mvnrnd([X(i,1) X(i,2)],SigmaSample,nSamples);
end

figure; hold on
cellfun(@(x) plot(x(:,1),x(:,2),'o'),data)

% Write to text file
temp = cat(1,data{:});
id = repmat(1:nSubjects,nSamples,1);
id = id(:);
fid = fopen(['mixed_inter' num2str(cSubject) '_intra' num2str(cSample) '.txt'],'wt');
fprintf(fid,'id,x1,x2\n');
temp2 = [id,temp]';
fprintf(fid,'%g,%1.3f,%1.3f\n',temp2(:));
fclose(fid);