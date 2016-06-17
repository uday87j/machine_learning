function [XK] = get_category(X, clusters, K)
% X is input feature vector
% clusters are size(X,1) x 1 containing categories
% K is the required category

XK = [];

for i = 1:size(X, 1)
    if (clusters(i) == K)
        XK = [XK; X(i, :)];
    end
end

end
