function [ PLV ] = DualPiano_phaseLockVal( relPhase, windowSize )

relPhaseSize = size(relPhase, 2);

PLV = zeros(1, relPhaseSize);

for n = 1:1:windowSize/2
    PLV(n) = NaN(1);
end

for n = relPhaseSize-windowSize/2:1:relPhaseSize
    PLV(n) = NaN(1);
end

for n = windowSize/2+1:1:relPhaseSize-windowSize/2-1
    a = n-windowSize/2;
    b = n+windowSize/2-1; 
    window = relPhase(a:b);
    PLV(n) = abs(sum(exp(1i*window))/windowSize);
end

end