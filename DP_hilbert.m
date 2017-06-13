function [ data_out ] = DP_hilbert( data_in, hilbert )
% DP_HILBERT estimates the Hilbert transform auf a given signal and
% returns a certain part('abs' or 'angle')
%
% Params:
%   data_in         fieldtrip data structure
%   hilbert         desired output: 'abs' or 'angle' 
%
% Output:
%   data_out        fieldtrip data structure
%
% This functions calculates also the Hilbert average ratio as described in
% the Paper of M. Chavez (2005). This value could be used to check the
% compilance of the narrow band condition. (hilbert_avRatio > 50)
%
% This function requires the fieldtrip toolbox
%
% Reference:
%   [Chavez2005]    "Towards a proper extimation of phase synchronization
%                   from time series"
%
% See also FT_PREPROCESSING

% Copyright (C) 2017, Daniel Matthes, MPI CBS

trialNum = length(data_in.trial);                                           % get number of trials 
trialLength = length (data_in.time{1});                                     % get length of one trial
trialComp = length (data_in.label);                                         % get number of components

% -------------------------------------------------------------------------
% Calculate instantaneous phase
% -------------------------------------------------------------------------
cfg                 = [];
cfg.channel         = 'all';
cfg.hilbert         = 'angle';
cfg.feedback        = 'no';
cfg.showcallinfo    = 'no';

data_phase = ft_preprocessing(cfg, data_in);

% -------------------------------------------------------------------------
% Calculate instantaenous amplitude
% -------------------------------------------------------------------------
cfg                 = [];
cfg.channel         = 'all';
cfg.hilbert         = 'abs';
cfg.feedback        = 'no';
cfg.showcallinfo    = 'no';

data_amplitude = ft_preprocessing(cfg, data_in);

% -------------------------------------------------------------------------
% Calculate average ratio E[phi'(t)/(A'(t)/A(t))]
% -------------------------------------------------------------------------
hilbert_avRatio = zeros(trialNum, trialComp);

for trial=1:1:trialNum
    phase_diff_abs = abs(diff(data_phase.trial{trial} , 1, 2));
    
    amp_diff = diff(data_amplitude.trial{trial} ,1 ,2);
    amp = data_amplitude.trial{trial};
    amp(:, trialLength) =  [];
    amp_ratio_abs = abs(amp_diff ./ amp);
    ratio = (phase_diff_abs ./ amp_ratio_abs);

    hilbert_avRatio(trial, :) = (mean(ratio, 2))';
end

% -------------------------------------------------------------------------
% Generate the output 
% -------------------------------------------------------------------------
if hilbert == 'angle'
    data_out = data_phase;
else
    data_out = data_amplitude;
end

data_out.Mat_cond_pair = data_in.Mat_cond_pair;                             % keep additional settings
data_out.hilbert_avRatio = hilbert_avRatio;                                 % assign hilbert_avRatio to the output data structure

end

