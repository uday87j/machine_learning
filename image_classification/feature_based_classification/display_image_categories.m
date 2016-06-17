function [] = display_image_categories(fname, categories, output_file)

% images = importdata(fname);
fid = fopen(fname);
images = textscan(fid, "%s");
% disp(images);

outf = fopen(output_file, "w");

disp(size(categories));

% for i =1:size(images{1}, 1)
for i =1:size(categories, 1)
    fprintf(outf, "%s,%d\n", images{1}{i, 1}, categories(i));
    % printf("%s,%d\n", images{i}, categories(i));
end

fclose(outf);

end
