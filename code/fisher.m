%% For Fisher encode for SIFT features
function [train_code, test_code] = fisher(train_image_path, test_image_path)

% first build dictionary 
Num=size(train_image_path,1);
dictionstepsize=5;
framestep=1;
numcluster=100;

diction_feats=[];
for i=1:framestep:Num
        image=single(imread(train_image_path{i}));
        [~, SIFT_features] = vl_dsift(image, 'norm','step',dictionstepsize);
        diction_feats=[diction_feats,single(SIFT_features)];
        i
end

%%get solution for coding
[means, covariances, priors] = vl_gmm(diction_feats, numcluster);

save('FisherMeans.mat','means');
save('FisherCovariances.mat','covariances');
save('FisherPriors.mat','priors');

%%encode train and test image
stepsize=4;
train_code=[];
test_code=[];

for m=1:1:Num
    testim=single(imread(test_image_path{m}));
    trainim=single(imread(train_image_path{m}));
    [~, train_SIFT] = vl_dsift(trainim, 'norm','step',stepsize);
    [~, test_SIFT] = vl_dsift(testim, 'norm','step',stepsize);
    %%get sift for ith test and train
    %%encode both
    train_encoding = vl_fisher(single(train_SIFT), means, covariances, priors,'normalized');
    test_encoding = vl_fisher(single(test_SIFT), means, covariances, priors,'normalized');
    %%add to feature
    %%return coloum to fit later N*d, use transpose
    train_code=[train_code;train_encoding'];
    test_code=[test_code;test_encoding'];
    m
end
end
