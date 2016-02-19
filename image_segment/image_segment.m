function [segments] = image_segment(image_name, num_segments)
% Create segments in an image based on pixel values

K = num_segments;
cluster_colours = [0:64/K:63];  % Based on default colourmap()

[img, map, alpha] = imread(image_name);

%img = rgb2gray(img);    % Try RGB later

[iimg, cmap] = rgb2ind(img);
save -ascii "ind.txt" iimg;

width = size(iimg, 1);
height = size(iimg, 2);

pix = iimg(:);
X = zeros(size(pix, 1), 3); % 3 for RGB

disp(size(pix));
disp(size(X));
disp(size(cmap));

for i = 1:size(pix, 1)
    %disp(i);
    %disp(pix(i));
    X(i, :) = cmap(pix(i) + 1, :);  % cmap indexing start from 0
end

%[idx] = find_min_kmeans(X, 20, 30, 2);

initial_centroids = kMeansInitCentroids(X, num_segments);
[centroids, idx] = runkMeans(X, initial_centroids, 10, false);
%disp(size(idx));

rec_img = zeros(size(idx));

% Colour code rec_img based on idx val
for i = 1:size(idx, 1)
    rec_img(i) = cluster_colours(idx(i));
end

rec_img = reshape(rec_img, width, height);
%save -ascii "segments.txt" rec_img

figure(1);
imshow(img);
%save -ascii "image.txt" img

figure(2);
image(rec_img);

disp("\nDone plotting images");

segments = rec_img;

end
