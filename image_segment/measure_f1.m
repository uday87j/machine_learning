function [f1] = measure_f1(clusters, count_per_cluster)
% clusters is n x 1, all numbers in the range 1..K
% count_per_cluster is 1 x K

% Calculate f1 = (acc * rec) / (acc + rec)

f1 = 0.0;

for i = 1:10:size(clusters, 1)
    ci = clusters(i:i + count_per_cluster(i) - 1, :);
    [m, i] = max(ci);
    f1 = f1 + (size(find(ci, ci == m), 1) / count_per_cluster(i));
end

end
