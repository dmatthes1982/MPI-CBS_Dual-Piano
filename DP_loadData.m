function DP_loadData( number )
%DUALPIANO_LOADDATA 

address = sprintf('../../data/DualPiano/Components_epoched/P%dcomb_condSpec.mat', number);
load(address);

assignin('base','data_CF', data_CF);
assignin('base','data_CU', data_CU);
assignin('base','data_UF', data_UF);
assignin('base','data_UU', data_UU);
assignin('base','probNmbr', number);

end

