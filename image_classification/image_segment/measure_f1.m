function [f1] = measure_f1(clusters, count_per_cluster)
% clusters is n x 1, all numbers in the range 1..K
% count_per_cluster is 1 x K

% Calculate f1 = (acc * rec) / (acc + rec)

f1 = 0.0;
nclusters = size(count_per_cluster, 2);

modes = [];

j = 1;
for i = 1:nclusters
    ci = clusters(j:j + count_per_cluster(i) - 1, :);
    % disp(ci);

    m = mode(ci);
    while (any(modes == m))
        ci = ci(find(ci != m));
        m = mode(ci);
    end

    modes = [modes; m];
    disp(m);
    
    f1 = f1 + (size(find(ci == m), 1) / count_per_cluster(i));
    j = j + count_per_cluster(i);
end

f1 = (f1 / nclusters);

end
