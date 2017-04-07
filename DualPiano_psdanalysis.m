function [ data_out ] = DualPiano_psdanalysis( data_in )
% DUALPIANO_PSDANALYSIS estimates the power spectral destiny with
% the following settings:
%   freq range:       0 ... Fs/2 Hz
%   freq resolution:  Fs / L Hz
%
% Params:
%   data_in         fieldtrip data structure
%
% Output:
%   data_out        fieldtrip data structure
%
% This function requires the fieldtrip toolbox
%
% See also FT_FREQANALYSIS

% Copyright (C) 2017, Daniel Matthes, MPI CBS

Fs = data_in.fsample;
L = length(data_in.time{1});

warning('off','all');

cfg                 = [];
cfg.method          = 'mtmfft';
cfg.output          = 'pow';
cfg.channel         = 'all';                                                % calculate spectrum of every channel  
cfg.trials          = 'all';                                                % calculate spectrum for every trial  
cfg.keeptrials      = 'no';                                                 % average over trials
cfg.pad             = 'maxperlen';                                          % non padded fft
cfg.taper           = 'hanning';                                            % hanning taper the segments
cfg.foi             = 0:Fs/L:Fs/2;                                          % range from zero to Fs/2 
cfg.feedback        = 'no';                                                 % suppress feedback output
cfg.showcallinfo    = 'no';                                                 % suppress function call output

data_out = ft_freqanalysis(cfg, data_in);                                   % calculate power spectral density

warning('on','all');

end