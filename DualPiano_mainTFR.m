% -------------------------------------------------------------------------
% General definitions
% -------------------------------------------------------------------------
dyads                     = 14;
trial                     = 'all';
components                = [2, 3, 5, 6];
condition                 = 1;
tempPowSpctrm             = 0;

for dyad=1:1:dyads
  switch dyad                                                               % load the appropriate data
    case 1
      clear data_CF data_CU data_UF data_UU
      load('../../Dual_PIANO_data/Components_epoched/P3comb_condSpec.mat');
      disp('01: processing data of dyad No. 3...');
    case 2
      clear data_CF data_CU data_UF data_UU
      load('../../Dual_PIANO_data/Components_epoched/P5comb_condSpec.mat');
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
  
  switch condition                                                           % select condition
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
    otherwise
        error('unknown condition');
  end
  
  tmp = DualPiano_freqanalysis(data);
  tempPowSpctrm = tempPowSpctrm + tmp.powspctrm;  
end

tmp.powspctrm = tempPowSpctrm/dyads;
DualPiano_singleplotTFR(tmp, trial, components);

disp('data processing accomplished!');                                      % note the end of the process

data_processed = tmp;

% -------------------------------------------------------------------------
% Clear temporary variables in workspace
% Release figure
% -------------------------------------------------------------------------
clear tmp dyads dyad trial components condition tempPowSpctrm data

hold off;

