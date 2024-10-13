function [RDF] = BackgroundFieldCorrection(iFreq, hdr)

% Load initial vars
matrix_size = hdr.matrix_size;
voxel_size = hdr.voxel_size;
FS = hdr.FS;
dataset = hdr.dataset;

output_dir = hdr.output_dir;
Mask_Use = hdr.Mask_Use;
QSMMask = hdr.QSMMask;

radius          = 4;
alpha           = 0.01;

RDF             = RESHARP(iFreq, Mask_Use, matrix_size, voxel_size, radius, alpha);

if matches(hdr.RefineMethod,'PolyFit')
    poly_order      = 4;
    [~, RDF, ~]     = PolyFit(double(RDF), QSMMask, poly_order);
elseif matches(hdr.RefineMethod,'Shim') 
    shim_order      = 2;   
    [~,RDF,~]       = spherical_harmonic_shimming(double(RDF),QSMMask,shim_order);
end

RDF = RDF .* double(QSMMask);
RDF(isinf(RDF))=0;
RDF(isnan(RDF))=0;

mosaic( RDF, 12, 12, 12, 'Local/Tissue Field (Hz)', [-50 50] )

if hdr.InfCyl == true
    Chi = CalculateChiMapfromLF(RDF, FS);
    export_nii(Chi, strcat(output_dir, dataset, '_InfCyl'));
end

end