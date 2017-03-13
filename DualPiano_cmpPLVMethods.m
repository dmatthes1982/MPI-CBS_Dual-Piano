function [ hilbert_avRatio ] = DualPiano_cmpPLVMethods( data_in, lfreq, hfreq, trial, cmp1, cmp2, winSize )

warning('off','all');

time = data_in.time{trial};

data_alpha = DualPiano_bandpass( data_in, lfreq, hfreq );
data_hilbert = DualPiano_hilbert( data_alpha, 'angle');

hilbert_avRatio = data_hilbert.hilbert_avRatio;

phase1 = data_hilbert.trial{trial}(cmp1,:);
phase2 = data_hilbert.trial{trial}(cmp2,:);
relPhase_hilbert = phase1 - phase2;
PLV_hilbert = DualPiano_phaseLockVal(relPhase_hilbert, winSize);

data_fieldtripPhase = DualPiano_fieldtripPhase( data_in, lfreq, hfreq, trial, cmp1, cmp2 );
slot = ceil((hfreq+lfreq)/2/(hfreq-lfreq));
relPhase_fieldtrip(:) = data_fieldtripPhase.plvspctrm(1, slot, :);
PLV_fieldtrip = DualPiano_phaseLockVal(relPhase_fieldtrip, winSize);

figure;
plot(time ,mod(relPhase_hilbert, 2*pi));
hold on;
title('Phase Difference');
ylabel('phase difference');
xlabel('time in sec');
plot(time ,mod(relPhase_fieldtrip, 2*pi));
legend('phaseDiff-hilbert', 'phaseDiff-fft');

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