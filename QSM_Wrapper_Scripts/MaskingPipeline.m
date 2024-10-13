function [hdr] = MaskingPipeline(hdr)
% Argin 1: String variable of dataset
% Argin 2: "hdr" structure, used to parse variables
% Argout: "hdr" structure, variables parsed

FS = hdr.FS;
R2s = hdr.R2s;
iMag = hdr.iMag;
MagnFinalTE = hdr.MagnFinalTE;
voxel_size = hdr.voxel_size;
matrix_size = hdr.matrix_size;

%% Generate "Mask_Use" for all steps up to BFC
if (hdr.isBFC ~= true) && (hdr.isMEDI0 ~= true)
    %% Step 1a: BET Mask
    fractional_threshold= 0.3;
    gradient_threshold  = 0.2;

    % if contains(hdr.dataset, "9mth")
    %     iMag = MagnFinalTE;
    % end
    BETMask             = BET(iMag, matrix_size, voxel_size, ...
        fractional_threshold, gradient_threshold);
    mosaic( BETMask, 12, 12, 1, 'BetMask' )
    
    if hdr.refine_using_r2s == true
        %% Step 1b: Refine mask using r2s
        Mask_Use = refine_brain_mask_using_r2s(R2s, BETMask, voxel_size, 6, 6);
        Mask_Use = Mask_Use .* BETMask;
        mosaic( Mask_Use, 12, 12, 2, 'mask\_r2s\_morph' )
    else
        Mask_Use = BETMask;
    end
    
    %% Step 1c: Filling in holes
    for i=size(iMag,3) :-1 :1
        Mask_Use(:, :, i) = imfill(Mask_Use(:, :, i),'holes');
    end
    mosaic( Mask_Use, 12, 12, 3, 'Mask\_Use' )

    % Save Mask_Use in a struct for later use.
    hdr.Mask_Use = Mask_Use;
end

%% Step 2: Erosion of 4 mm after RESHARP
if hdr.isBFC == true
    radius          = 4;
    QSMMask         = SMV(hdr.Mask_Use, matrix_size, voxel_size, radius)>0.999;
    QSMMask         = double(QSMMask .* hdr.Mask_Use);
    if hdr.RelativeResidualMasking == true
        relativeResidualMask = hdr.relativeResidualMask;
        QSMMask              = double(relativeResidualMask .* QSMMask);
    end
    mosaic( QSMMask, 12, 12, 20, 'QSMMask' )
    export_nii(QSMMask, fullfile(hdr.output_dir, strcat(hdr.dataset, '_QSMMask')))
    hdr.QSMMask = QSMMask;
end

%% Step 3: Automatic cerebrospinal fluid mask "CSFMask"
if hdr.isMEDI0 == true
    QSMMask = hdr.QSMMask;
    % Mask_Use = hdr.Mask_Use;
    if FS == 7
        % CSFMask = refine_brain_mask_using_r2s(R2s, Mask_Use, voxel_size);
        % CSFMask = extract_CSF(R2s, Mask_Use, voxel_size);
        CSFMask = R2s < 5;
    elseif FS == 3
        magThreshold = 40; % percentage
        CSFMask = MagnFinalTE > ( magThreshold / 100 * max( MagnFinalTE ) );
    end
    %% : Erode the mask by a 10mm sphere
    erodeRadius = 14; % mm
    % SE = strel('sphere', erodeRadius);
    % CSFMask = imerode(CSFMask, SE);
    CSFMask = SMV(CSFMask, matrix_size, voxel_size, erodeRadius)>0.999;    
    CSFMask = double(CSFMask .* QSMMask);
    mosaic( CSFMask, 12, 12, 21, 'CSF Mask' )
    export_nii(CSFMask, fullfile(hdr.output_dir, strcat(hdr.dataset, '_CSFMask')))
    hdr.CSFMask = CSFMask;
end

end