function DualPiano_fftCommon( signal )

Fs = 128;               % Sampling frequency                    
T = 1/Fs;               % Sampling period       
L = size(signal, 2);    % Length of signal

Y = fft( signal );

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);

f = Fs*(0:(L/2))/L;

figure;
plot(f,P1); 
title('Single-Sided Amplitude Spectrum of X(t)');
xlabel('f (Hz)');
ylabel('|P1(f)|');


Fs = 128;               % Sampling frequency                    
T = 1/Fs;               % Sampling period       
L = 2048;               % Length of signal

Z = fft( signal,  2048);

Q2 = abs(Z/L);
Q1 = Q2(1:L/2+1);
Q1(2:end-1) = 2*Q1(2:end-1);

f = Fs*(0:(L/2))/L;

hold on;
plot(f, Q1); 
title('Single-Sided Amplitude Spectrum of X(t)');
xlabel('f (Hz)');
ylabel('|P1(f)|');

end

