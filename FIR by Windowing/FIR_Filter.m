N= 8;
Fs= 6e3;
t= 0:1/Fs:(N-1)/Fs;
Wc = 0.3*pi;
Hd = zeros(1,N);
k= ceil((N-1)/2);
for i=1:N
if(i==k)
continue
end
Hd(i)= (sin(Wc*(i-k)))/(pi*(i-k));
end
Hd(k) = Wc/pi;
stem(t,Hd);
xlabel('Time(sec)');
ylabel('Amplitude');
title('Sampled Signal at Fs = 6kHz and N = 8 sample points');

w = rectwin(N); %% rectangular window

h = Hd.*transpose(w);

W = -pi:pi/10e3:pi;
freqz(h,1,W);

N= 64;
t= 0:1/Fs:(N-1)/Fs;
Hd = zeros(1,N);
k= ceil((N-1)/2);
for i=1:N
if(i==k)
continue
end
Hd(i)= (sin(Wc*(i-k)))/(pi*(i-k));
end
hd(k) = Wc/pi;
stem(t,Hd);
xlabel('Time(sec');
ylabel('Amplitude');
title('Sampled Signal at Fs = 6kHZ and N = 64 sample points');

w = rectwin(N);

h = Hd.*transpose(w);

W = -pi:pi/10e3:pi;
freqz(h,1,W);

N= 512;

t= 0:1:(N-1);
wc = 0.3*pi;
Hd = zeros(1,N);
k= ceil((N-1)/2);
for i=1:N
if(i==k)
continue
end
Hd(i)= (sin(0.3*pi*(i-k)))/(pi*(i-k));
end
Hd(k) = 0.3;
stem(t,Hd);
xlabel('Time(sec)');
ylabel('Amplitude');
title('Sampled signal at Fs = 6kHz and N = 512 sample points');

w = rectwin(N);
h = Hd.*transpose(w);
W = -pi:pi/10e3:pi;
freqz(h,1,W);

w = ones(1,N);

h = Hd.*(w);
W = -pi:0.01:pi;
filter_3=freqz(h,1,W);

