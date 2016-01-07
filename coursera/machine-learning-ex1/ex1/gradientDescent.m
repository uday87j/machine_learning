function [theta, J_history] = gradientDescent(X, y, theta, alpha, num_iters)
%GRADIENTDESCENT Performs gradient descent to learn theta
%   theta = GRADIENTDESENT(X, y, theta, alpha, num_iters) updates theta by 
%   taking num_iters gradient steps with learning rate alpha

% Initialize some useful values
m = length(y); % number of training examples
J_history = zeros(num_iters, 1);
diff = 0.0

for iter = 1:2
%for iter = 1:1

    % ====================== YOUR CODE HERE ======================
    % Instructions: Perform a single gradient step on the parameter vector
    %               theta. 
    %
    % Hint: While debugging, it can be useful to print out the values
    %       of the cost function (computeCost) and gradient here.
    %
    diff = ((X.*(X*theta - y)).*alpha./m);
    theta = theta - [sum(diff(:, 1)); sum(diff(:, 2))];
    fprintf('theta: %f\n', theta);






    % ============================================================

    % Save the cost J in every iteration    
    J_history(iter) = computeCost(X, y, theta);
    fprintf('J_history: %f\n', J_history);

end
%fprintf('size of diff: %d %d', size(diff, 1), size(diff, 2));

end
