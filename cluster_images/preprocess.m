function [images] = preprocess(image_path, width, height, reduced_dim)
% 'image_path' contains the path of images that need to be preprocessed
% the images go through following stages
% 1. Resize to width X height
% 2. Convert to greyscale
% The function returns a vector of preprocessed images
% Each row is an image of size 1 X n
% n, the number of features is width X height

images = [];

if ~exist('reduced_dim', 'var') || isempty(reduced_dim) 
  reduced_dim = 2;
end

fprintf("\nInput path: %s\n", image_path);
files = dir(image_path);
fprintf("\nThere are %d files\n", size(files, 1));

for f = 3:size(files, 1)  % First 2 files are "." & ".."
  
  disp(files(f).name);
  [img, map, alpha] = imread(strcat(image_path, "/", files(f).name));

  %img = rgb2gray(img);
  img = imresize(img, [width height]); %disp(size(img));

  X = img(:)';
  X = double(X);    % For PCA's covariance multiplication
  
  images = [images; X];

end

disp(size(images));

% Run PCA
% -----------------------------------------
[X_norm, mu, sigma] = featureNormalize(images);

[U, S] = pca(X_norm);
Ureduce = U(:, 1:reduced_dim);
% -----------------------------------------

images = (images * Ureduce);

disp(size(X_norm));
disp(size(U));
disp(size(Ureduce));


%imshow(img);


end
