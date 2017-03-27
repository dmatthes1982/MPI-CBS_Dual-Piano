function [ data_out ] = DualPiano_meanOverCells( data_in )
% DUALPIANO_MEANOVERCELLS Summary of this function goes here
% Detailed explanation goes here

data_out = mean(cat(3, data_in.trial{:}), 3);

end

