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
% In this part the mean over all trials for every condition is calculated
% -------------------------------------------------------------------------
data_CF_av = DualPiano_meanOverTrials(data_CF);
data_CU_av = DualPiano_meanOverTrials(data_CU);
data_UF_av = DualPiano_meanOverTrials(data_UF);
data_UU_av = DualPiano_meanOverTrials(data_UU);

% -------------------------------------------------------------------------
% In this part the averaged trials are trimmed
% 1: phrase 1 - second 0 to 4
% 2: pause - second 4 to 8
% 3: phrase 2 - second 8 to 11
% -------------------------------------------------------------------------
data_CF_avSeg = DualPiano_extractSigSeg(data_CF_av, 2);
data_CU_avSeg = DualPiano_extractSigSeg(data_CU_av, 2);
data_UF_avSeg = DualPiano_extractSigSeg(data_UF_av, 2);
data_UU_avSeg = DualPiano_extractSigSeg(data_UU_av, 2);

% -------------------------------------------------------------------------
% This part calculates time-frequency data for every component in every
% condition averaged over all trials
% -------------------------------------------------------------------------
data_CF_freq = DualPiano_freqanalysis(data_CF);
data_CU_freq = DualPiano_freqanalysis(data_CU);
data_UF_freq = DualPiano_freqanalysis(data_UF);
data_UU_freq = DualPiano_freqanalysis(data_UU);

% -------------------------------------------------------------------------
% Propagation of the Mat_cond_pair matrix
% -------------------------------------------------------------------------
data_CF_freq.Mat_cond_pair = data_CF.Mat_cond_pair;
data_CU_freq.Mat_cond_pair = data_CU.Mat_cond_pair;
data_UF_freq.Mat_cond_pair = data_UF.Mat_cond_pair;
data_UU_freq.Mat_cond_pair = data_UU.Mat_cond_pair;