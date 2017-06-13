function [ data_out ] = DP_meanOverTrials( data_in )
% DP_MEANOVERTRIALS calculates as its name suggested the mean value
% of eeg signals from different trials
%
% Params:
%   data_in         fieldtrip data structure
%
% Output:
%   data_out        NxM array of averaged components, where N is
%                   equal to the numbers of components and M is given
%                   by the signal length.

% Copyright (C) 2017, Daniel Matthes, MPI CBS

data_out = mean(cat(3, data_in.trial{:}), 3);

end

