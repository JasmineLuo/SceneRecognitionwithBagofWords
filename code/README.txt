Code function illustration:

proj4.m 		include all situations by selecting FEATURE and CLASSIFIER, except for Deep Learning.
get_tiny_images.m		 for tiny image feature
nearest_neighbor_classify.m 		for K_nearest neighbor classify
build_vocaburary.m and get_bag_of_sifts.m 		for Bag of SIFT
SVM_classify.m 		for suport vector machine
sifts_for_every_image.m and NBNN.m 		for Naive Bayes Nearest Neighbor
fisher.m 		for Fisher encoded SIFT
matconvet-1.0-beta16 deep_learning_proj 		for deep learning

testfeat.mat and trainfeat.mat is imported from deep learning process, including features of test and train image 
(the process is not run on my current system due to a liscence problem in Xcode, I get them on a remote desktop provided by ECE dept.) 