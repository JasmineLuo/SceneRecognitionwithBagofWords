% Starter code prepared by James Hays for Computer Vision

%This function will sample SIFT descriptors from the training images,
%cluster them with kmeans, and then return the cluster centers.

function vocab = build_vocabulary( image_paths, vocab_size )
% The inputs are images, a N x 1 cell array of image paths and the size of 
% the vocabulary.

% The output 'vocab' should be vocab_size x 128. Each row is a cluster
% centroid / visual word.

%{
Useful functions:
[locations, SIFT_features] = vl_dsift(img) 
 http://www.vlfeat.org/matlab/vl_dsift.html
 locations is a 2 x n list list of locations, which can be thrown away here
  (but possibly used for extra credit in get_bags_of_sifts if you're making
  a "spatial pyramid").
 SIFT_features is a 128 x N matrix of SIFT features
  note: there are step, bin size, and smoothing parameters you can
  manipulate for vl_dsift(). We recommend debugging with the 'fast'
  parameter. This approximate version of SIFT is about 20 times faster to
  compute. Also, be sure not to use the default value of step size. It will
  be very slow and you'll see relatively little performance gain from
  extremely dense sampling. You are welcome to use your own SIFT feature
  code! It will probably be slower, though.

[centers, assignments] = vl_kmeans(X, K)
 http://www.vlfeat.org/matlab/vl_kmeans.html
  X is a d x M matrix of sampled SIFT features, where M is the number of
   features sampled. M should be pretty large! Make sure matrix is of type
   single to be safe. E.g. single(matrix).
  K is the number of clusters desired (vocab_size)
  centers is a d x K matrix of cluster centroids. This is your vocabulary.
   You can disregard 'assignments'.

  Matlab has a built in kmeans function, see 'help kmeans', but it is
  slower.
%}

% Load images from the training set. To save computation time, you don't
% necessarily need to sample from all images, although it would be better
% to do so. You can randomly sample the descriptors from each image to save
% memory and speed up the clustering. Or you can simply call vl_dsift with
% a large step size here, but a smaller step size in make_hist.m. 

% For each loaded image, get some SIFT features. You don't have to get as
% many SIFT features as you will in get_bags_of_sift.m, because you're only
% trying to get a representative sample here.

% Once you have tens of thousands of SIFT features from many training
% images, cluster them with kmeans. The resulting centroids are now your
% visual word vocabulary.
Num=size(image_paths,1);
stepsize=4;
framestep=3;
%windowsize=30;
SIFT=[];
for i=1:framestep:Num   %%%-------NOTICE that SIFT are taken every 10 picture
    image=single(imread(image_paths{i}));
    [locations, SIFT_features] = vl_dsift(image,'norm','step',stepsize);  
     SIFT=[SIFT,SIFT_features];
     i  %%for debug
end
%% could it be a problem since single is used twice ??? NO, It won't
%% 
centers = vl_kmeans(single(SIFT), vocab_size);    
vocab=centers';
end

%% notice
%   vocab -> framestep 10, stepsize 1  -> best performace
%   vocab2 -> framestep 5, stepsize 10
%   vocab3 -> framestep 5, stepsize 5
%   vocab5-> framestep 3, stepsize 4 ->best for 3rd stage 6.18
%   vocab6-> framestep 2, stepsize 4, windowsize 30
%   vocab7-> framestep 3, stepsize 3, -> 3rd stage 6.13
%   vocab8-> framestep 1, stepsize 20 (5 in get sift)
%   vocab9 (total back to 400), framestep 1, stepsize 20 (5 in get sift)
%   vocab10 (total back to 400), framestep 1,stepsize 10 (4 in get sift)

%   Comvocab -> norm  framestep 1,stepsize 30 (30 in get sift) combine with KNN-> to compare with
%   NBNN 

%   Comvocab -> norm  framestep 1,stepsize 30 (30 in get sift) combine with SVM (0.000001)-> to compare with
%   NBNN 

%   normvocab1 -> norm  framestep 1,stepsize 20 (4 in get sift) combine with SVM (0.00001)-> to compare with
%   NBNN 55.4

%   normvocab2 -> norm SVM (0.000001) change sum to norm in get sift bags
%   59.7

%   normvocab3 -> norm SVM (0.0000005) change sum to norm in get sift bags,
%   stepsize 10 

%   normvocab4 -> norm SVM (0.000001) change sum to norm in get sift bags,
%   stepsize 4 (framsize 3 diction step 4) 