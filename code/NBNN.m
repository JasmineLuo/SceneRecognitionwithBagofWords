%% use NBNN to classify the categories
function predicted_categories = NBNN(train_image_path, test_image_path, train_labels)
% image_feats is an N x d matrix, where d is the dimensionality of the
%  feature representation.
% train_labels is an N x 1 cell array, where each entry is a string
%  indicating the ground truth category for each training image.
% test_image_feats is an M x d matrix, where d is the dimensionality of the
%  feature representation. You can assume M = N unless you've modified the
%  starter code.
% predicted_categories is an M x 1 cell array, where each entry is a string
%  indicating the predicted category for each test image.

%{
Useful functions:
 matching_indices = strcmp(string, cell_array_of_strings)
 
  This can tell you which indices in train_labels match a particular
  category. This is useful for creating the binary labels for each SVM
  training task.
%}
categories = unique(train_labels); 
num_categories = length(categories);
Num=size(test_image_path,1);
predicted_categories=cell(Num,1);

elabel=zeros(1500,1);
flabel=zeros(1500,1);
for i=1:1:num_categories
    temp=strcmp(train_labels, categories{i});
    flabel=flabel+i*(+temp);
end

% get feats and labels for both train and test images 
% both are number identifiers

[train_image_feats, train] = sifts_for_every_image(train_image_path, flabel);
[test_image_feats, test] = sifts_for_every_image(test_image_path, elabel);
% % % save('NBBNtrainfeat.mat','train_image_feats');
% % % save('NBBNtrainlabel.mat','train');
% % % save('NBBNtestfeat.mat','test_image_feats');
% % % save('NBBNtestlabel.mat','test');

% % % load('NBBNtrainfeat.mat');
% % % load('NBBNtrainlabel.mat');
% % % load('NBBNtestfeat.mat');
% % % load('NBBNtestlabel.mat');

%% for every category compute the distance of every di and every dj in C
for m=1:1:Num
    %help to intialize the NNDC    
    ind2= test==m;    
    im_feats = test_image_feats(ind2,:);
    NNDC=zeros(num_categories,size(im_feats,1));
    for k=1:1:num_categories
        ind1= train==k;
        C_feats=train_image_feats(ind1,:); % get all dj for one category  
        DC = vl_alldist2(C_feats',im_feats'); % these features are already single value
        [NNC,~]=min(DC);
        NNDC(k,:)=NNC;
        k
    end
%%find the C of each image, which make sum of (every di - NNC(di)).^2 minimum
% notice that there's not only one row for one image
%  for m=1:1:Num
%     mNNDC=NNDC(:,ind2); % row is category, colum is di
    candidate=sum(NNDC,2);
    [~,IND]=min(candidate);
    pcategory=categories{IND};
    predicted_categories{m,1}=pcategory;
    m
end
end