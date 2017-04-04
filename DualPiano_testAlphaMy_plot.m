function DualPiano_testAlphaMy_plot( time_data, psd_data, tfr_data, ...
  component, varargin )
% DUALPIANO_TESTALPHAMY_PLOT generates a graphic consisting of multiple
% panels including different representations of a choosen component.
%
% Params:
%   time_data     NxM matrix with N components of a length of M timepoints
%   psd_data      fieldtrip data structure including PSD data
%   tfr_data      fieldtrip data structure including TFR data
%   component     number of the specific component
%   
% Varargin:
%   timeOffset    Offset for the time axis of the time response
%
% This function requires the fieldtrip toolbox
%
% See also DUALPIANO_FFTCOMMON, DUALPIANO_SINGLEPLOTTFR

% Copyright (C) 2017, Daniel Matthes, MPI CBS

% -------------------------------------------------------------------------
% Check input
% -------------------------------------------------------------------------
switch length(varargin)
  case 0
    timeOffset    = 0;                                                      % no Offset for the time axis is given                                                    
  otherwise
    timeOffset    = varargin{1};
end

% -------------------------------------------------------------------------
% Create panels for headline and the two different subplots
% -------------------------------------------------------------------------
f = figure(5);
p = uipanel('Parent', f, 'BackgroundColor', 'white', 'BorderType', ...      % create panel p for the time response and the frequency response
  'none', 'Position', [0 0 0.5 0.95]);
q = uipanel('Parent', f, 'BackgroundColor', 'white', 'BorderType', ...      % create panel q for the time-frequency response 
  'none', 'Position', [0.5 0 0.5 0.95]);
r = uipanel('Parent', f, 'BackgroundColor', 'white', 'BorderType', ...      % create panel r for the headline
  'none', 'Position', [0 0.95 1 0.05]);

% -------------------------------------------------------------------------
% Build headline of the figure
% -------------------------------------------------------------------------
dyad = tfr_data.Mat_cond_pair(1,2);

if (component < 4)
  player = 1;
elseif (component > 3)
  player = 2;
end

switch component
  case 1
    comp_text = 'N100';
  case 2
    comp_text = 'motor right';
  case 3
    comp_text = 'motor left';
  case 4
    comp_text = 'N100';
  case 5
    comp_text = 'motor right';
  case 6
    comp_text = 'motor left';
end

fig_title = sprintf('Dyad: %d, Player: %d, Component: %s', dyad, player,...
  comp_text);
r.Title = fig_title; 
r.TitlePosition = 'centerbottom'; 
r.FontSize = 12;
r.FontWeight = 'bold';

% -------------------------------------------------------------------------
% Plot PSD and TFR
% -------------------------------------------------------------------------
DualPiano_psdPlot(time_data(component, :), psd_data.powspctrm( ...
  component, :), p, timeOffset);                                            % build a 2x1 subplot with time and frequency response
DualPiano_singleplotTFR(tfr_data, 'all', component, [1 30], q);             % plot time-frequency response

% -------------------------------------------------------------------------
% Save graphic as pdf-File
% -------------------------------------------------------------------------
h=gcf;
set(h, 'PaperOrientation','landscape');
set(h, 'PaperType','a3');
set(h, 'PaperUnit', 'centimeters');
set(h, 'PaperSize', [42 29.7]);
set(h, 'unit', 'normalized', 'Position', [0 0 0.9 0.9]);
print(gcf, '-dpdf', '../../results/DualPiano_analysis/output.pdf');

end

