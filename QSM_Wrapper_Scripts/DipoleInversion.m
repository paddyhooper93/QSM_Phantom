function DipoleInversion(iFreq, weights, RDF, hdr)

% Initialize vars
QSMMask = hdr.QSMMask;
CSFMask = hdr.CSFMask;
output_dir = hdr.output_dir;
dataset = hdr.dataset;

if (matches(hdr.DplInv_Method, 'MEDI0')) || (matches(hdr.DplInv_Method, 'ALL'))
    %% Execute "MEDI+0"
    isSMV = 0;
    QSM  = MEDIL1_Wrapper(iFreq, RDF, ...
        weights, QSMMask, CSFMask, isSMV, hdr);
        
    if ~isfield(hdr, 'j')
        export_nii(QSM, strcat(output_dir, dataset, '_L1L2'));
    elseif hdr.j == 1
        export_nii(QSM, strcat(output_dir, dataset, '_quad1_L1L2'));
    elseif hdr.j == 2
        export_nii(QSM, strcat(output_dir, dataset, '_quad2_L1L2'));
    elseif hdr.j == 3
        export_nii(QSM, strcat(output_dir, dataset, '_quad3_L1L2'));
    elseif hdr.j == 4
        export_nii(QSM, strcat(output_dir, dataset, '_quad4_L1L2'));       
    end
    mosaic( QSM, 12, 12, 13, '"MEDI0" QSM-map', [-0.5 0.5] )
    
elseif (matches(hdr.DplInv_Method, 'MEDI')) || (matches(hdr.DplInv_Method, 'ALL'))
    
    %% Execute "MEDI"
    isSMV = 0;
    CSFMask             = [];
    QSM  = MEDIL1_Wrapper(iFreq, RDF, ...
        weights, QSMMask, CSFMask, isSMV, hdr);
    export_nii(QSM, strcat(output_dir, dataset, '_L1'));
    mosaic( QSM, 12, 12, 14, '"MEDI" QSM-map', [-0.5 0.5] )
    
elseif matches(hdr.DplInv_Method, 'MEDI-SMV')
    
    %% Execute "MEDI-SMV" (Works well in low susceptibility datasets manifesting granular noise i.e., CaCO3)
    isSMV = 1;
    CSFMask             = [];
    QSM  = MEDIL1_Wrapper(iFreq, RDF, ...
        weights, QSMMask, CSFMask, isSMV, hdr);
    export_nii(QSM, strcat(output_dir, dataset, '_L1SMV'));
    mosaic( QSM, 12, 12, 15, 'MEDI-SMV QSM-map', [-0.3 0.1] )
    
end

end