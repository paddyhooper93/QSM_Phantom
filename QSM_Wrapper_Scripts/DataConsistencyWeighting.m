function [weights, hdr] = DataConsistencyWeighting(iFreq, hdr)

Magn = hdr.Magn;
TE = hdr.TE;
Mask_Use = hdr.Mask_Use;
dataset = hdr.dataset;

    function TE_4D = match_dims(TE_1D, vol_4D)
        vol_size = size(vol_4D);
        TEs_reshaped = reshape(TE_1D, [1 1 1 length(TE_1D)]);
        TE_4D = repmat(TEs_reshaped, [vol_size(1) vol_size(2) vol_size(3) 1]);
    end

if contains(dataset, "TE1to3") || contains(dataset, "TE1to7")
    TE_4D               = match_dims(TE, Magn);
    fieldMapSD          = sqrt(sum(Magn .* Magn .* (TE_4D .* TE_4D), 4));
else
    fieldMapSD = hdr.fieldMapSD;
end

weights             = sepia_utils_compute_weights_v1(fieldMapSD, Mask_Use);
%mosaic( weights, 12, 12, 10, 'SEPIA weights', [0 1] )

Phs = hdr.Phs;
R2s = hdr.R2s;

relativeResidualMap = ComputeResidualGivenR2sFieldmap(TE, R2s, ...
    iFreq, Magn.*exp(1i*Phs));
exclude_threshold = 0.5;

% Save relativeResidualMask in a struct for later use.
hdr.relativeResidualMask = relativeResidualMap < exclude_threshold;

if hdr.RelativeResidualWeighting == true
    relativeResidualWeights = relativeResidualMap;
    relativeResidualWeights(relativeResidualWeights>exclude_threshold) = exclude_threshold;
    relativeResidualWeights = (exclude_threshold - relativeResidualWeights) ./ exclude_threshold;
    mosaic( relativeResidualWeights, 12, 12, 2, 'Relative residual weights' )
    weights = weights .* relativeResidualWeights;
end

mosaic( weights, 12, 12, 11, 'Data consistency weighting map', [0 1] )

end