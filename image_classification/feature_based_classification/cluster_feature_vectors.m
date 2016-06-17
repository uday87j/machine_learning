function [centroids, idx] = cluster_feature_vectors(X, K, max_iter, run_pca = false, pca_dim = 10)
%% cluster_feature_vector takes X of shape m X n
%% If run_pca = true, then pca_dim is used for choosing no. of PCA dimensions
%% It runs K-Means clustering on them
%% Returns feature_vector of size k X n

% Run PCA
% -----------------------------------------
if run_pca == true
    [X_norm, mu, sigma] = featureNormalize(X);

    [U, S] = pca(X_norm);
    Ureduce = U(:, 1:pca_dim);

    X = (X * Ureduce);
end
% -----------------------------------------

a = now();
[idx, centroids] = kmeans(X, K);
b = now();
fprintf("\nTime taken by kmeans: %f", (b - a));

% initial_centroids = kMeansInitCentroids(X, K);
% disp(initial_centroids(1));

% Run K-Means
% max_iters = max_iter;
% [centroids, idx] = runkMeans(X, initial_centroids, max_iters);
% disp(centroids(1));
% disp(size(centroids));

end
