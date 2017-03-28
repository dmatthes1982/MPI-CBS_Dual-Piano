function [ data_out ] = DualPiano_PLVoverTrials( cfg, data_in )
% DUALPIANO_PLVOVERTRIALS estimates the phase locking value for different
% connections and within different trials an averages the curves of every
% connection over all trials
%
% Params:
%   data_in         fieldtrip data structure
%   cfg.nmbcmp      Nx2 matrix defining connections and including pairs of
%                   component numbers
%   cfg.labelcmp    Nx2 matrix defining connections and including pairs of
%                   component labels
%   cfg.lfreq       lower cutoff frequency (default: 9 Hz)
%   cfg.hfreq       higher cutoff frequency (default: 11 Hz)
%   cfg.winSize     window size for a sliding PLV calculation over time
%                   (default: 128 samples)
%   cfg.rmErrTrls   true = exclude trials with errors from averaging
%                   (default: false)
%
% Output:
%   data_out        data structure in the style of the fieldtrip data
%                   structure
%
% If no passband is specified the alpha band around 10 Hz will be used.
%
% This function requires the fieldtrip toolbox
%
% See also DUALPIANO_BANDPASS, DUALPIANO_HILBERT, DUALPIANO_PHASELOCKVAL

% Copyright (C) 2017, Daniel Matthes, MPI CBS

warning('off','all');

% -------------------------------------------------------------------------
% Check input
% -------------------------------------------------------------------------
if ~isfield(cfg, 'nmbcmp')                                                  % abort if cfg.nmbcmp or cfg.labelcmp is missing
  error('No cfg.nmbcmp defined!');
end  
if ~isfield(cfg, 'labelcmp')
  error('No cfg.labelcmp defined!');
end

if ~isfield(cfg, 'lfreq')                                                   % set the defaults
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

trials            = length(data_in.trial);                                  % get number of trials
trialLength       = length(data_in.time{1});                                % get trial length
connections       = length(cfg.nmbcmp);                                     % get number of connections

% -------------------------------------------------------------------------
% Allocate memory
% -------------------------------------------------------------------------
diffPhase_hilbert  = cell(connections, 1);                                  % build container for the phase differences     
PLVs              = cell(connections, 1);                                   % build container for the PLVs for each trial
PLVmean           = cell(connections, 1);                                   % build container for the averaged PLVs

for k=1:1:connections
  diffPhase_hilbert{k} = zeros(trials, trialLength);                        % allocate memory for the phase differences
  PLVs{k}             = zeros(trials, trialLength);                         % allocate memory for the trial-based PLVs
end

% -------------------------------------------------------------------------
% Estimate phase differences
% -------------------------------------------------------------------------
data_filt = DualPiano_bandpass( data_in, cfg.lfreq, cfg.hfreq, true );      % extract the desired passband 
data_hilbert = DualPiano_hilbert( data_filt, 'angle');                      % estimate the hilbert phases

% -------------------------------------------------------------------------
% Get number of accurate trials
% -------------------------------------------------------------------------
if cfg.rmErrTrls == true                                                    % if faulty trials should be excluded
  errPlOne = data_hilbert.Mat_cond_pair(:,4);                               % get error vector of first person
  errPlTwo = data_hilbert.Mat_cond_pair(:,5);                               % get error vector of second person
  noError         = ~(errPlOne | errPlTwo);                                 % build no error vector
  accurateTrials  = sum(noError);                                           % Calc number of accurate trials
    
  fprintf('    select %d error-free trials...\n', accurateTrials);
end

% -------------------------------------------------------------------------
% Estimate PLV and averaged PLV trends
% -------------------------------------------------------------------------
for k=1:1:connections                                                       % for every connection                     
  for i=1:1:trials                                                          % for every trial
    diffPhase_hilbert{k}(i, :) = data_hilbert.trial{i}(cfg.nmbcmp{k,1},...  % get specific phase difference trend
      :) - data_hilbert.trial{i}(cfg.nmbcmp{k,2},:);
    PLVs{k}(i, :) = DualPiano_phaseLockVal(diffPhase_hilbert{k}(i, :), ...  % calculate PLVs (see DUALPIANO_PHASELOCKVAL) for further informations 
      cfg.winSize);
  end
  if cfg.rmErrTrls == true                                                  % if faulty trials should be excluded
    tmpPLV = PLVs{k};                                                       % copy trial and connection specific PLV vector 
    tmpPLV = tmpPLV .* noError;                                             % set faulty trials to zero      
    PLVmean{k} = sum(tmpPLV, 1)/accurateTrials;                             % calculate averaged PLV for each connection over all accurate trials
  else
    PLVmean{k} = mean(PLVs{k}, 1);                                          % calculate averaged PLV for each connection over every trials
  end
end

% -------------------------------------------------------------------------
% Build output data structure
% -------------------------------------------------------------------------
data_out = data_hilbert;                                                    % copy hilbert data structure
data_out = rmfield(data_out, {'unmixing','topo', 'topolabel','trial', ...   % remove unnecessary elements
                              'cfg'});
data_out.labelcmp = cfg.labelcmp;                                           % add connections definition 
data_out.PLVmean = PLVmean;                                                 % add averaged PLV trends
data_out.PLVs = PLVs;                                                       % add raw PLV trends

warning('on','all');

end

