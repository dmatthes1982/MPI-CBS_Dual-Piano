function [ data_out ] = DP_extractSigSeg( data_in, segment )
% DP_EXTRACTSIGSEG extracts a predefined segment of a trial
%
% Params:
%   data_in         NxM array of eeg signal, where N is
%                   equal to the numbers of components and M is given
%                   by the signal length.
%   segment         defining the segment (1: first phrase, 2: pause, 3:
%                   third phrase)
%
% Output:
%   data_out        NxL array, where L is defined by the length of the
%                   desired segment

% Copyright (C) 2017, Daniel Matthes, MPI CBS

switch segment
  case 1
    data_out = data_in(:,1:512);
  case 2
    data_out = data_in(:,513:1024);
  case 3
    data_out = data_in(:,1025:1408);
end

end

