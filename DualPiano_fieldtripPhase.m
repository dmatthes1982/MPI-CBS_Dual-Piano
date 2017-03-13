function [ data_out ] = DualPiano_fieldtripPhase( data_in, lfreq, hfreq, trial, cmp1, cmp2 )

cfg             = [];
cfg.method      = 'mtmconvol';
cfg.output      = 'powandcsd';
cfg.channel     = cell([data_in.label(cmp1); data_in.label(cmp2)]);
cfg.channelcmb  = cell([data_in.label(cmp1), data_in.label(cmp2)]);
cfg.trials      = 'all';
cfg.keeptrials  = 'yes';
cfg.pad         = 'nextpow2';
cfg.taper       = 'hanning';
cfg.foi         = (hfreq-lfreq):(hfreq-lfreq):40;                           % analysis to 40 Hz
cfg.t_ftimwin   = ones(length(cfg.foi),1).*(1/(hfreq-lfreq));               % length of time window 
cfg.toi         = 'all';                                                    % spectral estimates on each sample

TFRhann = ft_freqanalysis(cfg, data_in);

cfg             = [];
cfg.method      = 'plv';
cfg.trials      = trial;
cfg.complex     = 'angle';

data_out = ft_connectivityanalysis(cfg, TFRhann);

data_out.Mat_cond_pair = data_in.Mat_cond_pair;

end