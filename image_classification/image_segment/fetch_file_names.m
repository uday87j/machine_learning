function [files] = fetch_file_names(directory)

% fprintf("\nInput path: %s\n", image_path);
files = dir(directory);

files = files(3:size(files, 1), :);  % First 2 files are "." & ".."

end
