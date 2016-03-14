function [] = classify_hist(hist_file, img_name_file, cat_file, num_cat, kmean_iters)
%% Classify the histograms present in hist_file
%% hist_file : Input
%% img_name_file : Output
%% cat_file : Output

load(hist_file);

max_iters = kmean_iters;
IMG_CAT = num_cat;% Number of categories of images required
fprintf("\nCategorizing images based on histogram...");
[img_ctr, cidx] = cluster_feature_vectors(feature_hist, IMG_CAT, max_iters);

display_image_categories(img_name_file, cidx, cat_file);

end
