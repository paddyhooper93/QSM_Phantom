%% Voxel_Exclusion_RR05_Method.m
% SEPIA Toolbox
% Mask used for dipole inversion

% load params
load 3T_header.mat
fieldMap = double(niftiread("unwrapped.nii"));
totalField = double(niftiread("B0.nii"));
magn = double(niftiread("3T_magn.nii.gz"));
exclude_threshold = 0.5;

r2s                 = R2star_trapezoidal(magn,TE);
relativeResidual    = ComputeResidualGivenR2sFieldmap(TE,r2s,totalField,magn.*exp(1i*fieldMap));
maskReliable        = relativeResidual < exclude_threshold;

maskReliable_nii = make_nii(double(maskReliable));
save_nii(maskReliable_nii,'3T_RR05_mask_reliable.nii.gz');