function [hdr] = InitializeVar(dataset, hdr)

load(dataset, "Magn", "Phs", "R2s");

matrix_size         = size(Magn, [1,2,3]);
Phs(isnan(Phs))=0;
Phs(isinf(Phs))=0;
Phs = DICOM2Radians(Phs);
R2s(isinf(R2s))=0;
R2s(isnan(R2s))=0;

if contains(dataset, "3T") || contains(dataset, "TE1to7")
    FS = 3;
elseif contains(dataset, "7T") || contains(dataset, "TE1to3")
    FS = 7;
end

if isfield(hdr, 'j')
    [Magn, Phs] = ProcessQuadIdpt(dataset, Magn, Phs, hdr);
end


%% Exclude early slices, and setup restricted TE datasets (if appslicable)

if FS == 3
    TE                  = (1.87:1.87:12*1.87)./1000;
    voxel_size          = [1 1 1];
    
    if hdr.excludeDistal
        z_full = 1:matrix_size(3);
        z_keep = 21:94;
        Phs(:, :, setdiff(z_full, z_keep), :) = 0;
        Magn(:, :, setdiff(z_full, z_keep), :) = 0;
    end
    
    if contains(dataset, "TE1to7")
        str                 = strcat('3T_', dataset(8:end), '.mat');
        load(str,"Magn","R2s");
        if hdr.excludeDistal
            z_full = 1:matrix_size(3);
            z_keep = 21:94;
            Magn(:, :, setdiff(z_full, z_keep), :) = 0;
        end
        iMag                = sqrt(sum(abs(Magn).^2,4));
        MagnFinalTE         = Magn(:,:,:,end);
        TE                  = TE(1:7);
        Magn                = Magn(:,:,:,1:7);
    else
        iMag                = sqrt(sum(abs(Magn).^2,4));
        MagnFinalTE         = Magn(:,:,:,end);
    end
    
elseif FS == 7
    TE                  = (3.15:3.15:9*3.15)./1000;
    voxel_size          = [0.7 0.7 0.7];
    if hdr.excludeDistal
        z_full = 1:matrix_size(3);
        z_keep = 41:150;
        Phs(:, :, setdiff(z_full, z_keep), :) = 0;
        Magn(:, :, setdiff(z_full, z_keep), :) = 0;
    end

    if matches(dataset, "7T_9mth")
        % reducing later echoes seems to help with air-affected
        % acquisitions
        TE = TE(1:5);
        Magn = Magn(:,:,:,1:5);
        Phs = Phs(:,:,:,1:5);
    end
    
    if contains(dataset, "TE1to3")
        % Calculate R2s and iMag using un-restricted TEs -> for better masking.
        str                 = strcat('7T_', dataset(8:end), '.mat');
        load(str,"Magn","R2s");
        [Magn, ~] = ProcessQuadIdpt(dataset, Magn, Phs, hdr);
        if hdr.excludeDistal
            z_full = 1:size(Magn, 3);
            z_keep = 41:150;
            Magn(:, :, setdiff(z_full, z_keep), :) = 0;
        end
        iMag                = sqrt(sum(abs(Magn).^2,4));
        MagnFinalTE         = Magn(:,:,:,end);
        TE                  = TE(1:3);
        Magn                = Magn(:,:,:,1:3);
    else
        iMag                = sqrt(sum(abs(Magn).^2,4));
        MagnFinalTE         = Magn(:,:,:,end);
    end
end

% Package outputs into a struct
hdr.Magn = Magn;
hdr.Phs = Phs;
hdr.R2s = R2s;
hdr.MagnFinalTE = MagnFinalTE;
hdr.TE = TE;
hdr.iMag = iMag;
hdr.voxel_size = voxel_size;
hdr.matrix_size = matrix_size;
hdr.FS = FS;
hdr.isBFC = false; % Stops processing the same thing twice
hdr.isMEDI0 = false; % Stops processing the same thing twice
hdr.dataset = dataset;

end