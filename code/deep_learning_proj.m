% setup MatConvNet
run  matlab/vl_setupnn

% load the pre-trained CNN
net = load('imagenet-vgg-f.mat') ;

% load and preprocess an image

data_path = '\\prism.nas.gatech.edu\zluo60\vlab\documents\MATLAB\proj4\data';

categories = {'Kitchen', 'Store', 'Bedroom', 'LivingRoom', 'Office', ...
       'Industrial', 'Suburb', 'InsideCity', 'TallBuilding', 'Street', ...
       'Highway', 'OpenCountry', 'Coast', 'Mountain', 'Forest'};
   
%This list of shortened category names is used later for visualization.
abbr_categories = {'Kit', 'Sto', 'Bed', 'Liv', 'Off', 'Ind', 'Sub', ...
    'Cty', 'Bld', 'St', 'HW', 'OC', 'Cst', 'Mnt', 'For'};
    
%number of training examples per category to use. Max is 100. For
%simplicity, we assume this is the number of test cases per category, as
%well.
num_train_per_cat = 100; 

%This function returns cell arrays containing the file path for each train
%and test image, as well as cell arrays with the label of each train and
%test image. By default all four of these arrays will be 1500x1 where each
%entry is a char array (or string).
fprintf('Getting paths and labels for all train and test data\n')
[train_image_paths, test_image_paths, train_labels, test_labels] = ...
    get_image_paths(data_path, categories, num_train_per_cat);
%   train_image_paths  1500x1   cell      
%   test_image_paths   1500x1   cell           
%   train_labels       1500x1   cell         
%   test_labels        1500x1   cell          

trainfeat=zeros(1000,1500);
for j=1:1:1500
im = imread(train_image_paths{j}) ;
im_ = single(im) ; % note: 0-255 range
im_ = imresize(im_, net.normalization.imageSize(1:2)) ;
ima = zeros(224,224,3);
for i=1:1:3
    ima(:,:,i)=im_;
end
ima = single(ima) - net.normalization.averageImage ;

% run the CNN
res = vl_simplenn(net, ima) ;

% show the classification result
scores = squeeze(gather(res(end-1).x)) ;
% [bestScore, best] = max(scores) ;
% bestrain(j)=best;
% scoretrain(j)=bestScore;
trainfeat(:,j)=scores;
j
end

testfeat=zeros(1000,1500);
for j=1:1:1500
im = imread(test_image_paths{j}) ;
im_ = single(im) ; % note: 0-255 range
im_ = imresize(im_, net.normalization.imageSize(1:2)) ;
ima = zeros(224,224,3);
for i=1:1:3
    ima(:,:,i)=im_;
end
ima = single(ima) - net.normalization.averageImage ;

% run the CNN
res = vl_simplenn(net, ima) ;

% show the classification result
scores = squeeze(gather(res(end-1).x)) ;
% [bestScore, best] = max(scores) ;
% bestrain(j)=best;
% scoretrain(j)=bestScore;
testfeat(:,j)=scores;
j
end

save('testfeat.mat','testfeat');
save('trainfeat.mat','trainfeat');
% figure(1) ; clf ; imagesc(im) ;
% title(sprintf('%s (%d), score %.3f',...
% net.classes.description{best}, best, bestScore)) ;
