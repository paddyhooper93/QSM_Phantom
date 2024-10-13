%% CalculateChiMapfromLF.m
% Step 1: Convert from map of local frequencies (Hz) to (normalized) local
% map (dimensionless in parts-per-million)
% Step 2: Inf.Cyl.Assumption (prl B0)

% Input:
% lf = local frequencies (Hz),
% delta = normalized local map (ppm),
% Output:
% chi = chimap for Inf. Cyl. (prl B0) (ppm)


function chi = CalculateChiMapfromLF(lf,fs)

gamma = 42.577; %MHz/T

if fs == 3
    B0 = 2.893; % nominal strength for Siemens 3 T scanners
elseif fs == 7
    B0 = fs;
end

delta = lf/(gamma * B0);
chi = 3 * delta;

end
