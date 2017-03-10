function DualPiano_determineFiltChar(data_in, trial, cmp)

% extract the signal and the corresponding time axis
s = data_in.trial{trial}(cmp,:);
t = data_in.time{trial};

L = length(data_in.time{trial});

freq = data_in.fsample * (0:(L/2)) / L;

str = 'compare different cutoff frequencies';
clear f
f(1,:) = s;
f(2,:) = ft_preproc_bandpassfilter(s, data_in.fsample, [9 11], [], 'fir', 'twopass', 'no');
f(3,:) = ft_preproc_bandpassfilter(s, data_in.fsample, [19 21], [], 'fir', 'twopass', 'no');
f(4,:) = ft_preproc_bandpassfilter(s, data_in.fsample, [29 31], [], 'fir', 'twopass', 'no');

F       = fft(f, [], 2).^2;
F2side  = abs(F/L);
F1side  = F2side(:, 1:floor(L/2)+1);

%figure; 
subplot(1,2,1);
plot(t, f-repmat((0:500:1500)',1,L)); grid on; set(gca, 'ylim', [-1600 400]); xlabel('time (s)'); ylabel(str);
title('Raw, 10 Hz, 20 Hz, 30 Hz');
subplot(1,2,2); 
semilogy(freq, F1side'); grid on; set(gca, 'ylim', [10^-5 10^10]); xlabel('freq (Hz)'); ylabel(str);
title('FIR-Filter');

end