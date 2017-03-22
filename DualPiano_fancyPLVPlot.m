function DualPiano_fancyPLVPlot( cfg, data_in )
% DUALPIANO_FANCYPLVPLOT illustrates averaged phase lock values of three
% different epochs in a way shown in a paper of Guillaume Dumas (08/2010)
%
% Params:
%   data_in         vector of PLVs (one each epoch)
%   cfg.time        time vector in higher resolution
%   cfg.marker      1x2 vector including the borders of the epochs
%   cfg.background  true = plot background
%   cfg.average     true = plot data_in dashed in with a width of 2pt
%                   (i.e. highlighting the average of all functions)
%   
% Reference:
%   [Dumas2010]     "Inter-Brain Synchronization during Social Interaction"
%
% See also TANH

% Copyright (C) 2017, Daniel Matthes, MPI CBS

% -------------------------------------------------------------------------
% Check input
% -------------------------------------------------------------------------
if ~isfield(cfg, 'time')                                                    % abort if cfg.time or cfg.marker is missing
  error('No cfg.time defined!');
end  
if ~isfield(cfg, 'marker')
  error('No cfg.marker defined!');
end

if ~isfield(cfg, 'background')                                              % set the defaults
  cfg.background    = false;
end
if ~isfield(cfg, 'average')
  cfg.average       = false;
end

data_elements         = length(data_in);                                    % extract data length
marker_elements       = length(cfg.marker);                                 % extract marker length

if( data_elements ~= marker_elements + 1 )                                  % abort if data and marker doesn't match
  error('length(data) ~= length(cfg.marker) + 1');  
end

% -------------------------------------------------------------------------
% Estimate continuous function
% -------------------------------------------------------------------------
y = 0;                                                                      % initialize continuous function 

for i=1:1:marker_elements
  y = y + ((data_in(i+1)-data_in(i))/2)*tanh(5*(cfg.time - cfg.marker(i))); % build continuous function from a set of tanh functions
end

y = y + ((data_in(1) + data_in(end))/2);                                    % set offset

% -------------------------------------------------------------------------
% Plot background for the different epochs
% -------------------------------------------------------------------------
if( cfg.background == true)                                                 % plot background patches  
  x_vect = [0 cfg.marker(1) cfg.marker(1) 0];
  y_vect = [0 0 1 1];
  patch(x_vect, y_vect, [1 0 0], 'LineStyle', 'none', 'FaceAlpha', 0.05);

  x_vect = [cfg.marker(1) cfg.marker(2) cfg.marker(2) cfg.marker(1)];
  y_vect = [0 0 1 1];
  patch(x_vect, y_vect, [1 1 0], 'LineStyle', 'none', 'FaceAlpha', 0.05);

  x_vect = [cfg.marker(2) cfg.time(end) cfg.time(end) cfg.marker(2)];
  y_vect = [0 0 1 1];
  patch(x_vect, y_vect, [0 1 0], 'LineStyle', 'none', 'FaceAlpha', 0.05);

  hold on;
end

% -------------------------------------------------------------------------
% Plot 'continuous' phase lock value
% -------------------------------------------------------------------------
if cfg.average == false
  plot(cfg.time, y);                                                        % regular curves
else
  plot(cfg.time, y, 'Color', 'black', 'LineStyle', '--', 'LineWidth', 2);   % dashed bold curves
end
  
xlim([cfg.time(1) cfg.time(end)]);                                          % adjust x axis

y_limits = get(gca,'ylim');                                                 % adjust y axis   

if( cfg.background == true )
  y_min = (min(data_in) - 0.01);
  y_max = (max(data_in) + 0.01);
else
  if( y_limits(1) > (min(data_in) - 0.01) )
    y_min = (min(data_in) - 0.01);
  else
    y_min = y_limits(1);
  end

  if( y_limits(2) < (max(data_in) + 0.01) )
    y_max = (max(data_in) + 0.01);
  else
    y_max = y_limits(2);
  end
end

ylim([y_min y_max]);

end
