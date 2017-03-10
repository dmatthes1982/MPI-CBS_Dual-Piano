function DualPiano_singleplotTFR(data, trial)

cfg             = [];
cfg.method      = 'mtmconvol';
cfg.output      = 'pow';
cfg.channel     = 'all';
cfg.trials      = 'all';
cfg.keeptrials  = 'yes';
cfg.pad         = 'nextpow2';
cfg.taper       = 'hanning';
cfg.foi         = 1:1:30;                          % analysis 1 to 30 Hz in steps of 1 Hz 
cfg.t_ftimwin   = ones(length(cfg.foi),1).*1;      % length of time window = 1 sec
cfg.toi         = 'all';                           % spectral estimates on each sample

TFRhann = ft_freqanalysis(cfg, data);

cfg             = [];
cfg.maskstyle   = 'saturation';
cfg.xlim        = [0.5 10.5];
cfg.zlim        = 'maxmin';
cfg.trials      = trial;

components = [2, 3, 5, 6];

figure
colormap jet;

for i=1:1:4
    cfg.channel = components(i);
    subplot(2,2,i);
    ft_singleplotTFR(cfg, TFRhann);
end

clear i ans cfg;

end