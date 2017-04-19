% DUALPIANO_TESTALPHAMY_PREPROC
%
% This script preprocesses the whole data of one dyad from the "dual piano"
% study, so that various components or rather parts of various components
% could be visually analysied afterwards by using FFT and TFR plots.
%
% This script requires the fieldtrip toolbox
%
% See also DUALPIANO_MEANOVERTRIALS, DUALPIANO_EXTRACTSIGSEG,
% DUALPIANO_FREQANALYSIS

% Copyright (C) 2017, Daniel Matthes, MPI CBS

% -------------------------------------------------------------------------
% This part applies a bandpass to all trials in every condition
% -------------------------------------------------------------------------
% warning('off','all'); 
% 
% data_CF = DualPiano_bandpass(data_CF, 1, 30, false);
% data_CU = DualPiano_bandpass(data_CU, 1, 30, false);
% data_UF = DualPiano_bandpass(data_UF, 1, 30, false);
% data_UU = DualPiano_bandpass(data_UU, 1, 30, false);
% 
% warning('on','all'); 

% -------------------------------------------------------------------------
% This part calculates time-frequency data for every component in every
% condition averaged over all trials
% -------------------------------------------------------------------------
disp('Estimation of TFRs...');
data_CF_freq = DualPiano_freqanalysis(data_CF);
data_CU_freq = DualPiano_freqanalysis(data_CU);
data_UF_freq = DualPiano_freqanalysis(data_UF);
data_UU_freq = DualPiano_freqanalysis(data_UU);

% -------------------------------------------------------------------------
% In this part the trials and time vectors are trimmed to the desired
% window
% 1: phrase 1 - second 0 to 4
% 2: pause - second 4 to 8
% 3: phrase 2 - second 8 to 11
% -------------------------------------------------------------------------
disp('Extraction of the pause phrase...');
for i=1:1:48
  data_CF.trial{i} = DualPiano_extractSigSeg(data_CF.trial{i}, 2);
  data_CU.trial{i} = DualPiano_extractSigSeg(data_CU.trial{i}, 2);
  data_UF.trial{i} = DualPiano_extractSigSeg(data_UF.trial{i}, 2);
  data_UU.trial{i} = DualPiano_extractSigSeg(data_UU.trial{i}, 2);

  data_CF.time{i} = DualPiano_extractSigSeg(data_CF.time{i}, 2);
  data_CU.time{i} = DualPiano_extractSigSeg(data_CU.time{i}, 2);
  data_UF.time{i} = DualPiano_extractSigSeg(data_UF.time{i}, 2);
  data_UU.time{i} = DualPiano_extractSigSeg(data_UU.time{i}, 2);
end

% -------------------------------------------------------------------------
% This part calculates power spectral destiny for every component in every
% condition averaged over all trials
% -------------------------------------------------------------------------
disp('Estimation of the general PSDs...');
data_CF_psd = DualPiano_psdanalysis(data_CF);
data_CU_psd = DualPiano_psdanalysis(data_CU);
data_UF_psd = DualPiano_psdanalysis(data_UF);
data_UU_psd = DualPiano_psdanalysis(data_UU);

% -------------------------------------------------------------------------
% This part calculates also the power spectral destiny for every component 
% in every condition averaged over all trials, but in more elaborate
% manner. The chosen time slot will be segmented first in overlapping parts
% of a length of one second second and a overlapping size of 50%. The psd
% will be calculated for every part separately and afterwards averaged.
% -------------------------------------------------------------------------
disp('Estimation of the segmented PSDs...');
data_CF_seg{7} = [];
data_CU_seg{7} = [];
data_UF_seg{7} = [];
data_UU_seg{7} = [];
data_CF_psdseg{7} = [];
data_CU_psdseg{7} = [];
data_UF_psdseg{7} = [];
data_UU_psdseg{7} = [];
for i=1:1:7
  fprintf('Segment %d...\n', i);
  data_CF_seg{i} = data_CF;
  data_CU_seg{i} = data_CU;
  data_UF_seg{i} = data_UF;
  data_UU_seg{i} = data_UU;
  for j=1:1:48
    data_CF_seg{i}.trial{j} = data_CF_seg{i}.trial{j}(:,(1+(64*(i-1))):...
      (128+(64*(i-1))));
    data_CU_seg{i}.trial{j} = data_CU_seg{i}.trial{j}(:,(1+(64*(i-1))):...
      (128+(64*(i-1))));
    data_UF_seg{i}.trial{j} = data_UF_seg{i}.trial{j}(:,(1+(64*(i-1))):...
      (128+(64*(i-1))));
    data_UU_seg{i}.trial{j} = data_UU_seg{i}.trial{j}(:,(1+(64*(i-1))):...
      (128+(64*(i-1))));
    data_CF_seg{i}.time{j} = data_CF_seg{i}.time{j}(1,(1+(64*(i-1))):...
      (128+(64*(i-1))));
    data_CU_seg{i}.time{j} = data_CU_seg{i}.time{j}(1,(1+(64*(i-1))):...
      (128+(64*(i-1))));
    data_UF_seg{i}.time{j} = data_UF_seg{i}.time{j}(1,(1+(64*(i-1))):...
      (128+(64*(i-1))));
    data_UU_seg{i}.time{j} = data_UU_seg{i}.time{j}(1,(1+(64*(i-1))):...
      (128+(64*(i-1))));
  end
data_CF_psdseg{i} = DualPiano_psdanalysis(data_CF_seg{i});
data_CU_psdseg{i} = DualPiano_psdanalysis(data_CU_seg{i});
data_UF_psdseg{i} = DualPiano_psdanalysis(data_UF_seg{i});
data_UU_psdseg{i} = DualPiano_psdanalysis(data_UU_seg{i});
end

cfg                = [];
cfg.keepindividual = 'no';
cfg.foilim         = 'all';
cfg.toilim         = 'all';
cfg.channel        = 'all';
cfg.parameter      = 'powspctrm';
cfg.feedback       = 'no';
cfg.showcallinfo   = 'no';

data_CF_psd2       = ft_freqgrandaverage(cfg, data_CF_psdseg{1:7});
data_CU_psd2       = ft_freqgrandaverage(cfg, data_CU_psdseg{1:7});
data_UF_psd2       = ft_freqgrandaverage(cfg, data_UF_psdseg{1:7});
data_UU_psd2       = ft_freqgrandaverage(cfg, data_UU_psdseg{1:7});

clear data_CF_psdseg data_CU_psdseg data_UF_psdseg data_UU_psdseg ...
  data_CF_seg data_CU_seg data_UF_seg data_UU_seg cfg j

% -------------------------------------------------------------------------
% In this part the mean over all trials for every condition is calculated
% -------------------------------------------------------------------------
disp('Estimation of the averaged time responses...');
data_CF_av = DualPiano_meanOverTrials(data_CF);
data_CU_av = DualPiano_meanOverTrials(data_CU);
data_UF_av = DualPiano_meanOverTrials(data_UF);
data_UU_av = DualPiano_meanOverTrials(data_UU);

% -------------------------------------------------------------------------
% Propagation of the Mat_cond_pair matrix
% -------------------------------------------------------------------------
disp('Propagation of the Mat_cond_pair matrix...');
data_CF_freq.Mat_cond_pair = data_CF.Mat_cond_pair;
data_CU_freq.Mat_cond_pair = data_CU.Mat_cond_pair;
data_UF_freq.Mat_cond_pair = data_UF.Mat_cond_pair;
data_UU_freq.Mat_cond_pair = data_UU.Mat_cond_pair;

clear i;
