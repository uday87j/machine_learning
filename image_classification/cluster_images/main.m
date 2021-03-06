% Main file that runs the image clustering algorithm

width = 40;
height = 40;

pca_features = 1000;
images = preprocess("images/test", width, height, pca_features);
%disp(size(images)); %Each row is an image
%save -ascii "images.txt" images
fprintf("\nPreprocessing completed\n");

% Display individual image
%for img = 1:size(images, 1)
  %img = reshape(images(img, :), width, height)';
  %disp(size(img));
  %imshow(img);
  %fprintf("\nPress Enter to continue...\n");
  %pause;
%end

% Prepare random centroids
K = 3;
max_rand_iters = 100;%50
Jmin  = 0.0;
clusters = zeros(size(images, 1), 1);

for rand_iter = 1:max_rand_iters

  initial_centroids = kMeansInitCentroids(images, K);
  %save -ascii "initial_centroids.txt" initial_centroids
  max_iters = 100;

  % Run K-Means algorithm. The 'true' at the end tells our function to plot
  % the progress of K-Means
  [centroids, idx] = runkMeans(images, initial_centroids, max_iters, false);

  J = kmeans_cost(images, idx, centroids);

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

fprintf("\nMin cost: %f", Jmin);

%disp("\nClusters:\n");
%disp(clusters);
save -ascii "clusters.txt" clusters

plotDataPoints(images, clusters, K);

pause;
