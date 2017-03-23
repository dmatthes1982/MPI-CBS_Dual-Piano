function [ PLV ] = DualPiano_phaseLockVal( diffPhase, T )
% DUALPIANO_PHASELOCKVAL estimates the sliding phase locking value of a signal
% of phase differences
%
% Params:
%   diffPhase       phase difference of two eeg signals
%   T               averaging period
%
% Output:
%   PLV             phase locking value
%
%                                    T
% Equation:         PLV(t) = 1/T | Sigma(e^j(phi(n,t) - psi(n,t)) |
%                                   n=1
% 
% The phase locking value is originally defined by Lachaux as a summation
% over N trials. Since this definition is only applicable for comparing
% event-related data, this function provides a variant of the originally
% version. In this case the summation is done over a sliding time
% intervall. This version has been frequently used in EEG hyperscanning
% studies.
%
% Reference:
%   [Lachaux1999]   "Measuring Phase Synchrony in Brain Signals"

% -------------------------------------------------------------------------
% Initializiation of the calculation
% -------------------------------------------------------------------------
diffPhaseSize = size(diffPhase, 2);                                         % get the signal length
PLV = zeros(1, diffPhaseSize);                                              % allocate memory for the result vector

for n = 1:1:T/2
    PLV(n) = NaN(1);                                                        % set the first T/2 values to NaN
end

for n = diffPhaseSize-T/2:1:diffPhaseSize                                   % set the last T/2 values also to NaN
    PLV(n) = NaN(1);
end

% -------------------------------------------------------------------------
% Calculation of the phase locking value
% -------------------------------------------------------------------------
for n = T/2+1:1:diffPhaseSize-T/2-1
    a = n-T/2;
    b = n+T/2-1; 
    window = diffPhase(a:b);
    PLV(n) = abs(sum(exp(1i*window))/T);
end

end