#! /usr/bin/octave-cli -qf

%% Loads feature vectore present in a file
%% Cluaters them into K vectors

%% Initialization
clear ; close all; clc
addpath('/work/scratch/machine_learning/coursera/machine-learning-ex7/machine-learning-ex7/ex7')

for i = [50, 100, 200, 500, 1000]
    % for j = [50 100]%[20, 50, 100, 150]
    a = now();
    classify_features('./desc_5.txt', './desc_sizes_5.txt', i, './hist_5.mat');
    b = now();
    fprintf("\nclassify_features took time: %f", (b - a));

    a = now();
    classify_hist('./hist_5.mat', './file_names_5.txt', './categories_5.txt', 3, j);
    b = now();
    fprintf("\nclassify_hist took time: %f", (b - a));

    system("python measure_f1.py");
    % end
end

%% Image set2
%% classify_features('./desc_2.txt', './desc_sizes_2.txt', './file_names_2.txt', 'categories_2.txt', 2)
%% Results
%% Use K = 100 for cat/tree (set2) images, accuracy = 88.9%

%% Image set3
% classify_features('./desc_3.txt', './desc_sizes_3.txt', './file_names_3.txt', './categories_3.txt', 2)

%% Image set4
%% classify_features('./desc_4.txt', './desc_sizes_4.txt', './file_names_4.txt', './categories_4.txt', 5)

%% Image set5
%% classify_features('./desc_5.txt', './desc_sizes_5.txt', 100, './hist_6.mat');
%% classify_hist('./hist_6.mat', './file_names_5.txt', './categories_5.txt, 3, 50');

%% Image set6
% classify_features('./desc_6.txt', './desc_sizes_6.txt', './file_names_6.txt', './categories_6.txt', 5)
