function DualPiano_fftCommon( signal )
% DUALPIANO_FFTCOMMON compares the zero padded and the non padded fourier
% transformation of a signal
%
% Params:
%   signal         time response

% Copyright (C) 2017, Daniel Matthes, MPI CBS

% -------------------------------------------------------------------------
% Estimate the FFT without zero padding
% -------------------------------------------------------------------------
Fs = 128;                                                                   % sampling frequency                    
L = size(signal, 2);                                                        % length of signal

Y = fft( signal );                                                          % FFT without zero padding

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);                                                % one-side amplidute spectrum

f = Fs*(0:(L/2))/L;                                                         % frequency vector

figure;                                                                     % plot spectrum
plot(f,P1); 
title('Single-Sided Amplitude Spectrum of X(t)');
xlabel('f (Hz)');
ylabel('|P1(f)|');

% -------------------------------------------------------------------------
% Estimate the FFT including zero padding
% -------------------------------------------------------------------------
Fs = 128;                                                                   % sampling frequency                    
L = 2048;                                                                   % length of signal

Z = fft( signal,  2048);                                                    % FFT including zero padding

Q2 = abs(Z/L);
Q1 = Q2(1:L/2+1);
Q1(2:end-1) = 2*Q1(2:end-1);                                                % one-side amplidute spectrum

f = Fs*(0:(L/2))/L;                                                         % frequency vector

hold on;
plot(f, Q1);                                                                % plot spectrum
title('Single-Sided Amplitude Spectrum of X(t)');
xlabel('f (Hz)');
ylabel('|P1(f)|');

end

