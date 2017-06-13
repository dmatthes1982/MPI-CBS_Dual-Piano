function [ data_out ] = DP_freqanalysis_seg( data_in )
% DP_FREQANALYSIS_SEG estimates the TFR of a certain phrase of the
% DualPiano data. With the following parameters: time window length - 1sec,
% Overlap - 50%, Frequency range - 0:1:64 Hz%
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
cfg.method          = 'mtmconvol';
cfg.output          = 'pow';
cfg.channel         = 'all';                                                % calculate spectrum of every channel  
cfg.trials          = 'all';                                                % calculate spectrum for every trial  
cfg.keeptrials      = 'no';                                                 % average over trials
cfg.pad             = 'maxperlen';                                          % non padded fft
cfg.taper           = 'hanning';                                            % hanning taper the segments
cfg.foi             = 0:1:Fs/2;                                             % analysis from 1 to Fs/2 Hz in steps of 1 Hz 
cfg.t_ftimwin       = ones(length(cfg.foi),1).*1;                           % length of time window = 1 sec
% note that the FFT of the last time point will only be calculated, if you 
% change the < sign in line 348 of ft_specext_mtmconvol to <=
cfg.toi             = (4+0.5-1/Fs):0.5:(7.5-1/Fs);                          % spectral estimates for every 500 ms  
cfg.feedback        = 'no';                                                 % suppress feedback output
cfg.showcallinfo    = 'no';                                                 % suppress function call output

data_out = ft_freqanalysis(cfg, data_in);                                   % calculate time frequency responses

warning('on','all');

end

