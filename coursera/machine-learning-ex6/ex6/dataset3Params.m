function [C, sigma] = dataset3Params(X, y, Xval, yval)
%EX6PARAMS returns your choice of C and sigma for Part 3 of the exercise
%where you select the optimal (C, sigma) learning parameters to use for SVM
%with RBF kernel
%   [C, sigma] = EX6PARAMS(X, y, Xval, yval) returns your choice of C and 
%   sigma. You should complete this function to return the optimal C and 
%   sigma based on a cross-validation set.
%

% You need to return the following variables correctly.
%C = 1;
%sigma = 0.3;

% ====================== YOUR CODE HERE ======================
% Instructions: Fill in this function to return the optimal C and sigma
%               learning parameters found using the cross validation set.
%               You can use svmPredict to predict the labels on the cross
%               validation set. For example, 
%                   predictions = svmPredict(model, Xval);
%               will return the predictions on the cross validation set.
%
%  Note: You can compute the prediction error using 
%        mean(double(predictions ~= yval))
%
%C = 0.01;
%sigma = 0.01;

try_values = [0.01, 0.03, 0.1, 0.3, 1, 3, 10, 30];
errors = [];

%Cval = 0.3;
for Cval = try_values
    for Sval = try_values
        model   = svmTrain(X, y, Cval, @(x1, x2) gaussianKernel(x1, x2, Sval));
        err  = mean(double(svmPredict(model, Xval) ~= yval));
        errors = [errors; err];
    end
end
%disp(errors);
save -ascii "err.txt" errors;
[min_err, ei]   = min(errors);
fprintf('\nMin error: %f, index: %d', min_err, ei);

% Optimim values
div = size(try_values, 2);
%disp((ei/div));
C = try_values(floor(ei/div) + 1);
sigma = try_values(floor(mod(ei,div)));
fprintf('\nOptimum values of C = %f, sigma = %f', C, sigma);

% Train the SVM with optimum C & sigma
%model= svmTrain(X, y, C, @(x1, x2) gaussianKernel(x1, x2, sigma));
%visualizeBoundary(X, y, model);

C = 1.0;
sigma = 0.1;







% =========================================================================

end
