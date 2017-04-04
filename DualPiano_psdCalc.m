function [ psd ] = DualPiano_psdCalc( signal, zerop, varargin )
% DUALPIANO_PSDCOMMON estimates the zero padded or the non padded power
% spectral densitiy of a signal
%
% Params:
%   signal         time response
%   zerop          use zeropadding
%
% Varargin:
%   Fs             sampling frequency
%
% Output:
%   psd            power spectral densitiy

% Copyright (C) 2017, Daniel Matthes, MPI CBS

% -------------------------------------------------------------------------
% Check input
% -------------------------------------------------------------------------
switch length(varargin)
  case 0
    Fs            = 128;                                                    % sampling frequency                    
  otherwise
    Fs            = varargin{1};
end

% -------------------------------------------------------------------------
% Estimate the FFT without zero padding
% -------------------------------------------------------------------------
if ~zerop
  L = size(signal, 2);                                                      % length of signal
% window = hanning(L).';                                                    % apply window function
  window = ones(1,L);

  Y = fft( signal.*window );                                                % FFT without zero padding
  Y1 = Y(1:floor(L/2)+1);                                                   % one-side spectrum
  
  psd = (1/(Fs*L)) * abs(Y1).^2;                                            % calculate absolute power (psd)
  psd(2:end-1) = 2*psd(2:end-1);
  
% -------------------------------------------------------------------------
% Estimate the FFT including zero padding
% -------------------------------------------------------------------------
else  
  L = 2048;                                                                 % length of signal
% window = hanning(L).';                                                    % apply window function
  window = ones(1,L);
  
  Y = fft( signal.*window,  2048);                                          % FFT including zero padding
  Y1 = Y(1:floor(L/2)+1);                                                   % one-side spectrum
  
  psd = (1/(Fs*L)) * (abs(Y1).^2);                                          % calculate absolute power (psd)
  psd(2:end-1) = 2*psd(2:end-1);                                              
end

end

