function qsm = MEDIL1_Wrapper(iFreq, RDF, weights, ...
    Mask, Mask_CSF, isSMV, hdr)

% Load initial vars
TE = hdr.TE;
iMag = hdr.iMag;
voxel_size = hdr.voxel_size;
matrix_size = hdr.matrix_size;
FS = hdr.FS;

delta_TE = TE(2)-TE(1);

if FS == 3
    CF                          = 42.577*2.893*10^6;
elseif FS == 7
    CF                          = 42.577*7*10^6;
end

% CSF Mask handling
if isempty(Mask_CSF)
    Mask_CSF       = [];
end

% MEDI expects local field in rad
RDF                 = RDF.*(2*pi*delta_TE);

% MEDI_L1 expects field map standard deviation (N_std)
N_std               = (1./weights).*Mask;
N_std(isnan(N_std)) = 0;
N_std(isinf(N_std)) = 0;
N_std               = N_std / norm(N_std(Mask>0));

% Save RDF in correct format
tmp_output_dir              = [pwd filesep];
tmp_filename                = [tmp_output_dir 'tmp_RDF.mat'];
B0_dir                      = [0 0 -1];

% matching naming convention for MEDI_L1
save(tmp_filename, 'iFreq', 'RDF', 'N_std', 'iMag', ...
    'Mask', 'matrix_size', 'voxel_size', 'delta_TE', ...
    'CF', 'B0_dir', 'Mask_CSF');

if exist(fullfile('.','results'),'dir')
    isResultDirMEDIExist = true;
else
    isResultDirMEDIExist = false;
end

% Algorithm parameters
lambda = 1000;
isMerit = 1;
wData = 1;
wGrad = 1;
pad = 0;
lam_CSF = 100;
percentage = 0.9;
radius = 5;

if isSMV
    qsm = MEDI_L1('filename',tmp_filename,'lambda',lambda,'data_weighting',wData,'gradient_weighting',wGrad,...
        'merit',isMerit,'smv',radius,'zeropad',pad,'lambda_CSF',lam_CSF,'percentage',percentage);
    SphereK = single(sphere_kernel(matrix_size, voxel_size,radius));
    Mask = SMV(Mask, SphereK)>0.999;
else
    qsm = MEDI_L1('filename',tmp_filename,'lambda',lambda,'data_weighting',wData,'gradient_weighting',wGrad,...
        'merit',isMerit,'zeropad',pad,'lambda_CSF',lam_CSF,'percentage',percentage);
end

qsm = qsm .* Mask;

% clean up MEDI output and temp files
delete(tmp_filename);
if isResultDirMEDIExist
    fileno=getnextfileno(['results' filesep],'x','.mat') - 1;
    resultsfile=strcat(['results' filesep 'x'],sprintf('%08u',fileno), '.mat');
    delete(resultsfile)
else
    rmdir(fullfile(pwd,'results'),'s');
end

end