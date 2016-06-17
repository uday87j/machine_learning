function [clusters] = cluster_images(rgb, K)
% Create K clusters based on vector of rgb

% K-means initializers
max_rand_iters = 10;
max_kmeans_iters = 20;

rgb = (rgb .* 4); % Amplify rgb to help clustering

clusters = find_min_kmeans(rgb, max_rand_iters, max_kmeans_iters, K);

end
