% Main file that runs the image clustering algorithm

seg = preprocess("../test_images/set1", 100, 100);

c = cluster_images(seg, 3);
disp(c);

f1 = measure_f1(c, [10, 10, 10]);
fprintf("\nF1 score: %f", f1);

pause;
