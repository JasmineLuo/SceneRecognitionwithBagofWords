%% implemented only for NBNN 
function [image_feats, image_label] = sifts_for_every_image(image_paths,label)
%% pay attention that both train and test image have a batch of SIFTs
%% for the train image, label means category
%% for the test image, label means image identity
Num=size(image_paths,1);
status=0;
if find(label>0)
    status=1; % for train image
else % for test image is 0
end
image_feats=[];
image_label=[];
stepsize=4;  

if status==1
    for i=1:1:Num
        image=single(imread(image_paths{i}));
        [~, SIFT_features] = vl_dsift(image, 'fast','step',stepsize);
        num_sift=size(SIFT_features,2);
        image_feats=[image_feats;single(SIFT_features)'];
        temp=label(i)*ones(num_sift,1); % label for train images
        image_label=[image_label;temp];
        i
    end
else
    for i=1:1:Num
        image=single(imread(image_paths{i}));
        [~, SIFT_features] = vl_dsift(image, 'fast','step',stepsize);
        num_sift=size(SIFT_features,2);
        image_feats=[image_feats;single(SIFT_features)'];
        temp=i*ones(num_sift,1);    % label for test images
        image_label=[image_label;temp];
        i
    end    
end

%% stepsize =4 -> exceeds largest array limit of matlab