function DualPiano_singleplotTFR(data_in, varargin)
% DUALPIANO_SINGLEPLOTTFR generates a graphic consisting of different time
% frequency plots
%
% Params:
%   data_in         fieldtrip data structure
%
% Varargin:
%   trial           number of one specific trial or 'all'
%   components      1xN vector specifying the components (N_max = 4);
%   freq_range      1xN vector specifying the limits of the freq. axis
%
% This function requires the fieldtrip toolbox
%
% See also FT_SINGLEPLOTTFR

% Copyright (C) 2017, Daniel Matthes, MPI CBS

warning('on','all');

% -------------------------------------------------------------------------
% Check input
% -------------------------------------------------------------------------
switch length(varargin)
  case 0
    freq_range    = [1 30];                                                 % plot all frequency components from 1 to 30 Hz
    components    = [2, 3, 5, 6];                                           % default components 'run11_pl1', 'run14_pl2' 'run14_pl1'and 'run11_pl2'
    trial         = 'all';                                                  % average over all trials
  case 1
    freq_range    = [1 30];                                                 
    components    = [2, 3, 5, 6];                                               
    trial         = varargin{1}; 
  otherwise
    freq_range    = varargin{3};
    components    = varargin{2};
    trial         = varargin{1};
end

nmbcmp = length(components);                                                % get the the number of components

if nmbcmp > 4                                                               % more than four elements are not allowed  
  error('maximum number of components are 4');
end

switch nmbcmp                                                               % configure the subplot layout
  case 1
    row = 1;
    column = 1;
  case 2
    row = 1;
    column = 2;
  otherwise
    row = 2;
    column = 2;
end

% -------------------------------------------------------------------------
% Create figure
% -------------------------------------------------------------------------
cfg                 = [];                                                       
cfg.maskstyle       = 'saturation';
cfg.xlim            = [0.5 10.5];
cfg.ylim            = freq_range;
cfg.zlim            = 'maxmin';
cfg.trials          = trial;                                                % select trial (or 'all' trials)
cfg.feedback        = 'no';                                                 % suppress feedback output
cfg.showcallinfo    = 'no';                                                 % suppress function call output

figure
colormap jet;                                                               % use the older and more common colormap

for i=1:1:nmbcmp
    cfg.channel = components(i);
    subplot(row,column,i);
    tlabel = data_in.label(cfg.channel);                                    % get label of component
    tlabel = strrep(tlabel, '_', '\_');                                     % mask underscores
    ft_singleplotTFR(cfg, data_in);                                         % plot the time frequency responses
    title(tlabel, 'FontSize', 11);                                          % reset title
    xlabel('time in sec');                                                  % set xlabel
    ylabel('frequency in Hz');                                              % set ylabel
end

warning('off','all');

end