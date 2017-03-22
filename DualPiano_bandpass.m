function [ data_out ] = DualPiano_bandpass( data_in, lowfreq, highfreq )
% DUALPIANO_BANDPASS applies a specific bandpass filter to every channel in
% the data_in structure
%
% Params:
%   data_in         fieldtrip data structure
%   lfreq           lower cutoff frequency
%   hfreq           higher cutoff frequency
%
% Output:
%   data_out        fieldtrip data structure
%
% This function is configured with a fixed filter order, to generate
% comparable filter charakteristics for every operating point.
%
% This function requires the fieldtrip toolbox
%
% See also FT_PREPROCESSING

% Copyright (C) 2017, Daniel Matthes, MPI CBS

cfg                 = [];
cfg.channel         = 'all';                                                % apply bandpass to every channel
cfg.bpfilter        = 'yes';
cfg.bpfilttype      = 'fir';                                                % use a simple fir
cfg.bpfreq          = [lowfreq highfreq];                                   % define bandwith
cfg.bpfiltord       = fix(90/(highfreq - lowfreq));                         % filter order depends on the bandwith
cfg.feedback        = 'none';                                               % suppress feedback output
cfg.showcallinfo    = 'no';                                                 % suppress function call output

data_out = ft_preprocessing(cfg, data_in);                                  % process data

data_out.Mat_cond_pair = data_in.Mat_cond_pair;                             % keep additional settings

end

