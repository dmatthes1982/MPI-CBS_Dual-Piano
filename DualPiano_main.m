% -------------------------------------------------------------------------
% General definitions
% -------------------------------------------------------------------------
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
% Calculate PLV for CONGRUENT/FAMILIAR condition
% -------------------------------------------------------------------------
[ PLVmean, ~, hilbert_avRatio ] = DualPiano_PLVoverTrials( data_CF, ...     % Player 1 - right hand vs. Player 2 - left hand
  alphaLow, alphaHigh, motorRightPlayerOne, motorLeftPlayerTwo, ... 
  PLV_winSize );

PLVep.rOne_vs_lTwo{1}(1,1) = mean(PLVmean(FirstStart:FirstStop), ...
                              'omitnan');
PLVep.rOne_vs_lTwo{1}(1,2) = mean(PLVmean(pauseStart:pauseStop), ...
                              'omitnan');
PLVep.rOne_vs_lTwo{1}(1,3) = mean(PLVmean(SecondStart:SecondStop), ...
                              'omitnan');

if(min(min(hilbert_avRatio)) < 50)
  warning('Some "Hilbert average value" during condition data_CF_1 is < 50');
end

figure(1);
title('PLV over epochs (CONGRUENT/FAMILIAR condition)');
DualPiano_fancyPLVPlot(PLVep.rOne_vs_lTwo{1}(1,:), time, marker, 1);

[ PLVmean, ~, hilbert_avRatio ] = DualPiano_PLVoverTrials( data_CF, ...     % Player 1 - left hand vs. Player 2 - right hand
  alphaLow, alphaHigh, motorLeftPlayerOne, motorRightPlayerTwo, ... 
  PLV_winSize );

PLVep.lOne_vs_rTwo{1}(1,1) = mean(PLVmean(FirstStart:FirstStop), ...
                              'omitnan');
PLVep.lOne_vs_rTwo{1}(1,2) = mean(PLVmean(pauseStart:pauseStop), ...
                              'omitnan');
PLVep.lOne_vs_rTwo{1}(1,3) = mean(PLVmean(SecondStart:SecondStop), ...
                              'omitnan');

if(min(min(hilbert_avRatio)) < 50)
  warning('Some "Hilbert average value" during condition data_CF_2 is < 50');
end

figure(2);
title('PLV over epochs (CONGRUENT/FAMILIAR condition)');
DualPiano_fancyPLVPlot(PLVep.lOne_vs_rTwo{1}(1,:), time, marker, 1);


% -------------------------------------------------------------------------
% Clear temporary variables in workspace
% Release plots
% -------------------------------------------------------------------------
clear ans i Fs alphaLow alphaHigh motorRightPlayerOne ... 
  motorLeftPlayerOne motorRightPlayerTwo motorLeftPlayerTwo PLV_winSize ...
  hilbert_avRatio PLVmean FirstStart FirstStop pauseStart pauseStop ...
  SecondStart SecondStop time nmbrProb marker
figure(1); hold off;
figure(2); hold off;
