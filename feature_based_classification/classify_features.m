function [] = classify_features(feature_desc_file, feature_per_img_file, num_cat, hist_file, kmean_iters=20)
%% Run clustering on SURF descriptors
%% feature_desc_file : Input
%% feature_per_img_file : Input
%% num_cat : Input
%% hist_file : Output

feature_vec = dlmread(feature_desc_file);
% disp(size(feature_vec));

features_per_image = dlmread(feature_per_img_file);
% disp(size(features_per_image));

K = num_cat; %50;  % Number of required clusters of feature vectors
max_iters = kmean_iters;
pca_dim = 1000;

fprintf("\nClustering feature vectors...");
[feature_centroids, idx] = cluster_feature_vectors(feature_vec, K, max_iters, false, pca_dim);
% disp(size(feature_centroids));

fprintf("\nCreating histogram of feature vectors per image...");
feature_hist = create_features_histogram(feature_vec, features_per_image, feature_centroids);
% disp(size(feature_hist));

save("-text", hist_file, "feature_hist");


end
