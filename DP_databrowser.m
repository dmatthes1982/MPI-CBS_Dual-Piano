function DP_databrowser(data_in)
% DP_DATABROWSER displays a dual_piano dataset using a appropriate
% scaling
%
% Params:
%   data_in         fieldtrip data structure
%
% This function requires the fieldtrip toolbox
%
% See also FT_DATABROWSER

% Copyright (C) 2017, Daniel Matthes, MPI CBS

colormap jet;                                                               % use the older and more common colormap

cfg = [];
cfg.ylim      = [-880 880];
cfg.viewmode = 'vertical';
cfg.continuous = 'no';
cfg.channel = 'all';

ft_databrowser(cfg, data_in);

end