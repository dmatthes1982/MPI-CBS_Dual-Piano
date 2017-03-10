function DualPiano_compareSignals( data_one, data_two, trial, comp1, comp2 )

figure
plot(data_one.time{trial}(:), data_one.trial{trial}(comp1,:));
hold on;
plot(data_two.time{trial}(:), data_two.trial{trial}(comp2,:), 'r');

end

