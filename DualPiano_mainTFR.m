% DUALPIANO_MAINTFR
%
% This script estimates and illustrates the time frequency response of the
% four motor components (run11_pl1, run14_pl1, run11_pl2 and run14_pl2) for
% a specific conditon (CF, CU, UF or UU) and averaged across all dyads.
% The result possibly leads to appropriate frequency ranges for a
% subsequent investigation of phase locking.
%
% This script requires the fieldtrip toolbox.

% Copyright (C) 2017, Daniel Matthes, MPI CBS


% -------------------------------------------------------------------------
% General definitions
% -------------------------------------------------------------------------
dyads                     = 14;                                             % number of dyads to be included in the averaging
trial                     = 'all';                                          % use all trials of the selected dyads
components                = [2, 3, 5, 6];                                   % plot the TFRs for the motor components
freq_range                = [1 30];                                         % plot all frequency components from 1 to 30 Hz
condition                 = 1;                                              % 1 = CF, 2 = CU, 3 = UF, 4 = UU
tempPowSpctrm             = 0;                                              % temporary variable for the averaging

for dyad=1:1:dyads
  switch dyad                                                               % load the appropriate data
    case 1
      clear data_CF data_CU data_UF data_UU
      load('../../data/Dual_PIANO_data/Components_epoched/P3comb_condSpec.mat');
      disp('01: processing data of dyad No. 3...');
    case 2
      clear data_CF data_CU data_UF data_UU
      load('../../data/Dual_PIANO_data/Components_epoched/P5comb_condSpec.mat');
      disp('02: processing data of dyad No. 5...');
    case 3
      clear data_CF data_CU data_UF data_UU
      load('../../data/Dual_PIANO_data/Components_epoched/P6comb_condSpec.mat');
      disp('03: processing data of dyad No. 6...');
    case 4
      clear data_CF data_CU data_UF data_UU
      load('../../data/Dual_PIANO_data/Components_epoched/P7comb_condSpec.mat');
      disp('04: processing data of dyad No. 7...');
    case 5
      clear data_CF data_CU data_UF data_UU
      load('../../data/Dual_PIANO_data/Components_epoched/P8comb_condSpec.mat');
      disp('05: processing data of dyad No. 8...');
    case 6
      clear data_CF data_CU data_UF data_UU
      load('../../data/Dual_PIANO_data/Components_epoched/P9comb_condSpec.mat');
      disp('06: processing data of dyad No. 9...');
    case 7
      clear data_CF data_CU data_UF data_UU
      load('../../data/Dual_PIANO_data/Components_epoched/P10comb_condSpec.mat');
      disp('07: processing data of dyad No. 10...');
    case 8
      clear data_CF data_CU data_UF data_UU
      load('../../data/Dual_PIANO_data/Components_epoched/P11comb_condSpec.mat');
      disp('08: processing data of dyad No. 11...');
    case 9
      clear data_CF data_CU data_UF data_UU
      load('../../data/Dual_PIANO_data/Components_epoched/P12comb_condSpec.mat');
      disp('09: processing data of dyad No. 12...');
    case 10
      clear data_CF data_CU data_UF data_UU
      load('../../data/Dual_PIANO_data/Components_epoched/P13comb_condSpec.mat');
      disp('10: processing data of dyad No. 13...');
    case 11
      clear data_CF data_CU data_UF data_UU
      load('../../data/Dual_PIANO_data/Components_epoched/P14comb_condSpec.mat');
      disp('11: processing data of dyad No. 14...');
    case 12
      clear data_CF data_CU data_UF data_UU
      load('../../data/Dual_PIANO_data/Components_epoched/P15comb_condSpec.mat');
      disp('12: processing data of dyad No. 15...');
    case 13
      clear data_CF data_CU data_UF data_UU
      load('../../data/Dual_PIANO_data/Components_epoched/P16comb_condSpec.mat');
      disp('13: processing data of dyad No. 16...');
    case 14
      clear data_CF data_CU data_UF data_UU
      load('../../data/Dual_PIANO_data/Components_epoched/P19comb_condSpec.mat');
      disp('14: processing data of dyad No. 19...');
    otherwise
      error('number of cases and value of dyads does not match');
  end
  
  switch condition                                                           % select the desired dataset
    case 1
      data = data_CF;
      disp('    condition CONGRUENT/FAMILIAR');
      subplot_title = 'Time Frequency Response for Condition CF';
    case 2
      data = data_CU;
      disp('    condition CONGRUENT/UNFAMILIAR');
      subplot_title = 'Time Frequency Response for Condition CU';
    case 3
      data = data_UF;
      disp('    condition INCONGRUENT/FAMILIAR');
      subplot_title = 'Time Frequency Response for Condition UF';
    case 4
      data = data_UU;
      disp('    condition INCONGRUENT/UNFAMILIAR');
      subplot_title = 'Time Frequency Response for Condition UU';
    otherwise
        error('unknown condition');
  end
  
  tmp = DualPiano_freqanalysis(data);                                       % calculate the spectrum for the loaded data 
  tempPowSpctrm = tempPowSpctrm + tmp.powspctrm;                            % add the result to the previous one
end

tmp.powspctrm = tempPowSpctrm/dyads;                                        % calculate the average value
DualPiano_singleplotTFR(tmp, trial, components, freq_range);                % plot the results

disp('data processing accomplished!');                                      % note the end of the process

subplot(2,2,2);
text(-0.65, 1.15, subplot_title, 'units', 'normalized', 'FontSize', 13, ... % set title for the whole graphic
  'FontWeight', 'bold');

data_processed = tmp;                                                       % keep the result in workspace

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
% -------------------------------------------------------------------------
clear tmp dyads dyad trial components condition tempPowSpctrm data ...
  subplot_title data_CF data_CU data_UU data_UF h freq_range
