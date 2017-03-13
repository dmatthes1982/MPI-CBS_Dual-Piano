function [ data_out ] = DualPiano_hilbert( data_in, hilbert )

% cfg.hilbert could be: 'no', 'abs', 'complex', 'real', 'imag', 'absreal', 'absimag' or 'angle' 

trialNum = length(data_in.trial);
trialLength = length (data_in.time{1});
trialComp = length (data_in.label);

% calculate instantaneous phase
cfg             = [];
cfg.channel     = 'all';
cfg.hilbert     = 'angle';

data_phase = ft_preprocessing(cfg, data_in);

% calculate instantaenous amplitude
cfg             = [];
cfg.channel     = 'all';
cfg.hilbert     = 'abs';

data_amplitude = ft_preprocessing(cfg, data_in);

% calculate average ratio E[phi'(t)/(A'(t)/A(t))]
% Source: Paper ? Mario Chavez ? ?Towards a proper estimation of 
% phase synchroniszation frome time series?

hilbert_avRatio = zeros(trialNum, trialComp);

for trial=1:1:trialNum
    
    phase_diff_abs = abs(diff(data_phase.trial{trial} , 1, 2));
    
    amp_diff = diff(data_amplitude.trial{trial} ,1 ,2);
    amp = data_amplitude.trial{trial};
    amp(:, trialLength) =  [];
    amp_ratio_abs = abs(amp_diff ./ amp);
    ratio = (phase_diff_abs ./ amp_ratio_abs);

    hilbert_avRatio(trial, :) = (mean(ratio, 2))';
    
end

% Decide which matrix is the output matrix
if hilbert == 'angle'
    data_out = data_phase;
else
    data_out = data_amplitude;
end

data_out.Mat_cond_pair = data_in.Mat_cond_pair;
data_out.hilbert_avRatio = hilbert_avRatio;

end

