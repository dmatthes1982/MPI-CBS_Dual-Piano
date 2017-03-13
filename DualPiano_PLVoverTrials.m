function [ PLVmean, hilbert_avRatio ] = DualPiano_PLVoverTrials( data_in, lfreq, hfreq, cmp1, cmp2, winSize )

warning('off','all');

time = data_in.time{1};
trials = length(data_in.trial);
trialLength = length(data_in.time{1});
relPhase_hilbert = zeros(trials, trialLength);
PLVs = zeros(trials, trialLength);

data_alpha = DualPiano_bandpass( data_in, lfreq, hfreq );
data_hilbert = DualPiano_hilbert( data_alpha, 'angle');

hilbert_avRatio = data_hilbert.hilbert_avRatio;

for i=1:1:trials
    relPhase_hilbert(i, :) = data_hilbert.trial{i}(cmp1,:) - data_hilbert.trial{i}(cmp2,:);
end

for i=1:1:trials
    PLVs(i, :) = DualPiano_phaseLockVal(relPhase_hilbert(i, :), winSize);
end

PLVmean = mean(PLVs, 1);

figure(1);
plot(time, PLVmean);
hold on;
title('Phase Locking Value');
ylabel('PLV');
xlabel('time in sec');

warning('on','all');

end

