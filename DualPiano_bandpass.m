function [ data_out ] = DualPiano_bandpass( data_in, lowfreq, highfreq )

cfg                 = [];
cfg.channel         = 'all';
cfg.bpfilter        = 'yes';
cfg.bpfilttype      = 'fir';
cfg.bpfreq          = [lowfreq highfreq];
cfg.bpfiltord       = fix(90/(highfreq - lowfreq));
cfg.feedback        = 'none';
cfg.showcallinfo    = 'no';

data_out = ft_preprocessing(cfg, data_in);

data_out.Mat_cond_pair = data_in.Mat_cond_pair;

end

