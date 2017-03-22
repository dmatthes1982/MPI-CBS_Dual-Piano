function [ data_out ] = DualPiano_PLVoverTrials( cfg, data_in )

warning('off','all');

% abort if cfg.time or cfg.marker is missing
if ~isfield(cfg, 'nmbcmp')
  error('No cfg.nmbcmp defined!');
end  
if ~isfield(cfg, 'labelcmp')
  error('No cfg.labelcmp defined!');
end

% set the defaults
if ~isfield(cfg, 'lfreq')
  cfg.lfreq       = 9;
end
if ~isfield(cfg, 'hfreq')
  cfg.hfreq       = 11;
end
if ~isfield(cfg, 'winSize')
  cfg.winSize     = 128;
end
if ~isfield(cfg, 'rmErrTrls')
  cfg.rmErrTrls   = false;
end

trials            = length(data_in.trial);
trialLength       = length(data_in.time{1});
connections       = length(cfg.nmbcmp);
relPhase_hilbert  = cell(connections, 1);
PLVs              = cell(connections, 1);
PLVmean           = cell(connections, 1);

for k=1:1:connections
  relPhase_hilbert{k} = zeros(trials, trialLength);
  PLVs{k}             = zeros(trials, trialLength);
end

data_alpha = DualPiano_bandpass( data_in, cfg.lfreq, cfg.hfreq );
data_hilbert = DualPiano_hilbert( data_alpha, 'angle');

if cfg.rmErrTrls == true
  errPlOne = data_hilbert.Mat_cond_pair(:,4);
  errPlTwo = data_hilbert.Mat_cond_pair(:,5);
  noError         = ~(errPlOne | errPlTwo);
  accurateTrials  = sum(noError);
    
  fprintf('    select %d error-free trials...\n', accurateTrials);
end

for k=1:1:connections
  for i=1:1:trials
    relPhase_hilbert{k}(i, :) = data_hilbert.trial{i}(cfg.nmbcmp{k,1},:) ...
      - data_hilbert.trial{i}(cfg.nmbcmp{k,2},:);
    PLVs{k}(i, :) = DualPiano_phaseLockVal(relPhase_hilbert{k}(i, :), ...
      cfg.winSize);
  end
  if cfg.rmErrTrls == true
    tmpPLV = PLVs{k};
    tmpPLV = tmpPLV .* noError;
    PLVmean{k} = sum(tmpPLV, 1)/accurateTrials;  
  else
    PLVmean{k} = mean(PLVs{k}, 1);
  end
end

data_out = data_hilbert;
data_out = rmfield(data_out, {'unmixing','topo', 'topolabel','trial','cfg'});
data_out.labelcmp = cfg.labelcmp;
data_out.PLVmean = PLVmean;
data_out.PLVs = PLVs;

warning('on','all');

end

