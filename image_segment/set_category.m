function [] = set_category(X, clusters, pixels, K)
% X is input feature vector
% pixels are 1 x 3 containing RGB value
% K is the required category

for i = 1:size(X, 1)
    if (clusters(i) == K)
        X(i, :) = pixels;
    end
end

end
