%% Wrapper_NLLS
%'7T_BL', '7T_BL_Rep',  TODO Later
i =   { '7T_9mth', 'TE1to3_9mth', '7T_24mth', ...
    'TE1to3_24mth', '7T_24mth_Rep', 'TE1to3_24mth_Rep' };
isParallel = 0;

for dataset = i
    data_fn = strcat(dataset{1},'_SDC_forR2s');
    load(data_fn, "Magn", "Mask", "TE");
    NUM_MAGN = length(TE);
    % **NB** Altered line 104 of R2star_NLLS.m as follows: 
    % options = optimoptions('lsqnonlin', 'Algorithm','levenberg-marquardt');
    [r2s, ~, m0] = R2star_NLLS(Magn, TE, Mask, isParallel, NUM_MAGN);
    r2s = r2s .* Mask;
    savefile = strcat(dataset{1}, '_SDC_R2s.mat');
    save(savefile, 'r2s', 'm0');
end