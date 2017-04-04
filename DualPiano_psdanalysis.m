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

warning('off','all');

cfg                 = [];
cfg.method          = 'mtmfft';
cfg.output          = 'pow';
cfg.channel         = 'all';                                                % calculate spectrum of every channel  
cfg.trials          = 'all';                                                % calculate spectrum for every trial  
cfg.keeptrials      = 'no';                                                 % average over trials
cfg.pad             = 'maxperlen';                                          % non padded fft
cfg.taper           = 'hanning';                                            % hanning taper the segments
cfg.foilim          = [0 (data_in.fsample/2 - 1/data_in.fsample)];          % range from zero to Fs/2 
cfg.feedback        = 'no';                                                 % suppress feedback output
cfg.showcallinfo    = 'no';                                                 % suppress function call output

data_out = ft_freqanalysis(cfg, data_in);                                   % calculate time frequency responses

warning('on','all');

end