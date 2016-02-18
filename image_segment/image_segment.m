function [segments] = image_segment(image_name, num_segments)

[img, map, alpha] = imread(image_name);

img = rgb2gray(img);    % Try RGB later

width = size(img, 1);
height = size(img, 2);

X = img(:)';    % Get a row vector of all pixels in image

initial_centroids = kMeansInitCentroids(X, num_segments);

[centroids, idx] = runkMeans(X, initial_centroids, 10, false);

rec_img = reshape(idx, width, height);

%imshow(rec_img);
segments = rec_img;

end
