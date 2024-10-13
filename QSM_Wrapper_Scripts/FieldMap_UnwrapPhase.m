function [iFreq, hdr] = FieldMap_UnwrapPhase(hdr)

Magn = hdr.Magn;
Phs = hdr.Phs;
TE = hdr.TE;
voxel_size = hdr.voxel_size;
Mask_Use = hdr.Mask_Use;
dataset = hdr.dataset;

% MCPC bipolar corrected phase (already done for all datasets)
mosaic( Phs(:,:,:,1), 12, 12, 5, 'Bipolar Corrected Phase (TE\_1)', [-pi pi] )
% SEPIA bipolar correction (doesn't work quite as well as MCPC)
% [imgCplx] = FastBipolarCorrect(Magn.*exp(1i*Phs), Mask_Use);
% Phs = double(angle(imgCplx));

% ROMEO field calculation
if contains(dataset, "TE1to3") || contains(dataset, "TE1to7") || matches(hdr.fieldMap_Method, 'ROMEO')
    [unwrapped] = UnwrapAllEchoes(Magn, Phs, TE, Mask_Use, ...
        voxel_size, hdr);
    [iFreq] = CalculateROMEOFieldMap(Magn, unwrapped, TE);
    iFreq = iFreq .* Mask_Use;
    mosaic( iFreq, 12, 12, 6, 'ROMEO Field map', [-300 300] )
    return
end



% MEDI Nonlinear Fitting
% N.B. iField_correction is incompatible with bipolar corrected phase.

[iField] = Magn.*exp(-1i*Phs);
[iFreq_raw, fieldMapSD] = Fit_ppm_complex(iField);
mosaic( iFreq_raw, 12, 12, 8, 'NLF Field map, not yet unwrapped', [-pi pi] )

Magn_TE1 = Magn(:,:,:,1) .* Mask_Use;
subsampling = 2;
iFreq = unwrapping_gc(iFreq_raw, Magn_TE1, voxel_size, subsampling);

% find the centre of mass
pos     = round(centerofmass(Magn(:,:,:,1)));
% use the centre of mass as reference phase
iFreq = iFreq-round(iFreq(pos(1),pos(2),pos(3))/(2*pi))*2*pi;

% convert from radians to Hz
delta_TE     = TE(2)-TE(1);
iFreq        = iFreq / (2*pi*delta_TE);
iFreq        = iFreq .* Mask_Use;

mosaic( iFreq, 12, 12, 9, 'NLF fieldmap', [-300 300] )

% Save fieldMapSD in a struct for later useage.
hdr.fieldMapSD = fieldMapSD;

end