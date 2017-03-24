% DUALPIANO_MAIN 
% 
% This script estimates and illustrates the epoch-related phase locking
% values of two connections (run11_pl1 vs. run14_pl2 and run14_pl1
% vs. run11_pl2) selected from the DualPiano dataset. The estimation is 
% done across all dyads (14) and for all conditions (CONGRUENT/FAMILIAR, 
% CONGRUENT/UNFAMILIAR, INCONGRUENT/FAMILIAR, INCONGRUENT/UNFAMILIAR) The 
% graphic consists of eight plots in a 2x4 order. Each plot is connected 
% with one pair of condition and connection. The colored solid lines of 
% each plot are connected to single dyads. The black dashed lines show the 
% average over all dyads for each pair of condition and connection.
%
% Using the variables freqLow and freqHigh, the desired passband can be
% specified.
%
% This script requires the fieldtrip toolbox.

% Copyright (C) 2017, Daniel Matthes, MPI CBS

% -------------------------------------------------------------------------
% General definitions
% -------------------------------------------------------------------------
disp('processing data of 14 different dyads...');
clear data_CF data_CU data_UF data_UU
load('../../Dual_PIANO_data/Components_epoched/P3comb_condSpec.mat');

Fs                        = data_CF.fsample;                                % sampling rate
freqLow                   = 9;                                              % lower bandpass frequency
freqHigh                  = 11;                                             % upper bandpass frequency 
subplot_title             = sprintf(['Phase Locking Values - Passband:' ...
                                     ' %d Hz - %d Hz'], freqLow, freqHigh);      
dyads                     = 14;                                             % number of different dyads
connections               = 2;                                              % number of connections to be investigated
labelcmp                  = {'run11_pl1', 'run14_pl2'; 'run14_pl1', ...     % labels to be compared
                            'run11_pl2'};
motorRightPlayerOne       = find(strcmp(data_CF.label, 'run11_pl1'));       % component "motor right" of player one
motorLeftPlayerOne        = find(strcmp(data_CF.label, 'run14_pl1'));       % component "motor left" of player one
motorRightPlayerTwo       = find(strcmp(data_CF.label, 'run11_pl2'));       % component "motor right" of player two
motorLeftPlayerTwo        = find(strcmp(data_CF.label, 'run14_pl2'));       % component "motor left" of player two
PLV_winSize               = Fs;                                             % window size for sliding PLV calculation
FirstStart                = 1;                                              % start of first phrase (sample number)
FirstStop                 = find(data_CF.time{1} == 4) - 1;                 % stop of first phrase (sample number)
pauseStart                = find(data_CF.time{1} == 4);                     % pause start (sample number)
pauseStop                 = find(data_CF.time{1} == 8) - 1;                 % pause stop (sample number)
SecondStart               = find(data_CF.time{1} == 8);                     % start of second phrase (sample number)
SecondStop                = length(data_CF.time{1});                        % stop of second phrase (sample number)
time                      = data_CF.time{1};                                % time vector
marker                    = [4, 8];                                         % time points of pause and second phrase start  

% -------------------------------------------------------------------------
% Allocating memory
% -------------------------------------------------------------------------
PLVep                     = cell(2, dyads);                                 % container for trial and epoch averaged PLVs
PLVs                      = cell(2, dyads);                                 % container for raw PLVs
PLVmean                   = cell(2, dyads);                                 % container for trial averaged PLVs

for i=1:1:dyads
  PLVep{1,i} = zeros(4,3);
  PLVep{2,i} = zeros(4,3);
end

% -------------------------------------------------------------------------
% Initialize plots
% -------------------------------------------------------------------------
figure;                                                                     % initialize figure with 8 subplots
subplot(2,4,1,'replace');                                                   % one for each pair of condition and connection
title('CONGRUENT/FAMILIAR');
ylabel('PLV - Pl1 right vs. Pl2 left');
xlabel('time in sec');
subplot(2,4,2,'replace');
title('CONGRUENT/UNFAMILIAR');
xlabel('time in sec');
subplot(2,4,3,'replace');
title('INCONGRUENT/FAMILIAR');
xlabel('time in sec');
subplot(2,4,4,'replace');
title('INCONGRUENT/UNFAMILIAR');
xlabel('time in sec');
subplot(2,4,5,'replace');
title('CONGRUENT/FAMILIAR');
ylabel('PLV - Pl1 left vs. Pl2 right');
xlabel('time in sec');
subplot(2,4,6,'replace');
title('CONGRUENT/UNFAMILIAR');
xlabel('time in sec');
subplot(2,4,7,'replace');
title('INCONGRUENT/FAMILIAR');
xlabel('time in sec');
subplot(2,4,8,'replace');
title('INCONGRUENT/UNFAMILIAR');
xlabel('time in sec');

cfgPlot             = [];                                                   % initialize the plot config
cfgPlot.time        = time;
cfgPlot.marker      = marker;
cfgPlot.background  = true;
cfgPlot.average     = false;

% -------------------------------------------------------------------------
% Calculate PLV for all dyads, conditions and connections
% -------------------------------------------------------------------------
for dyad=1:1:dyads
  switch dyad                                                               % load the appropriate data
    case 1
      disp('01: processing data of dyad No. 3...');
    case 2
      clear data_CF data_CU data_UF data_UU
      load('../../Dual_PIANO_data/Components_epoched/P5comb_condSpec.mat');
      cfgPlot.background = false;
      disp('02: processing data of dyad No. 5...');
    case 3
      clear data_CF data_CU data_UF data_UU
      load('../../Dual_PIANO_data/Components_epoched/P6comb_condSpec.mat');
      disp('03: processing data of dyad No. 6...');
    case 4
      clear data_CF data_CU data_UF data_UU
      load('../../Dual_PIANO_data/Components_epoched/P7comb_condSpec.mat');
      disp('04: processing data of dyad No. 7...');
    case 5
      clear data_CF data_CU data_UF data_UU
      load('../../Dual_PIANO_data/Components_epoched/P8comb_condSpec.mat');
      disp('05: processing data of dyad No. 8...');
    case 6
      clear data_CF data_CU data_UF data_UU
      load('../../Dual_PIANO_data/Components_epoched/P9comb_condSpec.mat');
      disp('06: processing data of dyad No. 9...');
    case 7
      clear data_CF data_CU data_UF data_UU
      load('../../Dual_PIANO_data/Components_epoched/P10comb_condSpec.mat');
      disp('07: processing data of dyad No. 10...');
    case 8
      clear data_CF data_CU data_UF data_UU
      load('../../Dual_PIANO_data/Components_epoched/P11comb_condSpec.mat');
      disp('08: processing data of dyad No. 11...');
    case 9
      clear data_CF data_CU data_UF data_UU
      load('../../Dual_PIANO_data/Components_epoched/P12comb_condSpec.mat');
      disp('09: processing data of dyad No. 12...');
    case 10
      clear data_CF data_CU data_UF data_UU
      load('../../Dual_PIANO_data/Components_epoched/P13comb_condSpec.mat');
      disp('10: processing data of dyad No. 13...');
    case 11
      clear data_CF data_CU data_UF data_UU
      load('../../Dual_PIANO_data/Components_epoched/P14comb_condSpec.mat');
      disp('11: processing data of dyad No. 14...');
    case 12
      clear data_CF data_CU data_UF data_UU
      load('../../Dual_PIANO_data/Components_epoched/P15comb_condSpec.mat');
      disp('12: processing data of dyad No. 15...');
    case 13
      clear data_CF data_CU data_UF data_UU
      load('../../Dual_PIANO_data/Components_epoched/P16comb_condSpec.mat');
      disp('13: processing data of dyad No. 16...');
    case 14
      clear data_CF data_CU data_UF data_UU
      load('../../Dual_PIANO_data/Components_epoched/P19comb_condSpec.mat');
      disp('14: processing data of dyad No. 19...');
    otherwise
      error('number of cases and value of dyads does not match');
  end
  for condition=1:1:4
    switch condition                                                        % select condition
      case 1
        data = data_CF;
        disp('    condition CONGRUENT/FAMILIAR');
      case 2
        data = data_CU;
        disp('    condition CONGRUENT/UNFAMILIAR');
      case 3
        data = data_UF;
        disp('    condition INCONGRUENT/FAMILIAR');
      case 4
        data = data_UU;
        disp('    condition INCONGRUENT/UNFAMILIAR');
    end
    
    cfgPLV           = [];                                                  % configure PLV calculation
    cfgPLV.lfreq     = freqLow;                                             % define bandpass  
    cfgPLV.hfreq     = freqHigh;
    cfgPLV.nmbcmp    = {motorRightPlayerOne, motorLeftPlayerTwo; ...        % define connections
                      motorLeftPlayerOne, motorRightPlayerTwo};
    cfgPLV.labelcmp  = labelcmp;
    cfgPLV.winSize   = PLV_winSize;
    cfgPLV.rmErrTrls = true;                                                % exclude trials with errors
      
    data_PLV = DualPiano_PLVoverTrials( cfgPLV, data );                     % calculate PLV course averaged over trials for a single dyad
                                                                            % and a specific condition
    if(min(min(data_PLV.hilbert_avRatio)) < 50)                             % display a warning, 
      warning('Some "Hilbert average value" is < 50.');                     % if in some dataset the narrow passband condition is violated
      warning('The narrow passband condition is violated');
    end
    
    for i=1:1:connections
      PLVep{i, dyad}(condition,1) = ...                                     % average the trial averaged PLV course within the three different epochs
        mean(data_PLV.PLVmean{i}(FirstStart:FirstStop), 'omitnan');
      PLVep{i, dyad}(condition,2) = ...
        mean(data_PLV.PLVmean{i}(pauseStart:pauseStop), 'omitnan');
      PLVep{i, dyad}(condition,3) = ...
        mean(data_PLV.PLVmean{i}(SecondStart:SecondStop), 'omitnan');
      
      PLVs{i, dyad} = data_PLV.PLVs{i};                                     % keep intermediate results
      PLVmean{i, dyad} = data_PLV.PLVmean{i};
      
      subplot(2,4,condition+((i-1)*4));                                     % plot result
      DualPiano_fancyPLVPlot(cfgPlot, PLVep{i, dyad}(condition,:));
    end % for connection
  end % for condition
end % for dyad

PLVepDyads{1,1} = 0;                                                        % Calculate average over all dyads for each pair of condition and connection
PLVepDyads{2,1} = 0;

for dyad=1:1:dyads
  PLVepDyads{1,1} = PLVep{1, dyad} + PLVepDyads{1,1};
  PLVepDyads{2,1} = PLVep{2, dyad} + PLVepDyads{2,1};
end

PLVepDyads{1,1} = PLVepDyads{1,1}./dyads;
PLVepDyads{2,1} = PLVepDyads{2,1}./dyads;

cfgPlot.average = true;                                                     % plot the dyad-averaged PLVs

for condition=1:1:4
  subplot(2,4,condition);
  DualPiano_fancyPLVPlot(cfgPlot, PLVepDyads{1,1}(condition,:));
  subplot(2,4,condition+4);
  DualPiano_fancyPLVPlot(cfgPlot, PLVepDyads{2,1}(condition,:));
end

subplot(2,4,3);
text(-0.95, 1.15, subplot_title, 'units', 'normalized', 'FontSize', 13, ...  % set title for the whole graphic
  'FontWeight', 'bold');

disp('data processing accomplished!');                                      % note the end of the process

data_processed.fsample          = Fs;                                       % put all relevant intermediate results to an output data structure
data_processed.time             = time;
data_processed.connections      = connections;                              
data_processed.dyads            = dyads;
data_processed.labelcmp         = labelcmp;
data_processed.PLVep            = PLVep;
data_processed.PLVs             = PLVs;
data_processed.PLVmean          = PLVmean;
data_processed.PLVepDyads       = PLVepDyads;

% -------------------------------------------------------------------------
% Save graphic as pdf-File
% -------------------------------------------------------------------------
h=gcf;                                                                      
set(h, 'PaperOrientation','landscape');
set(h, 'PaperType','a3');
set(h, 'PaperUnit', 'centimeters');
set(h, 'PaperSize', [42 29.7]);
set(h, 'unit', 'normalized', 'Position', [0 0 1 0.9]);
print(gcf, '-dpdf', '../../results/DualPiano_analysis/output.pdf');

% -------------------------------------------------------------------------
% Clear temporary variables in workspace
% Release figure
% -------------------------------------------------------------------------
clear ans i cfgPLV Fs freqLow freqHigh motorRightPlayerOne ... 
  motorLeftPlayerOne motorRightPlayerTwo motorLeftPlayerTwo PLV_winSize ...
  FirstStart FirstStop pauseStart pauseStop SecondStart SecondStop time ...
  nmbrProb marker componentA componentB condition connections data dyad ...
  data_PLV PLVep labelcmp dyads PLVs PLVmean data_CF data_CU data_UF ...
  data_UU PLVepDyads cfgPlot subplot_title
figure(1); hold off;
