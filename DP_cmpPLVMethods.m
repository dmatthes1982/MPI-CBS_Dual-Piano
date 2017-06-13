function [ hilbert_avRatio ] = DP_cmpPLVMethods( data_in, lfreq, ...
  hfreq, trial, cmp1, cmp2, winSize )
% DP_CMPPLVMETHODS compares two diffent methods for the phase lock
% value (PLV) estimation
%
% Params:
%   data_in         fieldtrip data structure
%   lfreq           lower cutoff frequency
%   hfreq           higher cutoff frequency
%   trial           number of the selected trial
%   cmp1            number of the first component
%   cmp2            number of the second component
%   winSize         window size for a sliding PLV calculation over time
%
% Output:
%   hilbert_avRatio   hilbert average ratio for validity control
%
% The first method utilize the FFT and the FT_CONNECTIVITYANALYSIS.
% The second method depends on the Hilbert transform
%
% This function requires the fieldtrip toolbox
%
% See also DUALPIANO_BANDPASS, DUALPIANO_HILBERT, DUALPIANO_FIELDTRIPPHASE,
% DUALPIANO_PHASELOCKVAL

% Copyright (C) 2017, Daniel Matthes, MPI CBS

warning('off','all'); 

time = data_in.time{trial};                                                 % extract the time vector                                               

% -------------------------------------------------------------------------
% First method ("Hilbert-Method")
% -------------------------------------------------------------------------
data_filt = DP_bandpass( data_in, lfreq, hfreq, true );              % extract the desired passband
data_hilbert = DP_hilbert( data_filt, 'angle');                      % estimate the hilbert phase

hilbert_avRatio = data_hilbert.hilbert_avRatio;                             % save the hilbert average ratio (control validity)
                                                                            % see DUALPIANO_HILBERT for further informations
phase1 = data_hilbert.trial{trial}(cmp1,:);                                 % extract phase of first component
phase2 = data_hilbert.trial{trial}(cmp2,:);                                 % extract phase of the second component
relPhase_hilbert = phase1 - phase2;                                         % extimate phase difference
PLV_hilbert = DP_phaseLockVal(relPhase_hilbert, winSize);            % calculate PLV (see DUALPIANO_PHASELOCKVAL) for further informations

% -------------------------------------------------------------------------
% Second method ("FFT-Method")
% -------------------------------------------------------------------------
data_fieldtripPhase = DP_fieldtripPhase( data_in, lfreq, hfreq, ...  % estimate the phase difference using FT_CONNECTIVITYANALYSIS 
                                            trial, cmp1, cmp2 );            % together with 'plv' param.
slot = ceil((hfreq+lfreq)/2/(hfreq-lfreq));                                 % extract the desired passband
relPhase_fieldtrip(:) = data_fieldtripPhase.plvspctrm(1, slot, :);          % extract phase difference information
PLV_fieldtrip = DP_phaseLockVal(relPhase_fieldtrip, winSize);        % calculate PLV

% -------------------------------------------------------------------------
% Plot result of first method
% -------------------------------------------------------------------------
figure;
plot(time ,mod(relPhase_hilbert, 2*pi));
hold on;
title('Phase Difference');
ylabel('phase difference');
xlabel('time in sec');
plot(time ,mod(relPhase_fieldtrip, 2*pi));
legend('phaseDiff-hilbert', 'phaseDiff-fft');

% -------------------------------------------------------------------------
% Plot result of second method
% -------------------------------------------------------------------------
figure;
plot(time ,PLV_hilbert);
hold on;
title('Phase Locking Value');
ylabel('PLV');
xlabel('time in sec');
plot(time ,PLV_fieldtrip);
legend('PLV-hilbert', 'PLV-fft');

warning('on','all');

end