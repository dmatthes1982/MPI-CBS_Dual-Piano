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
% Using the variable freqLimit, the desired passband can be specified.
%
% This script requires the fieldtrip toolbox.

% Copyright (C) 2017, Daniel Matthes, MPI CBS

% -------------------------------------------------------------------------
% General definitions
% -------------------------------------------------------------------------
dyads                     = [3, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15 ...     
                              16, 19];                                      % specify the number of different dyads 

fprintf('processing data of %d different dyads...\n', length(dyads));
clear data_CF data_CU data_UF data_UU
load('../../data/DualPiano/Components_epoched/P3comb_condSpec.mat');

Fs                        = data_CF.fsample;                                % sampling rate
% bandpass templates
freqLimitGenAlpha         = ones(19,2).*[9, 11];                            % fix alpha range for all dyads (bandwidth: 2 Hz)
freqLimitGenBeta          = ones(19,2).*[17, 19];                           % fix beta range for all dyads (bandwidth: 2 Hz)
freqLimitSpecAlpha        = [10, 10; 10, 10; 8, 10; 10, 10; 8.5, 10.5; ...  % dyad specific alpha range (bandwidth: 2 Hz, dyad 11 should be excluded)
                              9, 11; 9.5, 11.5; 10.5, 12.5; 10, 12; 8.5,...
                              10.5; 8, 12; 10, 12; 7.5, 9.5; 10, 12; 9, ...
                              11; 10, 12; 10, 10; 10, 10; 10, 12];
freqLimitSpecBeta         = [20, 20; 20, 20; 16, 20; 20, 20; 17, 21; 18,... % dyad specific beta range (bandwidth: 4 Hz, dyad 7 and 11 should be excluded)
                              22; 16, 22; 21, 25; 20, 24; 17, 21; 16, ...
                              24; 20, 24; 15, 19; 20, 24; 18, 22; 20, ...
                              24; 20, 20; 20, 20; 20, 24];
freqLimit                 = freqLimitSpecBeta;                              % select one of the four freqLimit specifications

figure_title              = sprintf(['Phase Locking Values - Passband:' ... % generate title of figure depenting on the choosen passband
                                     ' %.1f Hz - %.1f Hz'], ...
                                     min(min(freqLimit)), ...
                                     max(max(freqLimit)));      
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
PLVep                     = cell(2, max(dyads));                            % container for trial and epoch averaged PLVs
PLVs                      = cell(2, max(dyads));                            % container for raw PLVs
PLVmean                   = cell(2, max(dyads));                            % container for trial averaged PLVs

for i=dyads
  PLVep{1,i} = zeros(4,3);
  PLVep{2,i} = zeros(4,3);
end

% -------------------------------------------------------------------------
% Create panels for headline and the 8 subplots
% -------------------------------------------------------------------------
f = figure;
p = uipanel('Parent', f, 'BackgroundColor', 'white', 'BorderType', ...      % create panel p for the subplots
  'none', 'Position', [0 0 1 0.95]);
q = uipanel('Parent', f, 'BackgroundColor', 'white', 'BorderType', ...      % create panel r for the headline
  'none', 'Position', [0 0.95 1 0.05]);

% -------------------------------------------------------------------------
% Initialize plots
% -------------------------------------------------------------------------
subplot(2,4,1,'replace','Parent',p);                                        % initialize figure with 8 subplots                                               
title('CONGRUENT/FAMILIAR');                                                % one for each pair of condition and connection
ylabel('PLV - Pl1 right vs. Pl2 left');
xlabel('time in sec');
subplot(2,4,2,'replace','Parent',p);
title('CONGRUENT/UNFAMILIAR');
xlabel('time in sec');
subplot(2,4,3,'replace','Parent',p);
title('INCONGRUENT/FAMILIAR');
xlabel('time in sec');
subplot(2,4,4,'replace','Parent',p);
title('INCONGRUENT/UNFAMILIAR');
xlabel('time in sec');
subplot(2,4,5,'replace','Parent',p);
title('CONGRUENT/FAMILIAR');
ylabel('PLV - Pl1 left vs. Pl2 right');
xlabel('time in sec');
subplot(2,4,6,'replace','Parent',p);
title('CONGRUENT/UNFAMILIAR');
xlabel('time in sec');
subplot(2,4,7,'replace','Parent',p);
title('INCONGRUENT/FAMILIAR');
xlabel('time in sec');
subplot(2,4,8,'replace','Parent',p);
title('INCONGRUENT/UNFAMILIAR');
xlabel('time in sec');

cfgPlot             = [];                                                   % initialize the plot config
cfgPlot.time        = time;
cfgPlot.marker      = marker;
cfgPlot.background  = true;
cfgPlot.average     = false;

signalName = {'phrase 1', 'pause', 'phrase 2'};                             % initialize the legend vector
z=4;                                                                        % pointer to next element of signalName

% -------------------------------------------------------------------------
% Calculate PLV for all dyads, conditions and connections
% -------------------------------------------------------------------------
for dyad=dyads                                                              % For all specified dyads
  switch dyad                                                               % load the appropriate data
    case 3
      disp('processing data of dyad No. 3...');
    case 5
      clear data_CF data_CU data_UF data_UU
      load('../../data/DualPiano/Components_epoched/P5comb_condSpec.mat');
      cfgPlot.background = false;
      disp('processing data of dyad No. 5...');
    case 6
      clear data_CF data_CU data_UF data_UU
      load('../../data/DualPiano/Components_epoched/P6comb_condSpec.mat');
      disp('processing data of dyad No. 6...');
    case 7
      clear data_CF data_CU data_UF data_UU
      load('../../data/DualPiano/Components_epoched/P7comb_condSpec.mat');
      disp('processing data of dyad No. 7...');
    case 8
      clear data_CF data_CU data_UF data_UU
      load('../../data/DualPiano/Components_epoched/P8comb_condSpec.mat');
      disp('processing data of dyad No. 8...');
    case 9
      clear data_CF data_CU data_UF data_UU
      load('../../data/DualPiano/Components_epoched/P9comb_condSpec.mat');
      disp('processing data of dyad No. 9...');
    case 10
      clear data_CF data_CU data_UF data_UU
      load('../../data/DualPiano/Components_epoched/P10comb_condSpec.mat');
      disp('processing data of dyad No. 10...');
    case 11
      clear data_CF data_CU data_UF data_UU
      load('../../data/DualPiano/Components_epoched/P11comb_condSpec.mat');
      disp('processing data of dyad No. 11...');
    case 12
      clear data_CF data_CU data_UF data_UU
      load('../../data/DualPiano/Components_epoched/P12comb_condSpec.mat');
      disp('processing data of dyad No. 12...');
    case 13
      clear data_CF data_CU data_UF data_UU
      load('../../data/DualPiano/Components_epoched/P13comb_condSpec.mat');
      disp('processing data of dyad No. 13...');
    case 14
      clear data_CF data_CU data_UF data_UU
      load('../../data/DualPiano/Components_epoched/P14comb_condSpec.mat');
      disp('processing data of dyad No. 14...');
    case 15
      clear data_CF data_CU data_UF data_UU
      load('../../data/DualPiano/Components_epoched/P15comb_condSpec.mat');
      disp('processing data of dyad No. 15...');
    case 16
      clear data_CF data_CU data_UF data_UU
      load('../../data/DualPiano/Components_epoched/P16comb_condSpec.mat');
      disp('processing data of dyad No. 16...');
    case 19
      clear data_CF data_CU data_UF data_UU
      load('../../data/DualPiano/Components_epoched/P19comb_condSpec.mat');
      disp('processing data of dyad No. 19...');
    otherwise
      error('number of cases and value of dyads does not match');
  end
  for condition=1:1:4
    switch condition                                                        % over all condition
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
    cfgPLV.lfreq     = freqLimit(dyad, 1);                                  % define bandpass  
    cfgPLV.hfreq     = freqLimit(dyad, 2);
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
      if(condition == 4 && i == 2)
        signalName{z} = sprintf('dyad %.0f', dyad);                         % add dyad number to the legend vector
        z = z + 1;                                                          % increase the pointer
      end
    end % for connection
  end % for condition
end % for dyad

% -------------------------------------------------------------------------
% Calculate average over all dyads for each pair of condition and
% connection
% -------------------------------------------------------------------------
PLVepDyads{1,1} = 0;                                                        
PLVepDyads{2,1} = 0;

for dyad=dyads
  PLVepDyads{1,1} = PLVep{1, dyad} + PLVepDyads{1,1};
  PLVepDyads{2,1} = PLVep{2, dyad} + PLVepDyads{2,1};
end

n = length(dyads);

PLVepDyads{1,1} = PLVepDyads{1,1}./n;
PLVepDyads{2,1} = PLVepDyads{2,1}./n;

cfgPlot.average = true;                                                     % plot the dyad-averaged PLVs

for condition=1:1:4
  subplot(2,4,condition);
  DualPiano_fancyPLVPlot(cfgPlot, PLVepDyads{1,1}(condition,:));
  subplot(2,4,condition+4);
  DualPiano_fancyPLVPlot(cfgPlot, PLVepDyads{2,1}(condition,:));
end

signalName{z} = 'mean';                                                     % add the mean signal to the legend vector
subplot(2,4,8);                                     
legend1 = legend(signalName);                                               % plot the legend

disp('data processing accomplished!');                                      % note the end of the process

% -------------------------------------------------------------------------
% Resize y-axis subplots to common base
% Set title for the whole graphic
% -------------------------------------------------------------------------
y_min = 1;                                                                 
y_max = 0;
for sub=1:1:8
  subplot(2,4,sub);
  y_limits = get(gca,'ylim');
  if y_limits(1) < y_min
    y_min = y_limits(1);
  end
  if y_limits(2) > y_max
    y_max = y_limits(2);
  end
end

for sub=1:1:8
  subplot(2,4,sub);
  ylim([y_min y_max]);
end

q.Title = figure_title; 
q.TitlePosition = 'centerbottom'; 
q.FontSize = 12;
q.FontWeight = 'bold';

% -------------------------------------------------------------------------
% Put all relevant intermediate results to an output data structure
% -------------------------------------------------------------------------
data_processed.fsample          = Fs;                                       
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
set(h, 'unit', 'normalized', 'Position', [0 0 0.9 0.9]);
set(legend1, 'unit', 'normalized', 'Position', [0.925 0.3 0.05 0.45]);      % change position of the legend
print(gcf, '-dpdf', '../../results/DualPiano/output.pdf');

% -------------------------------------------------------------------------
% Clear temporary variables in workspace
% Release figure
% -------------------------------------------------------------------------
clear ans i cfgPLV Fs motorRightPlayerOne motorLeftPlayerOne ...
  motorRightPlayerTwo motorLeftPlayerTwo PLV_winSize FirstStart ...
  FirstStop pauseStart pauseStop SecondStart SecondStop time nmbrProb ...
  marker componentA componentB condition connections data dyad data_PLV ...
  PLVep labelcmp dyads PLVs PLVmean data_CF data_CU data_UF data_UU ...
  PLVepDyads cfgPlot subplot_title y_limits y_max y_min h freqLimit sub ...
  n freqLimitGenAlpha freqLimitGenBeta freqLimitSpecAlpha ...
  freqLimitSpecBeta z legend1 signalName f p q
figure(1); hold off;
