function DualPiano_fancyPLVPlot( cfg, data_in )

data_elements         = length(data_in);
marker_elements       = length(cfg.marker);
y                     = 0;

if( data_elements ~= marker_elements + 1 )
  error('length(data) ~= length(cfg.marker) + 1');
end

for i=1:1:marker_elements
  y = y + ((data_in(i+1)-data_in(i))/2)*tanh(5*(cfg.time - cfg.marker(i)));
end

y = y + ((data_in(1) + data_in(end))/2);

% plot epoch patches
if( cfg.background == true)
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

% plot PLV cource
if cfg.average == false
  plot(cfg.time, y);
else
  plot(cfg.time, y, 'Color', 'black', 'LineStyle', '--', 'LineWidth', 2);
end
  
xlim([cfg.time(1) cfg.time(end)]);
y_limits = get(gca,'ylim');

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
