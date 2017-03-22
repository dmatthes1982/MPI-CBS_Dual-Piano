function DualPiano_compareSignals( data_one, data_two, trial, comp1, comp2 )
% DUALPIANO_COMPARESIGNALS plot to eeg signals for visual comparison 
%
% Params:
%   data_one         fieldtrip data structure
%   data_two         another or the same fieldtrip data structure
%   trial            number of the desired trial
%   comp1            number of the first component
%   comp2            number of the second component
%
% This function expects data in the fieldtrip data format

% Copyright (C) 2017, Daniel Matthes, MPI CBS

figure
plot(data_one.time{trial}(:), data_one.trial{trial}(comp1,:));
hold on;
plot(data_two.time{trial}(:), data_two.trial{trial}(comp2,:), 'r');

end

