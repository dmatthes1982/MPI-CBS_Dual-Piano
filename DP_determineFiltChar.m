function DP_determineFiltChar(data_in, trial, cmp)
% DP_DETERMINEFILTCHAR illustrates and compares the frequency
% response and the output of different bandpass filter
%
% Params:
%   data_in         fieldtrip data structure
%   trial           number of desired trial
%   cmp             number of desired component
%
% This function could be used to evaluate different filter types and orders
%
% This function requires the fieldtrip toolbox
%
% See also FT_PREPROC_BANDPASSFILTER

% Copyright (C) 2017, Daniel Matthes, MPI CBS

s = data_in.trial{trial}(cmp,:);                                            % extract the signal
t = data_in.time{trial};                                                    % extract the time vector

L = length(data_in.time{trial});                                            % get the signal length
freq = data_in.fsample * (0:(L/2)) / L;                                     % calculate the frequency vector

clear f
f(1,:) = s;                                                                 % the raw signal
f(2,:) = ft_preproc_bandpassfilter(s, data_in.fsample, [9 11], [], ...      % apply first bandpass
  'fir', 'twopass', 'no');
f(3,:) = ft_preproc_bandpassfilter(s, data_in.fsample, [19 21], [], ...     % apply second bandpass
  'fir', 'twopass', 'no');
f(4,:) = ft_preproc_bandpassfilter(s, data_in.fsample, [29 31], [], ...     % apply third bandpass
  'fir', 'twopass', 'no');

F       = fft(f, [], 2).^2;                                                 % fast fourier transformation
F2side  = abs(F/L);                                                         % amplitude response
F1side  = F2side(:, 1:floor(L/2)+1);                                        % single-side amplitude spectrum

figure;
str = 'compare different cutoff frequencies';

subplot(1,2,1);                                                             % plot the different time courses
plot(t, f-repmat((0:500:1500)',1,L)); grid on; set(gca, 'ylim', ...
  [-1600 400]); xlabel('time (s)'); ylabel(str);
title('Raw, 10 Hz, 20 Hz, 30 Hz');

subplot(1,2,2);                                                             % plot the different amplitude spectra                                 
semilogy(freq, F1side'); grid on; set(gca, 'ylim', [10^-5 10^10]); ...
  xlabel('freq (Hz)'); ylabel(str);
title('FIR-Filter');

end