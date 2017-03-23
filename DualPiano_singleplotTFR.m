function DualPiano_singleplotTFR(data_in, trial)
% DUALPIANO_SINGLEPLOTTFR generates a multiplot of different time frequency 
% plots with four single plots (one plot for on specific component)
%
% Params:
%   data_in         fieldtrip data structure
%   trial           number of specific trial or 'all' 
%
% This function requires the fieldtrip toolbox
%
% See also FT_FREQANALYSIS, FT_SINGLEPLOTTFR

% Copyright (C) 2017, Daniel Matthes, MPI CBS

cfg             = [];
cfg.method      = 'mtmconvol';
cfg.output      = 'pow';
cfg.channel     = 'all';                                                    % calculate spectrum of every channel  
cfg.trials      = 'all';                                                    % calculate spectrum for every trial  
cfg.keeptrials  = 'yes';                                                    % do not average over trials
cfg.pad         = 'nextpow2';                                               % use fast calculation method
cfg.taper       = 'hanning';                                                % hanning taper the segments
cfg.foi         = 1:1:30;                                                   % analysis 1 to 30 Hz in steps of 1 Hz 
cfg.t_ftimwin   = ones(length(cfg.foi),1).*1;                               % length of time window = 1 sec
cfg.toi         = 'all';                                                    % spectral estimates on each sample

TFRhann = ft_freqanalysis(cfg, data_in);                                    % calculate time frequency responses

cfg             = [];                                                       
cfg.maskstyle   = 'saturation';
cfg.xlim        = [0.5 10.5];                                                   
cfg.zlim        = 'maxmin';
cfg.trials      = trial;                                                    % select trial (or 'all' trials)

components = [2, 3, 5, 6];                                                  % components 'run11_pl1', 'run14_pl2' 'run14_pl1'and 'run11_pl2'

figure
colormap jet;                                                               % use the older and more common colormap

for i=1:1:4
    cfg.channel = components(i);
    subplot(2,2,i);
    tlabel = data_in.label(cfg.channel);                                    % get label of component
    tlabel = strrep(tlabel, '_', '\_');                                     % mask underscores
    ft_singleplotTFR(cfg, TFRhann);                                         % plot the time frequency responses
    title(tlabel, 'FontSize', 11);                                          % reset title
    xlabel('time in sec');                                                  % set xlabel
    ylabel('frequency in Hz');                                              % set ylabel
end

end