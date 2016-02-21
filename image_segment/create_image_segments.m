function [segments, num_pixels] = create_image_segments(img, num_segments)
% Create segments in an image based on pixel values

% Return vector of [RGB of segments, number of pixels in that segment]

% Read the image
%[img, map, alpha] = imread(image_name);

% disp("\nOriginal image: "); disp(size(img));    % width x height x 3 (RGB)
width = size(img, 1);
height = size(img, 2);

% Prepare pixels for clustering
img_2d = reshape(img, width*height, 3);
img_2d = double(img_2d);
% disp("\nOriginal image converted to 2D: "); disp(size(img_2d));    % length x 3 (RGB)
% save "img_2d.txt" img_2d;

% K-means initializers
K = num_segments;
max_rand_iters = 5;
max_kmeans_iters = 10;
clusters = find_min_kmeans(img_2d, max_rand_iters, max_kmeans_iters, K);
% disp("\nFound a minimum cost K-means clustering iteration");
% save -ascii "clusters.txt" clusters;

% Assign mean-pixel values to each pixel of a segment
mean_k_pixels = zeros(K, 3);
%Y = zeros(size(img_2d));

segments = zeros(K, 3); % K segments of RGB
num_pixels = zeros(K, 1);   % pixels per segment

for i = 1:K
    
    Xk = get_category(img_2d, clusters, i);
    %fprintf("\nNo. of points in cluster %d: ", i); disp(size(Xk));

    mean_k_pixels(i, :) = (sum(Xk, 1) / size(Xk, 1));
    %fprintf("\nMean-pixel value of cluster %d: %f, %f, %f", i); disp(mean_k_pixels(i, :));
    
    %Y = set_category(Y, clusters, mean_k_pixels(i, :), i);

    segments(i, :) = mean_k_pixels(i, :);
    num_pixels(i) = size(Xk, 1);

end
% save -ascii "Y.txt" Y;

% Create segmented matrix
% segments = reshape(Y, width, height, 3);
% disp(size(segments));
% save -ascii "segments.txt" segments;

% Convert matrix to image
% segments = uint8(segments);


% Display segmented image
% figure(1);
% imshow(segments);
% title("Segmented mean-pixel image");

% sg = mat2gray(segments);
% figure(2);
% imshow(sg);
% title("Segmented Grey-sclale image");

% figure(3);
% imshow(img);
% title("Original image");

% disp("\nDone creating segments");

end
