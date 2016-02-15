%X = [1 2; 1 3; 2 3; 100 100; 102 101; 100 105];  %Easy
X = [1 2; 1 3; 2 3; 1 4; 2 4; 3 1];
K = 2;
initial_centroids = kMeansInitCentroids(X, K);
max_iters = 10;

[centroids, idx] = runkMeans(X, initial_centroids, max_iters, false);
fprintf('\nK-Means Done.\n\n');

disp(idx);
plotDataPoints(X, idx, K);
J = kmeans_cost(X, idx, centroids);
fprintf("\nCost = %d\n", J);
pause;
