function plotData(X, y)
%PLOTDATA Plots the data points X and y into a new figure 
%   PLOTDATA(x,y) plots the data points with + for the positive examples
%   and o for the negative examples. X is assumed to be a Mx2 matrix.

% Create New Figure
figure; hold on;

% ====================== YOUR CODE HERE ======================
% Instructions: Plot the positive and negative examples on a
%               2D plot, using the option 'k+' for the positive
%               examples and 'ko' for the negative examples.
%
m = length(y);

pos_x_vec = []
pos_y_vec = []
neg_x_vec = []
neg_y_vec = []

for i = 1:m
    if y(i) == 1
        pos_x_vec = [pos_x_vec, X(i, 1)];
        pos_y_vec = [pos_y_vec, X(i, 2)];
    else
        neg_x_vec = [neg_x_vec, X(i, 1)];
        neg_y_vec = [neg_y_vec, X(i, 2)];
    end
end

plot(pos_x_vec, pos_y_vec, 'k+', 'MarkerFaceColor','g');
plot(neg_x_vec, neg_y_vec, 'ko', 'MarkerFaceColor', 'r');








% =========================================================================



hold off;

end
