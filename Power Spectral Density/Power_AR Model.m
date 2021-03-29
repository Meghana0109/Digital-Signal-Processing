var = 25;                      %%%variance of random sequence
N = 128;                       %%%sample size
r = sqrt(var)*randn(N,1);      %%generating white gaussian noise
freq = linspace(-pi,pi,N);
f = -1:2/N:1;
a0 = [1 -.9]; a1 = [1 -.9i]; a2 = [1 .9i];  
b = 1;
a = [1 -0.9 0.81 -0.729];     %%%%denominator of transfer function of the filter
x1 = filter(b,a,r);           %%%%%passing noise through filter

Rxx = zeros(1,4);             %%%%defining an array for correlation functions
for m=0:3
sum1 = 0;
for n=0:(N-m-1)
sum1 = sum1+(1/N)*x1(n+m+1)*x1(n+1);   %%%calculating correlations
end
Rxx(m+1) = sum1;
end
A = [Rxx(1) Rxx(2) Rxx(3) ; Rxx(2) Rxx(1) Rxx(2) ; Rxx(3) Rxx(2) Rxx(1)];
B = [-Rxx(2) ; -Rxx(3); -Rxx(4)];
B1 = inv(A)*B;
a(1) = 1;
for i=2:4
a(i) = B1(i-1);              %%%%parameters of transfer function in the AR Model
end
a
estimated_variance = Rxx(1) + a(2)*Rxx(2) + a(3)*Rxx(3) + a(4)*Rxx(4)   %%%%estimated variance of the noise using correlation properties
P_YW = zeros(1,N);
for i = 5:N
a(i) = 0;
end

A1 = fftshift(fft(a));
YW = abs(A1).^2;      
for i = 1:N
P_YW(i) = (estimated_variance)/YW(i);     %%%%psd using AR Model
end
plot(f(1:N),P_YW);
title('Yule Walker Spectrum');
xlabel('f');
ylabel('PSD');
