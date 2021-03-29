var = 25;   %%%%variance of the noise random sequence
N = 128;
L = 8;
D = 0 ;    %%%%overlap samples
f = -0.5:1/N:0.5*(N-1)/N;
z = exp(-1i*2*pi*f); 
for i = 1:N
   z(i) = 1/z(i);
   H(i) = 1-0.9*z(i)+0.81*z(i)*z(i)-0.729*z(i)*z(i)*z(i);   %%%%%digital filter transfer function
   H(i) = 1/H(i);
end
plot(f,abs(H.^2)*var);    %%%%%Theoretical PSD
title('Theoretical PSD');
xlabel('f');
ylabel('PSD');
