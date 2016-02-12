% Starter code prepared by James Hays for Computer Vision

%This function will predict the category for every test image by finding
%the training image with most similar features. Instead of 1 nearest
%neighbor, you can vote based on k nearest neighbors which will increase
%performance (although you need to pick a reasonable value for k).

function predicted_categories = nearest_neighbor_classify(train_image_feats, train_labels, test_image_feats)
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
   category. Not necessary for simple one nearest neighbor classifier.

 D = vl_alldist2(X,Y) 
    http://www.vlfeat.org/matlab/vl_alldist2.html
    returns the pairwise distance matrix D of the columns of X and Y. 
    D(i,j) = sum (X(:,i) - Y(:,j)).^2
    Note that vl_feat represents points as columns vs this code (and Matlab
    in general) represents points as rows. So you probably want to use the
    transpose operator ' 
   vl_alldist2 supports different distance metrics which can influence
   performance significantly. The default distance, L2, is fine for images.
   CHI2 tends to work well for histograms.
 
  [Y,I] = MIN(X) if you're only doing 1 nearest neighbor, or
  [Y,I] = SORT(X) if you're going to be reasoning about many nearest
  neighbors 

%}

% find K nearest neighbor of a test feature
K= 5;     %% K= 20 for first situation£» K=10 or sencond situation
          %% K= 10 for NBNN compare
          %% K=1 just for fisher
thresholdh=1.5;  %% before fisher is 0.4  %% 1.5 in DL
thresholdl=0.2;  % 0.2 in DL
L=size(test_image_feats,1);
D = vl_alldist2(test_image_feats',train_image_feats');
radius=zeros(1,L);
%test_label=zeros(1,L);
predictied_categories={'Suburb'};

for i=1:1:L
    temp=D(i,:);
    [temp2,ind1]=sort(temp);
    neighbor=ind1(1:(K));
    labels=train_labels(neighbor);
    radius(i)=temp2(K);
    if radius(i)>thresholdh
        [temp4,ind4]=find(temp2<=thresholdh);
        if length(ind4)<=0
            KK=thresholdl;
            radius(i)=temp2(KK);
        else
            KK=length(ind4);
            radius(i)=temp2(KK);
        end     
    else
        KK=K;
    end
    vote=zeros(1,15);
    %table=tabulate(cell2mat(labels')); %% since table
    %TABLE=cell2mat(table(:,2));
    %[maxi,ind2]=max(TABLE);
    %LABEL=cell2mat(table(:,1));
    %test_label(i)=LABEL(ind2(1)); 
    
    LABEL= {'Kitchen', 'Store', 'Bedroom', 'LivingRoom', 'Office', ...
        'Industrial', 'Suburb', 'InsideCity', 'TallBuilding', 'Street', ...
        'Highway', 'OpenCountry', 'Coast', 'Mountain', 'Forest'};
    
    for j=1:1:KK
        switch cell2mat(labels(j)) 
            case 'Kitchen' 
                vote(1)=vote(1)+1 ;
            case 'Store'   
                vote(2)=vote(2)+1 ; 
            case 'Bedroom' 
                vote(3)=vote(3)+1 ; 
            case 'LivingRoom' 
                vote(4)=vote(4)+1 ;
            case 'Office'   
                vote(5)=vote(5)+1 ; 
            case 'Industrial' 
                vote(6)=vote(6)+1 ; 
            case 'Suburb' 
                vote(7)=vote(7)+1 ;
            case 'InsideCity'   
                vote(8)=vote(8)+1 ; 
            case 'TallBuilding' 
                vote(9)=vote(9)+1 ; 
            case 'Street' 
                vote(10)=vote(10)+1 ;
            case 'Highway'   
                vote(11)=vote(11)+1 ; 
            case 'OpenCountry' 
                vote(12)=vote(12)+1 ; 
            case 'Coast' 
                vote(13)=vote(13)+1 ;
            case 'Mountain'   
                vote(14)=vote(14)+1 ; 
            case 'Forest' 
                vote(15)=vote(15)+1 ;                     
        end
    end    
    %%above calcu the vote of everysort
    [maxi,ind3]=max(vote);
    pcategory=LABEL{ind3};
    predicted_categories{i,1}=pcategory;
    i
end
plot((1:1:L),radius); %% for implementing threshold, if needed
end











