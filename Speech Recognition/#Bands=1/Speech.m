[x,Fs]=audioread("letters.wav");    %%%audioread

Ts = 1/Fs;
N=length(x);
t=0:Ts:(N-1)*Ts;
Fo = [16,50,160,500];
n = 1;   %%%no of bands
f = -Fs/2:Fs/N:(N-1)*Fs/(2*N);
figure(1);
plot(t,x);
xlabel("Time");
ylabel("Amplitude");
title("Our signal");

%%%dividng into frequency bands
x1 = zeros(n,(N/n));
for i = 1:n
    for j = 1:(N/n)
        x1(i,j) = x(j+(i-1)*(N/n));
    end
    figure(i+1);
    plot(t((1+(i-1)*(N/n)):i*N/n),x1(i,:));
    xlabel('Time');
    ylabel('Amplitude');
    title(sprintf('Signal for band %d',i))
end
X1 = zeros(n,N/n);
s = rand(N,1);
Xf = fftshift(fft(x,N));

%%%fft of each band
for i = 1:n
    X1(i,:) = fftshift(fft(x1(i,:))); 
    figure(n+1+i)
    plot(f((1+(i-1)*(N/n)):i*N/n),abs(X1(i,:)));
    xlabel('Frequency');
    ylabel('Magnitude');
    title(sprintf('FFT of band %d',i))
end
figure(2*n+2);
plot(f,abs(Xf));
xlabel("Frequency");
ylabel("Magnitude");
title("FFT of our audio signal");

[b,a]=butter(2,[1000 5000]/(Fs/2),'bandpass');
%%%passing each band through a bandpass filter
band_filter = zeros(n,N/n);
band_fft = zeros(n,N/n);
for i = 1:n
    band_filter(i,:) = filter(b,a,x1(i,:));
    band_fft(i,:) = fftshift(fft(band_filter(i,:)));
end
for i = 1:n
    figure(2*n+2+i)
    plot(t((1+(i-1)*(N/n)):i*N/n),band_filter(i,:));
    xlabel('Time');
    ylabel('Magnitude');
    title('Filtered signal for band ',i);
end
for i = 1:n
    figure(3*n+2+i)
    plot(f((1+(i-1)*(N/n)):i*N/n),abs(band_fft(i,:)));
    xlabel('Frequency');
    ylabel('Magnitude');
    title(sprintf('Filtered FFT of band %d',i));
end

%%%% half wave rectification of each band
band_half_rect = zeros(n,N/n);
band_rect = zeros(n,N/n);
for i = 1:n
    band_half_rect(i,:) = band_filter(i,:) > 0;
    band_rect(i,:) = band_filter(i,:).*band_half_rect(i,:);
    figure(4*n+2+i);
    plot(t((1+(i-1)*(N/n)):i*N/n),band_rect(i,:));
    xlabel("Time");
    ylabel("Amplitude");
    title(sprintf('Half-wave rectified signal for band %d',i));
end

%Envelope extracted
lp_b = zeros(4,3);
lp_a = zeros(4,3);
for i = 1:4
    [lp_b(i,:),lp_a(i,:)] = butter(2,Fo(i)*(2/Fs),'low');
end
for F=1:4
env_signal = zeros(n,N/n);
    for i = 1:n
    env_signal(i,:) = filter(lp_b(F,:),lp_a(F,:),band_rect(i,:));
    figure((5)*n+2+i+(2*n+3)*(F-1));
    plot(t((1+(i-1)*(N/n)):i*N/n),env_signal(i,:));
    xlabel('Time');
    ylabel('Amplitude');
    title(sprintf('Lowpass filtered envelope for band %d and Fo=%dkHz',i,Fo(F)));
    end


%%%modulation with noise
noise = 0;
modulated_signal = zeros(n,N/n);
modulated_signal = env_signal + noise;

%%%%passing the noise modulated signal through bandpass filter
bandpass_modulated = zeros(n,N/n);
for i = 1:n
    bandpass_modulated(i,:) = filter(b,a,modulated_signal(i,:));
    figure(6*n+2+i+(2*n+3)*(F-1));
    plot(t((1+(i-1)*(N/n)):i*N/n),bandpass_modulated(i,:));
    xlabel('Time');
    ylabel('Amplitude');
    title(sprintf('Modulated signal after passing through bandpass filter for band %d',i));
end
%%%%combining the bands
combined_signal = zeros(1,N);
env_combined = zeros(n,N/n);
k=1;
for i = 1:n
    for j = 1:N/n
        combined_signal(k) = bandpass_modulated(i,j);
        env_combined(k)= env_signal(i,j);
        k = k+1;
    end
end
pow = sum(env_combined.^2);
figure(7*n+3+(2*n+3)*(F-1));
plot(t,combined_signal);
xlabel('Time');
ylabel('Amplitude');
title('Combined signal of all the bands');
%%%%passing through low pass filter at 4kHz
[b1,a1] = butter(2,8e3*Ts,'low');
output_signal = filter(b1,a1,combined_signal);
figure(7*n+4+(2*n+3)*(F-1));
plot(t,output_signal);
xlabel('Time');
ylabel('Amplitude');
title('Output signal after low pass filtering at F=4kHz');

%%%%amplification of output signal
if(F==1) amp = output_signal*(10e4);
elseif(F==2) amp = output_signal*(10e3);
elseif(F==3) amp = output_signal*(10e2);
else amp = output_signal*(10e1);
end
figure(7*n+5+(2*n+3)*(F-1));
plot(t,amp);
xlabel('Time');
ylabel('Amplitude');
title('Amplified signal after low pass filtering at F=4kHz');
%%%%audiowrite
if(F==1) audiowrite('b1_16.wav',amp,Fs);
elseif(F==2) audiowrite('b1_50.wav',amp,Fs);
elseif(F==3) audiowrite('b1_160.wav',amp,Fs);
else audiowrite('b1_500.wav',amp,Fs);
end
end


