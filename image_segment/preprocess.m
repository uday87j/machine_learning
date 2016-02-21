function [segments] = preprocess(image_path, width, height)
% 'image_path' contains the path of images that need to be preprocessed
% Assume: This directory contains only images and no sub-directories
% TODO: Avoid this assumption

% the images go through following stages
% 1. Segment each image into 3 clusters
% 2. Compute the mean rgb of dominant segment

% The function returns a vector of [mean_RGB, num_elements]

segments = [];


% fprintf("\nInput path: %s\n", image_path);
% files = dir(image_path);
% nimages = (size(files, 1) - 2);

files = fetch_file_names(image_path);
nimages = size(files, 1);
fprintf("\nThere are %d files\n", nimages);

dseg = zeros(nimages, 3);
npix = zeros(nimages, 1);

NS = 2; % Number of segments required in each image

for f = 1:size(files, 1)  % First 2 files are "." & ".."

  % disp(files(f).name);
  
  % Read the image
  [img, map, alpha] = imread(strcat(image_path, "/", files(f).name));

  img = imresize(img, [width height]);

  [seg, npixels] = create_image_segments(img, NS);

  [dseg(f, :), npix(f)] = choose_dominant_segment(seg, npixels);

  % Try using all segments & pixel_count in feature vector

end
%disp(dseg);
%disp(npix);

segments = dseg;
disp(size(segments));

end
