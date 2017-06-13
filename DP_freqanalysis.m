function [ data_out ] = DP_freqanalysis(data_in)
% DP_FREQANALYSIS performs a time frequency analysis with the 
% following settings:
%   freq range:       1...30 Hz
%   freq resolution:  1 Hz
%   time of interest: each sample
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

warning('off','all');

cfg                 = [];
cfg.method          = 'mtmconvol';
cfg.output          = 'pow';
cfg.channel         = 'all';                                                % calculate spectrum of every channel  
cfg.trials          = 'all';                                                % calculate spectrum for every trial  
cfg.keeptrials      = 'yes';                                                % do not average over trials
cfg.pad             = 'nextpow2';                                           % use fast calculation method
cfg.taper           = 'hanning';                                            % hanning taper the segments
cfg.foi             = 1:1:30;                                               % analysis from 1 to 30 Hz in steps of 1 Hz 
cfg.t_ftimwin       = ones(length(cfg.foi),1).*1;                           % length of time window = 1 sec
cfg.toi             = 'all';                                                % spectral estimates on each sample
cfg.feedback        = 'no';                                                 % suppress feedback output
cfg.showcallinfo    = 'no';                                                 % suppress function call output

data_out = ft_freqanalysis(cfg, data_in);                                   % calculate time frequency responses

warning('on','all');

end