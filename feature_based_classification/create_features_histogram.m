function [histogram_centroids] = create_features_histogram(all_features, feature_size_per_image, centroids)
%% For each image, match its feature vector components to the nearest centroid
%% Return a histogram count of centroids in each image

%% all_features : r X n
%% feature_size_per_image : m X 1
%% centroids : k X n
%% 
%% histogram_centroids : m X k
%% 
%% m : Number of images
%% n : Number of features
%% k : Number of centroids
%% r : Total number of feature vectors

% fprintf("\nDisplaying sizes of matrix:\n");
% disp(size(all_features));
% disp(size(feature_size_per_image));
% disp(size(centroids));
% disp(centroids(1));

start_idx = 1;
end_idx = 1;

histogram_centroids = zeros(size(feature_size_per_image, 1), size(centroids, 1));

for dsize = 1:size(feature_size_per_image, 1)
    % fprintf("\nRunning histogram for image %d\n", dsize);
    % disp(dsize);
    
    end_idx = start_idx + feature_size_per_image(dsize);
    % disp(start_idx);    disp(end_idx);
    feature_img = all_features(start_idx : end_idx, :);
    
    closest_centroids = findClosestCentroids(feature_img, centroids);
    % disp(size(closest_centroids));
    % disp(closest_centroids); pause;

    for c = 1:size(closest_centroids, 1)
    %% for c = closest_centroids
        histogram_centroids(dsize, closest_centroids(c)) += 1; %closest_centroids(c);
    end

end

% disp(size(histogram_centroids));

end
