function DualPiano_psdPlot( signal, psd, varargin )
% DUALPIANO_PSDPLOT
%
%
% Params:
%   signal          time response
%   psd             power spectral densitiy
%
% Varargin:
%   panel           specifies the panel of a figure in which is plotted. If
%                   panel == 0, no panels are used.
%   timeOffset      offset for the time axis in figure one
%   Fs              sampling frequency

% Copyright (C) 2017, Daniel Matthes, MPI CBS

% -------------------------------------------------------------------------
% Check input
% -------------------------------------------------------------------------
switch length(varargin)
  case 0
    Fs            = 128;                                                    % sampling frequency                    
    timeOffset    = 0;                                                      % no Offset for the time axis is given
    panel         = 0;                                                      % figure is not divided into panels
  case 1
    Fs            = 128;
    timeOffset    = 0;
    panel         = varargin{1};
  case 2
    Fs            = 128;
    timeOffset    = varargin{2};
    panel         = varargin{1};
  otherwise
    Fs            = varargin{3};
    timeOffset    = varargin{2};
    panel         = varargin{1};
end

% -------------------------------------------------------------------------
% Plot signal
% -------------------------------------------------------------------------
L = size(signal, 2);                                                        % length of signal
time = timeOffset:1/Fs:(timeOffset+(L-1)/Fs);                               % generate time vector
% window = hanning(L).';                                                    % apply window function
window = ones(1,L);

if panel == 0
  subplot(2,1,1);
else
  subplot(2,1,1, 'Parent', panel);
end
plot(time, signal.*window);
title('Signal X(t)');
xlabel('t in sec');
ylabel('V in \muV');

% -------------------------------------------------------------------------
% Plot PSD
% -------------------------------------------------------------------------
f = Fs*(0:(L/2))/L;                                                         % frequency vector

if panel == 0
  subplot(2,1,2);
else
  subplot(2,1,2, 'Parent', panel);
end
plot(f,10*log10(psd));                                                        % plot spectrum in dB
title('Single-Sided Amplitude Spectrum of X(t)');
xlabel('frequency (Hz)');
ylabel('power/frequency (dB/Hz)');

