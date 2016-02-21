function [] = rename_images(directory, ext, base_name)
% Rename images based on indeces

% Find files of extension ext
all_files = dir(directory);

for f = 1:size(all_files, 1)
    fname = all_files(f).name;
    % disp(fname);
    if (!isempty(regexp(fname, ext)))
        src_name = strcat(directory, "/", fname);   % disp(src_name);
        dst_name = strcat(directory, "/", base_name, num2str(f), ".", ext);   % disp(dst_name);

        if (0 == exist(dst_name))
            [err, msg] = rename(src_name, dst_name);

            if (err != 0)
                disp(msg);
            end
        end
    end
end

end
