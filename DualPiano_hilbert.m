function [ data_out ] = DualPiano_hilbert( data_in, hilbert )

% hilbert could be: 'no', 'abs', 'complex', 'real', 'imag', 'absreal', 'absimag' or 'angle' 

cfg             = [];
cfg.channel     = 'all';
cfg.hilbert     = hilbert;

data_out = ft_preprocessing(cfg, data_in);

end

