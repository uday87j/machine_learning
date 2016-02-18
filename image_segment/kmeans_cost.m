function J = kmeans_cost(X, idx, mu)
% kmeans_cost computes cost of a clustering algorithm
% There are m data points & K clusters
% X is m X n
% idx is m X 1
% mu is K X n

m = size(X, 1);
K = size(mu, 1);
J = 0.0;

for i = 1:m
  J = J + sum((mu(idx(i)) - X(i)) .^ 2);
end

J = (J / m);
