function [ data_out ] = DualPiano_bandpass( data_in, lowfreq, highfreq )

cfg                 = [];
cfg.channel         = 'all';
cfg.bpfilter        = 'yes';
cfg.bpfilttype      = 'fir';
cfg.bpfreq          = [lowfreq highfreq];

data_out = ft_preprocessing(cfg, data_in);

end

