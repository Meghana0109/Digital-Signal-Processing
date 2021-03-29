key = {'1','2','3','A','4','5','6','B','7','8','9','C','*','0','#','D'};   %%%%keys on the keypad
lfg = [697 770 852 941];                                                   % Low frequency group
hfg = [1209 1336 1477 1633];                                               % High frequency group
f = [];
for c=1:4
for r=1:4
f = [ f [lfg(c);hfg(r)] ];                                                 %%set of two frequencies
end
end
Fs = 8000;                                                                 %%sampling rate
N = 800;                                                                   %%%sample size
t = (0:N-1)/Fs;
Ts = 1/Fs;
freq=-(1*Fs)/2:Fs/N:(N-1)*Fs/(2*N);
pit = 2*pi*t;
tones = zeros(N,size(f,2));
for i=1:16
% Generate tone
tones(:,i) = sum(sin(f(:,i)*pit))';                                        %%%%generating sinusoidal signals
end
%%%%%%decoder part
for k = 1:16
x = tones(:,k);
h = zeros(8,N);
hd = zeros(N,8);
y = zeros(N,8);
for i = 1:8
for j= 1:N
if(i<=4)
h(i,j) = 2*cos(2*pi*Ts*lfg(i)*(j-1));                                   %%%filter design for each frequency
else
h(i,j) = 2*cos(2*pi*Ts*hfg(i-4)*(j-1));
end
end
hd(:,i) = conv(x,transpose(h(i,:)),'same');                            %%passing the generated signal through designed filter
y(:,i) = fftshift(fft(hd(:,i)));                                       %%fft of signal after passing through filter bank
end
y1 = fftshift(fft(x));                                                 %%%fft of unfiltered signal

y_sum = sum(transpose(y));                                             %%absolute value of filtered signal
figure(k+1);
subplot(2,1,1);
plot(freq,abs(y1)/N);
title(['Fourier Transform of signal of f1=',num2str(f(1,k)),' and f2=',num2str(f(2,k))]);
xlabel('Frequency');
ylabel('Amplitude');
subplot(2,1,2);
plot(freq,abs(y_sum)/(N*N));
title(['Output of signal of f1=',num2str(f(1,k)),' and f2=',num2str(f(2,k)),' through filter bank']);
xlabel('Frequency');
ylabel('Amplitude');
end
