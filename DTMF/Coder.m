%%%%%coder part
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
subplot(4,4,i);
plot(t*1e3,tones(:,i));
title(['Symbol "', key{i},'": [',num2str(f(1,i)),',',num2str(f(2,i)),']'])
set(gca, 'Xlim', [0 25]);
ylabel('Amplitude');
xlabel('Time(ms)');
end
