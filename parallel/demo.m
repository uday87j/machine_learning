1; # this is kept to Prevent Octave from thinking that this is a function file:

close all;
clear all;

function y=test(a,b)
y=sin(a)+cos(b)
endfunction

num_process=4

a_test_inputs=[0:3.14/20:3.14];
b_test_inputs=[0:3.14/20:3.14]*2;

tic ();
tt_par= pararrayfun(num_process,@test,(a_test_inputs),(b_test_inputs));
parallel_elapsed_time = toc ()

tic ();
tt_ser= test((a_test_inputs),(b_test_inputs));
serial_elapsed_time = toc ()


% plot(a_test_inputs,tt_par,'-o',a_test_inputs,tt_ser,'-s');
% legend('Parallel result','Serial result');

figure (1);
plot(a_test_inputs, tt_par, '-o', 'linestyle', '-', 'color', 'r');
legend('Parallel impl')

figure (2);
plot(a_test_inputs, tt_ser, '-o', 'linestyle', '-', 'color', 'b');
legend('Serial impl')

 disp(sprintf('Elapsed time during serial computation is %e',serial_elapsed_time))
 disp(sprintf('Elapsed time during parallel computation is %e',parallel_elapsed_time))

 if (serial_elapsed_time > parallel_elapsed_time)
     disp("\nParallel impl is faster");
 else
     disp("\nSerial impl is faster");
 end
