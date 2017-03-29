function DualPiano_testAlphaMy_plot( time_data, freq_data, component, ...
  varargin )
% DUALPIANO_TESTALPHAMY_PLOT

% -------------------------------------------------------------------------
% Check input
% -------------------------------------------------------------------------
switch length(varargin)
  case 0
    timeOffset    = 0;                                                      % no Offset for the time axis is given                                                    
  otherwise
    timeOffset    = varargin{1};
end

f = figure(5);
p = uipanel('Parent', f, 'Position', [0 0 0.5 1]);
q = uipanel('Parent', f, 'Position', [0.5 0 0.5 1]);
DualPiano_fftCommon(time_data(component, :), 0, p, timeOffset);
DualPiano_singleplotTFR(freq_data, 'all', component, [1 30], q);

end

