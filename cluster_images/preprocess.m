function [images] = preprocess(image_path, width, height)
% 'image_path' contains the path of images that need to be preprocessed
% the images go through following stages
% 1. Resize to width X height
% 2. Convert to greyscale
% The function returns a vector of preprocessed images
% Each row is an image of size 1 X n
% n, the number of features is width X height

images = [];

fprintf("\nInput path: %s\n", image_path);
files = dir(image_path);
fprintf("\nThere are %d files\n", size(files, 1));

for f = 3:size(files, 1)  % First 2 files are "." & ".."
  [img, map, alpha] = imread(strcat(image_path, "/", files(f).name));
  %img = rgb2gray(img);
  img = imresize(img, [width height]); %disp(size(img));
  images = [images; img(:)'];
end

%imshow(img);


end
