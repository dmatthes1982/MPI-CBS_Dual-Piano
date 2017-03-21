function DualPiano_fancyPLVPlot( data, time, marker, background, average )

data_elements         = length(data);
marker_elements       = length(marker);
y                     = 0;

if( data_elements ~= marker_elements + 1 )
  error('length(data) ~= length(marker) + 1');
end

for i=1:1:marker_elements
  y = y + ((data(i+1)-data(i))/2)*tanh(5*(time - marker(i)));
end

y = y + ((data(1) + data(end))/2);

% plot epoch patches
if( background == 1)
  x_vect = [0 marker(1) marker(1) 0];
  y_vect = [0 0 1 1];
  patch(x_vect, y_vect, [1 0 0], 'LineStyle', 'none', 'FaceAlpha', 0.05);

  x_vect = [marker(1) marker(2) marker(2) marker(1)];
  y_vect = [0 0 1 1];
  patch(x_vect, y_vect, [1 1 0], 'LineStyle', 'none', 'FaceAlpha', 0.05);

  x_vect = [marker(2) time(end) time(end) marker(2)];
  y_vect = [0 0 1 1];
  patch(x_vect, y_vect, [0 1 0], 'LineStyle', 'none', 'FaceAlpha', 0.05);

  hold on;
end

% plot PLV cource
if average == 0
  plot(time, y);
else
  plot(time, y, 'Color', 'black', 'LineStyle', '--', 'LineWidth', 2);
end
  
xlim([time(1) time(end)]);
y_limits = get(gca,'ylim');

if( background == 1 )
  y_min = (min(data) - 0.01);
  y_max = (max(data) + 0.01);
else
  if( y_limits(1) > (min(data) - 0.01) )
    y_min = (min(data) - 0.01);
  else
    y_min = y_limits(1);
  end

  if( y_limits(2) < (max(data) + 0.01) )
    y_max = (max(data) + 0.01);
  else
    y_max = y_limits(2);
  end
end

ylim([y_min y_max]);

end
