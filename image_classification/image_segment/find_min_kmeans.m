function [clusters] = find_min_kmeans(X, max_rand_iters, max_kmean_iters, K)
% Run K-means many times and hoose the one with min. cost function
% X is input feature vector of examples
% K is number of clusters required
% 'clusters' is returned that is of [size(X, 1) x 1] & of range [1..K]

for rand_iter = 1:max_rand_iters

  initial_centroids = kMeansInitCentroids(X, K);
  % save -ascii "initial_centroids.txt" initial_centroids

  % Run K-Means algorithm. The 'true' at the end tells our function to plot
  % the progress of K-Means
  [centroids, idx] = runkMeans(X, initial_centroids, max_kmean_iters, false);

  J = kmeans_cost(X, idx, centroids);

  if rand_iter == 1
    Jmin = J;
    clusters = idx;
  else
    if J < Jmin
      Jmin = J;
      clusters = idx;
    end
  end
end

end
