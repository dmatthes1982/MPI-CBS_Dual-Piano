function DualPiano_fftCommon( signal, zerop )
% DUALPIANO_FFTCOMMON compares the zero padded and the non padded fourier
% transformation of a signal
%
% Params:
%   signal         time response
%   zerop          use zeropadding

% Copyright (C) 2017, Daniel Matthes, MPI CBS

% -------------------------------------------------------------------------
% Plot signal
% -------------------------------------------------------------------------
Fs = 128;                                                                   % sampling frequency                    
L = size(signal, 2);                                                        % length of signal
time = 0:1/128:(L-1)/128;                                                   % generate time vector
% window = hanning(L).';                                                    % apply window function
window = ones(1,L);

subplot(2,1,1);
plot(time, signal.*window);
title('Signal X(t)');
xlabel('t in s)');
ylabel('V in ?V');

% -------------------------------------------------------------------------
% Estimate the FFT without zero padding
% -------------------------------------------------------------------------
if ~zerop
  Y = fft( signal.*window );                                                % FFT without zero padding

  P2 = abs(Y/L);
  P1 = P2(1:L/2+1);
  P1(2:end-1) = 2*P1(2:end-1);                                              % one-side amplidute spectrum

  f = Fs*(0:(L/2))/L;                                                       % frequency vector
  
  subplot(2,1,2);
  plot(f,P1);                                                               % plot spectrum
  title('Single-Sided Amplitude Spectrum of X(t)');
  xlabel('f in Hz');
  ylabel('|P1(f)|');

% -------------------------------------------------------------------------
% Estimate the FFT including zero padding
% -------------------------------------------------------------------------
else  
  L = 2048;                                                                 % length of signal

  Z = fft( signal,  2048);                                                  % FFT including zero padding

  Q2 = abs(Z/L);
  Q1 = Q2(1:L/2+1);
  Q1(2:end-1) = 2*Q1(2:end-1);                                              % one-side amplidute spectrum

  f = Fs*(0:(L/2))/L;                                                       % frequency vector

  subplot(2,1,2);
  plot(f, Q1);                                                              % plot spectrum
  title('Single-Sided Amplitude Spectrum of X(t)');
  xlabel('f (Hz)');
  ylabel('|P1(f)|');
end

end

