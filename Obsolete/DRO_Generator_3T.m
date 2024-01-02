%% Digital Object Reference (DRO) Generator: Simulated cylindrical vials
clc
clearvars

% % File structure
% input_dir = 'C:\vnm\DRO_220726\Polygons\';
% input_polygon_file = 'DRO_Assembly_5mm_air.stl';
% output_dir = 'C:\vnm\3T_RR05_VSHARP_Star_VSHARP-MEDI\Voxels\';
% output_voxel_file = 'Voxels_160by160by210_5mm_air.nii.nii';
% 
% % Prepare geometry from CAD file for segmentation
% 
% polygons = stlread(strcat(input_dir,input_polygon_file));
% voxels = polygon2voxel(polygons,[160 160 210], 'auto');
% 
% voxels_resample = resample(double(voxels),21,16);
% voxels_resample = resample(double(voxels_resample),21,16,'Dimension',2);
% voxels_binary = imbinarize(voxels_resample); 
% voxels_nii = make_nii(double(voxels_binary));
% save_nii(voxels_nii, strcat(output_dir,output_voxel_file));
% return
% 
% %% Prepare segmented geometry for DROs (Magn and Susceptibility)
% 
% clc
% clearvars
% 
% segment_dir = 'C:\vnm\3T_RR05_VSHARP_Star_VSHARP-MEDI\Segmented_Geom\';
% input_segmentation_file = 'Segmentation_3T.nii.gz';
% 
% % load segmentated geometry
% segmented_geom = double(niftiread(strcat(segment_dir,input_segmentation_file)));
% 
% % reorient the geometry
% % Input the following orientation: X axes (RL), Y axes (AP), Z axes (IS)
% geom_swap_LR = rri_orient(make_nii(segmented_geom));
% % %% Swap axes X and Z
% % 
% geom_oriented = geom_swap_LR.img;
% % 
% 
% output_reorient_file = 'segmentation_3T_reorient.nii';
% niftiwrite(geom_oriented,strcat(segment_dir,output_reorient_file));

%%


clc
clearvars

usp = [0.0125:(0.0125/2):0.0375];
fer = [0.21:0.09:0.57];
cal = [10:10:50];

segment_dir = 'C:\vnm\3T_RR05_VSHARP_Star\Segmented_Geom\';
output_reorient_file = 'segmentation_3T_reorient.nii.gz';
geom_oriented = double(niftiread(strcat(segment_dir,output_reorient_file)));

GT_dir = 'C:\vnm\3T_RR05_VSHARP_Star\GT\';
chi_file = 'DRO_Susceptibility_GT_3T.nii.gz';
N = size(geom_oriented);
chi = zeros(N);

chi(geom_oriented==00) = 0; % Vial wall
chi(geom_oriented==01) = 0; % Bulk medium
chi(geom_oriented==23) = 0; % Corners of image space
chi(geom_oriented==24) = 0; % Phantom wall
chi(geom_oriented==02) = 0; % Air (ignore since the wall is thick)


for i = 1:5
chi(geom_oriented==[i+2]) = 31.2*usp(i) + 0.3; 
end

for i = 1:5
chi(geom_oriented==[i+7]) = 1.88*fer(i) + 0.1;
end

for i = 1:5
chi(geom_oriented==[i+12]) = -0.03*cal(i) - 0.0;
end

for i = 1:5
chi(geom_oriented==[i+17]) = -0.01*cal(i) + 0.3;
end

chi = make_nii(chi);
save_nii(chi,strcat(GT_dir,chi_file));


%% DRO Magnitude Signal GT values

clc
clearvars

usp = [0.0125:(0.0125/2):0.0375];
fer = [0.21:0.09:0.57];
cal = [10:10:50];
% Model the materials with monoexponential decay. 
segment_dir = 'C:\vnm\3T_RR05_VSHARP_Star\Segmented_Geom\';
segment_file = 'segmentation_3T_reorient.nii.gz';
geom = niftiread(strcat(segment_dir,segment_file));
geom_trunc = geom(:,:,:);
N = size(geom_trunc);
magn = zeros([N]);
magn_use = zeros([N 9]);
te = [1.87:1.87:22.44]/1000; % secs
working_dir = 'C:\vnm\3T_RR05_VSHARP_Star\3T_Simulated_Recon\';
mask = double(niftiread(strcat(working_dir,"mask.nii")));
output_magn_file = 'DRO_Magn_use_3T.nii.gz';


for i = 1:12
    magn(geom_trunc==00) = 0.5; % SNR_vial_wall = 0.5/0.01 = 50
    magn(geom_trunc==01) = 1; % SNR_bulk = 1/0.01 = 100
    magn(geom_trunc==02) = 0.001; % % SNR_air =~ 0
    magn(geom_trunc==24) = 0.001; % SNR_Corners =~ 0
    magn(geom_trunc==23) = 0.001; % SNR_wall =~ 0

    for j = 1:5
    magn(geom_trunc==[2+j]) = exp(-te(i)*(1250*usp(j)+16));
    end

    for j = 1:5
    magn(geom_trunc==[7+j]) = exp(-te(i)*(16.3*fer(j)+11));
    end
    
    for j = 1:5
    magn(geom_trunc==[12+j]) = exp(-te(i)*(0.1*cal(j)+8));
    end

    for j = 1:5
    magn(geom_trunc==[17+j]) = exp(-te(i)*(3.2*cal(j)+21));
    end

    magn_use(:,:,:,i) = magn;
end

% magn_rep = repmat(magn_cat,[1 1 210 1]);
magn_use = magn_use .* mask;
magn_use = make_nii(magn_use);
save_nii(magn_use,strcat(working_dir,output_magn_file));


%% DRO Phase simulation
clc
clearvars

input_dir = 'C:\vnm\3T_RR05_VSHARP_Star\GT\';
working_dir = 'C:\vnm\3T_RR05_VSHARP_Star\3T_Simulated_Recon\';
magn_suffix = 'DRO_Magn_use_3T.nii.gz';
magn = double(niftiread(strcat(working_dir,magn_suffix)));
mask = double(niftiread(strcat(working_dir,"mask.nii")));
fm_freq = double(niftiread(strcat(input_dir,'DRO_fm_freq_3T.nii.gz'))); % % Continuous_dipole_kernel.py (Ref: Salomir, Bowtell and Marques (2003))
N = size(fm_freq);

phs_prefix = 'DRO_Phs_use_3T.nii.gz';

B0 = 2.893;
gyro = 2*pi*42.58;
te = [1.87:1.87:22.44]/1000; % secs
phs_cat = zeros(size(magn));
fm_ph = fm_freq .* gyro .* B0; % Convert from frequency to phase
Sigma = 0.01; % Amplitude of synthetic noise
% Sigma = 0;

phs_noise = zeros(210,210,210,12);
magn_noise = zeros(210,210,210,12);
for i = 1:12

signal = magn(:,:,:,i).*exp(1j.*(fm_ph.*te(i)))+Sigma.*(randn(N)+1j.*randn(N)); %% convert to complex signal, apply synthetic noise
phs_noise(:,:,:,i) = angle(signal); %% converting from complex signal to raw phase
magn_noise(:,:,:,i) = abs(signal);

end

phs_use = phs_noise .* mask;
phs_use = make_nii(phs_use);
save_nii(phs_use,strcat(working_dir,phs_prefix));
