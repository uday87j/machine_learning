function [rgb, npixels] = choose_dominant_segment(segments, num_pixels)
% Among the given segments, choose & return the one with highest count

[npixels, i] = max(num_pixels);
rgb = segments(i, :);

end
