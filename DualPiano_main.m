% -------------------------------------------------------------------------
% General definitions
% -------------------------------------------------------------------------

clear data_CF data_CU data_UF data_UU
load('../../Dual_PIANO_data/Components_epoched/P3comb_condSpec.mat');

Fs                        = data_CF.fsample;                                % sampling rate
alphaLow                  = 9;                                              % lower bandpass frequency
alphaHigh                 = 11;                                             % upper bandpass frequency  
nmbrProb                  = 14;
motorRightPlayerOne       = find(strcmp(data_CF.label, 'run11_pl1'));       % component "motor right" of player one
motorLeftPlayerOne        = find(strcmp(data_CF.label, 'run14_pl1'));       % component "motor left" of player one
motorRightPlayerTwo       = find(strcmp(data_CF.label, 'run11_pl2'));       % component "motor right" of player two
motorLeftPlayerTwo        = find(strcmp(data_CF.label, 'run14_pl2'));       % component "motor left" of player two
PLV_winSize               = Fs;                                             % window size for sliding PLV calculation
FirstStart                = 1;
FirstStop                 = find(data_CF.time{1} == 4) - 1;
pauseStart                = find(data_CF.time{1} == 4);
pauseStop                 = find(data_CF.time{1} == 8) - 1;
SecondStart               = find(data_CF.time{1} == 8);
SecondStop                = length(data_CF.time{1});
time                      = data_CF.time{1};
marker                    = [4, 8];

% -------------------------------------------------------------------------
% Allocating memory
% -------------------------------------------------------------------------
PLVep                 = struct('rOne_vs_lTwo', 'lOne_vs_rTwo');
PLVep.rOne_vs_lTwo    = cell(1, nmbrProb);
PLVep.lOne_vs_rTwo    = cell(1, nmbrProb);

for i=1:1:nmbrProb
  PLVep.rOne_vs_lTwo{i} = zeros(4,3);
  PLVep.lOne_vs_rTwo{i} = zeros(4,3);
end

% -------------------------------------------------------------------------
% Initialize plots
% -------------------------------------------------------------------------
figure(1);
subplot(2,4,1,'replace');
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

% -------------------------------------------------------------------------
% Calculate PLV for all dyads, conditions and connections
% -------------------------------------------------------------------------
for dyad=1:1:14
  switch dyad
    case 1
      background = 1;
      disp('data of dyad 3 processed...');
    case 2
      clear data_CF data_CU data_UF data_UU
      load('../../Dual_PIANO_data/Components_epoched/P5comb_condSpec.mat');
      background = 0;
      disp('processing data of dyad 5...');
    case 3
      clear data_CF data_CU data_UF data_UU
      load('../../Dual_PIANO_data/Components_epoched/P6comb_condSpec.mat');
      disp('processing data of dyad 6...');
    case 4
      clear data_CF data_CU data_UF data_UU
      load('../../Dual_PIANO_data/Components_epoched/P7comb_condSpec.mat');
      disp('processing data of dyad 7...');
    case 5
      clear data_CF data_CU data_UF data_UU
      load('../../Dual_PIANO_data/Components_epoched/P8comb_condSpec.mat');
      disp('processing data of dyad 8...');
    case 6
      clear data_CF data_CU data_UF data_UU
      load('../../Dual_PIANO_data/Components_epoched/P9comb_condSpec.mat');
      disp('processing data of dyad 9...');
    case 7
      clear data_CF data_CU data_UF data_UU
      load('../../Dual_PIANO_data/Components_epoched/P10comb_condSpec.mat');
      disp('processing data of dyad 10...');
    case 8
      clear data_CF data_CU data_UF data_UU
      load('../../Dual_PIANO_data/Components_epoched/P11comb_condSpec.mat');
      disp('processing data of dyad 11...');
    case 9
      clear data_CF data_CU data_UF data_UU
      load('../../Dual_PIANO_data/Components_epoched/P12comb_condSpec.mat');
      disp('processing data of dyad 12...');
    case 10
      clear data_CF data_CU data_UF data_UU
      load('../../Dual_PIANO_data/Components_epoched/P13comb_condSpec.mat');
      disp('processing data of dyad 13...');
    case 11
      clear data_CF data_CU data_UF data_UU
      load('../../Dual_PIANO_data/Components_epoched/P14comb_condSpec.mat');
      disp('processing data of dyad 14...');
    case 12
      clear data_CF data_CU data_UF data_UU
      load('../../Dual_PIANO_data/Components_epoched/P15comb_condSpec.mat');
      disp('processing data of dyad 15...');
    case 13
      clear data_CF data_CU data_UF data_UU
      load('../../Dual_PIANO_data/Components_epoched/P16comb_condSpec.mat');
      disp('processing data of dyad 16...');
    case 14
      clear data_CF data_CU data_UF data_UU
      load('../../Dual_PIANO_data/Components_epoched/P19comb_condSpec.mat');
      disp('processing data of dyad 19...');
  end
  for condition=1:1:4
    switch condition
      case 1
        data = data_CF;
      case 2
        data = data_CU;
      case 3
        data = data_UF;
      case 4
        data = data_UU;
    end
    for connection=1:1:2
      switch connection
        case 1
          componentA = motorRightPlayerOne;
          componentB = motorLeftPlayerTwo;
        case 2
          componentA = motorLeftPlayerOne;
          componentB = motorRightPlayerTwo;
      end
    
      [ PLVmean, ~, hilbert_avRatio ] = DualPiano_PLVoverTrials( data, ... 
        alphaLow, alphaHigh, componentA, componentB, PLV_winSize );
    
      if(min(min(hilbert_avRatio)) < 50)
        warning('Some "Hilbert average value" is < 50');
      end
    
      if connection == 1
        PLVep.rOne_vs_lTwo{dyad}(condition,1) = mean(PLVmean( ...
                                FirstStart:FirstStop), 'omitnan');
        PLVep.rOne_vs_lTwo{dyad}(condition,2) = mean(PLVmean( ...
                                pauseStart:pauseStop), 'omitnan');
        PLVep.rOne_vs_lTwo{dyad}(condition,3) = mean(PLVmean( ...
                                SecondStart:SecondStop), 'omitnan');
        subplot(2,4,condition);
        DualPiano_fancyPLVPlot(PLVep.rOne_vs_lTwo{dyad}(condition,:), ...
          time, marker, background);
      else
        PLVep.lOne_vs_rTwo{dyad}(condition,1) = mean(PLVmean( ...
                                FirstStart:FirstStop), 'omitnan');
        PLVep.lOne_vs_rTwo{dyad}(condition,2) = mean(PLVmean( ...
                                pauseStart:pauseStop), 'omitnan');
        PLVep.lOne_vs_rTwo{dyad}(condition,3) = mean(PLVmean( ...
                                SecondStart:SecondStop), 'omitnan');
        subplot(2,4,condition + 4);
        DualPiano_fancyPLVPlot(PLVep.lOne_vs_rTwo{dyad}(condition,:), ...
          time, marker, background);
      end % if connection
    end % for connection
  end % for condition
end % for dyad

disp('data processing accomplished!');

% -------------------------------------------------------------------------
% Clear temporary variables in workspace
% Release plots
% -------------------------------------------------------------------------
clear ans i Fs alphaLow alphaHigh motorRightPlayerOne ... 
  motorLeftPlayerOne motorRightPlayerTwo motorLeftPlayerTwo PLV_winSize ...
  hilbert_avRatio PLVmean FirstStart FirstStop pauseStart pauseStop ...
  SecondStart SecondStop time nmbrProb marker componentA componentB ...
  condition connection data dyad background
figure(1); hold off;

