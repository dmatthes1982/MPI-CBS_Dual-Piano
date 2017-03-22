function [ data_out ] = DualPiano_fieldtripPhase( data_in, lfreq, hfreq, trial, cmp1, cmp2 )
% DUALPIANO_FIELDTRIPPHASE estimates the phase difference between two eeg
% components using FT_FREQANALYSIS and FT_CONNECTIVITYANALYSIS
%
% Params:
%   data_in         fieldtrip data structure
%   lfreq           lower cutoff frequency
%   hfreq           higher cutoff frequency
%   trial           number of the selected trial
%   cmp1            number of the first component
%   cmp2            number of the second component
%
% Output:
%   data_out        fieldtrip data structure
%
% This function requires the fieldtrip toolbox
%
% See also FT_FREQANALYSIS, FT_CONNECTIVITYANALYSIS

% Copyright (C) 2017, Daniel Matthes, MPI CBS

cfg             = [];
cfg.method      = 'mtmconvol';
cfg.output      = 'powandcsd';                                              % important for the susequent connectivity analysis
cfg.channel     = cell([data_in.label(cmp1); data_in.label(cmp2)]);         % define the two components
cfg.channelcmb  = cell([data_in.label(cmp1), data_in.label(cmp2)]);
cfg.trials      = 'all';                                                    % calculate spectrum for every trial    
cfg.keeptrials  = 'yes';
cfg.pad         = 'nextpow2';                                               % use fast calculation method
cfg.taper       = 'hanning';                                                % hanning taper the segments
cfg.foi         = (hfreq-lfreq):(hfreq-lfreq):40;                           % analysis to 40 Hz (bandwith: hfreq-lfreq)
cfg.t_ftimwin   = ones(length(cfg.foi),1).*(1/(hfreq-lfreq));               % length of time window 
cfg.toi         = 'all';                                                    % spectral estimates on each sample

TFRhann = ft_freqanalysis(cfg, data_in);                                    % calculate time frequency response

cfg             = [];
cfg.method      = 'plv';                                                    % calculate phase difference (phase lock value is not estimated!)
cfg.trials      = trial;                                                    % select desired trial
cfg.complex     = 'angle';                                                  % extract phase information

data_out = ft_connectivityanalysis(cfg, TFRhann);                           % calculate the phase differences between the two components

data_out.Mat_cond_pair = data_in.Mat_cond_pair;                             % keep additional settings

end