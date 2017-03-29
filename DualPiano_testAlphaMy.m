% warning('off','all'); 
% 
% data_CF = DualPiano_bandpass(data_CF, 1, 30, false);
% data_CU = DualPiano_bandpass(data_CU, 1, 30, false);
% data_UF = DualPiano_bandpass(data_UF, 1, 30, false);
% data_UU = DualPiano_bandpass(data_UU, 1, 30, false);
% 
% warning('on','all'); 

data_CF_av = DualPiano_meanOverTrials(data_CF);
data_CU_av = DualPiano_meanOverTrials(data_CU);
data_UF_av = DualPiano_meanOverTrials(data_UF);
data_UU_av = DualPiano_meanOverTrials(data_UU);

data_CF_avSeg = DualPiano_extractSigSeg(data_CF_av, 2);
data_CU_avSeg = DualPiano_extractSigSeg(data_CU_av, 2);
data_UF_avSeg = DualPiano_extractSigSeg(data_UF_av, 2);
data_UU_avSeg = DualPiano_extractSigSeg(data_UU_av, 2);