function DualPiano_databrowser(data)
colormap jet;

cfg = [];
cfg.ylim      = [-880 880];
cfg.viewmode = 'vertical';
cfg.continuous = 'no';
cfg.channel = 'all';

ft_databrowser(cfg, data);

end