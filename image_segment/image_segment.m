function [segments] = image_segment(image_name, num_segments)
% Create segments in an image based on pixel values

K = num_segments;
cluster_colours = [0:64/K:63];  % Based on default colourmap()

[img, map, alpha] = imread(image_name);

%img = rgb2gray(img);    % Try RGB later

[ind_img, cmap] = rgb2ind(img);
save -ascii "ind.txt" ind_img;

width = size(ind_img, 1);
height = size(ind_img, 2);

pix = ind_img(:);
X = zeros(size(pix, 1), 3); % 3 for RGB

% disp(size(pix));
% disp(size(X));
% disp(size(cmap));

for i = 1:size(pix, 1)
    %disp(i);
    %disp(pix(i));
    X(i, :) = cmap(pix(i) + 1, :);  % cmap indexing start from 0
end

save -ascii "X.txt" X;

%[idx] = find_min_kmeans(X, 20, 30, 2); $TODO: Enable this later if necesasry

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

% TODO: Display figure 3 with mean pixel RGB of categories
mean_k_pixels = zeros(K, 3);
for i = 1:K
    Xk = get_category(X, idx, i);
    disp(size(Xk));
    mean_k_pixels(i, :) = (sum(Xk, 1) / size(Xk, 1));
    set_category(X, idx, mean_k_pixels(i), i);
end

figure(3);
image(X);
%imshow(X);

disp("\nDone plotting images");

segments = rec_img;

end
