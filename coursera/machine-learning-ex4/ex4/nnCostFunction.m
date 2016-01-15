function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));
%disp(size(Theta1_grad));
%disp(size(Theta2_grad));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

X = [ones(m, 1), X];
Z2 = X*Theta1';
A2 = sigmoid(Z2);

A2 = [ones(m, 1), A2];
Z3 = A2*Theta2';
A3 = sigmoid(Z3);
%disp(size(A3));

for i = 1:m
    y_i = zeros(num_labels, 1);
    y_i(y(i), 1) = 1;
    x_i = A3(i, :)';
    J = J + sum((-y_i).*log(x_i) - (1 - y_i).*log(1 - x_i));
end

J = J/m;

jTheta1 = Theta1.^2;
jTheta1(:,1) = zeros(size(jTheta1, 1), 1); %Un-regularize Theta1_Bias

jTheta2 = Theta2.^2;
jTheta2(:,1) = zeros(size(jTheta2, 1), 1); %Un-regularize Theta2_Bias

J = J + ((sum(sum(jTheta1)) + sum(sum(jTheta2)))*lambda)/(2*m);

% Back-propagation
del1 = (Theta1_grad);
%del1 = [ones(1, size(del1, 2)); del1];
%disp(size(del1));

del2 = (Theta2_grad);
%del2 = del2(:, 2:end);
%disp(size(del2));

for t = 1:m
    % Forward pass
    a1 = X(t, :)';
    z2 = Theta1*a1;
    a2 = sigmoid(z2);

    a2 = [1; a2];
    z3 = Theta2*a2;
    a3 = sigmoid(z3);
    %------------------------------%

    % Backward prop

    y_i = zeros(num_labels, 1);
    y_i(y(t), 1) = 1;

    d3 = (a3 - y_i);
    %disp(y_i); disp(a3);

    %d2 = (Theta2_grad'*d3).*(sigmoidGradient(z2)');
    d2 = (Theta2'*d3).*[1; sigmoidGradient(z2)];

    d2 = d2(2:end, :);
    
    del2 = del2 + d3*a2';
    %del2 = del2 + d3*(a2(1, 2:end));
    
    %del1 = del1 + d2*(a1(1, 2:end));
    del1 = del1 + d2*a1';
end

%disp(size(del1));
%disp(size(del2));
Theta1_grad_ur = (del1/m);
Theta2_grad_ur = (del2/m);

%Regularization
Theta1_grad = Theta1_grad_ur;
Theta2_grad = Theta2_grad_ur;
Theta1_grad = Theta1_grad_ur + Theta1*(lambda/m);
Theta2_grad = Theta2_grad_ur + Theta2*(lambda/m);
Theta1_grad(:, 1) = Theta1_grad_ur(:, 1);
Theta2_grad(:, 1) = Theta2_grad_ur(:, 1);









% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
