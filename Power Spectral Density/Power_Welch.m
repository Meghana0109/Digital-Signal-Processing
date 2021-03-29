var = 25;                                       %%%variance of the random sequence
N = 128;                                        %%%%sample size
L = 8;                                          %%%no of blocks
D = 0;                                          %%overlap samples
M = N/L;                                        %%%%size of each block
r = sqrt(var)*randn(N,1);                       %%generating white gaussian noise
freq = linspace(-pi,pi,N);                      %%%frequency
a0 = [1 -.9]; a1 = [1 -.9i]; a2 = [1 .9i];
b = 1;
a = [1 -0.9 0.81 -0.729];                       %%%%%denominator of digital filter transfer function
x1 = filter(b,a,r);                             %%%%%passing the random noise through filter 

w = hamming(M);                                 %%%%%hamming window function of length M(block size)
x = zeros(L,M);
for i = 1:L
for j = 1:M
x(i,j) = x1(j+((i-1)*(M-D)));                   %%%%%%splitting the sequence to L blocks
end
end
U = 1/M*sum(w.*(w));                            %%normalisation factor
f = -1:2/N:1;
Pxx = zeros(L,N);                               
sum1 = 0;
for i=1:L
for j=1:N
xr = zeros(1,N);                                
for n = 1:M
xr(n) = x(i,n)*w(n);                            %%%passing filtered sequence through window function
end
y = abs(fftshift(fft(xr))).^2/(M*U);            %%%%%psd for each block
Pxx(i,j) = y(j);
end
end

for i= 1:N
   P_welch(i) = (1/L)*sum(Pxx(:,i));            %%%%averaging psd of all blocks to get psd of noise(Welch PSD)
end
plot(f(1:N),P_welch)
xlabel('f');
ylabel('PSD');
title('Welch Spectrum');
