function [CombinedVol] = CombineIdptProcessedVols(dataset, hdr)
% Same prefix information, i.e., data from the same acquisition, analysed with partial TEs and full TEs.

param = {'quad1', 'quad2', 'quad3', 'quad4'};
input_dir = hdr.input_dir;

if contains(dataset, "3T" )
    FullPrefix = dataset;
    PartialPrefix = fullfile( input_dir, strcat('TE1to7_', dataset(4:end)) );
elseif contains(dataset, "7T")
    FullPrefix = dataset;
    PartialPrefix = fullfile( input_dir, strcat('TE1to3_', dataset(4:end)) );
end

suffix = '_L1L2.nii.gz';

%% Quad 1
Quad1_fn = strcat(FullPrefix, '_', param{1}, suffix);
Quad1_nii = load_nii(Quad1_fn);
Quad1 = Quad1_nii.img;

if contains(dataset, "3T")
    x_range = 1:96;
    y_range = 1:96;
elseif contains(dataset, "7T")
    x_range = 1:119;
    y_range = 1:136;
end
[Quad1] = zero_out_complement(x_range, y_range, Quad1);

%% Quad 2
Quad2_fn = strcat(FullPrefix, '_', param{2}, suffix);
Quad2_nii = load_nii(Quad2_fn);
Quad2 = Quad2_nii.img;

if contains(dataset, "3T")
    x_range = 1:96;
    y_range = 97:192;
elseif contains(dataset, "7T")
    x_range = 1:119;
    y_range = 137:272;
end
[Quad2] = zero_out_complement(x_range, y_range, Quad2);

%% Quad 3

Quad3_fn = strcat(FullPrefix, '_', param{3}, suffix);
Quad3_nii = load_nii(Quad3_fn);
Quad3 = Quad3_nii.img;

if contains(dataset, "3T")
    x_range = 97:192;
    y_range = 1:96;
elseif contains(dataset, "7T")
    x_range = 120:238;
    y_range = 1:136;
end
[Quad3] = zero_out_complement(x_range, y_range, Quad3);

%% Quad 4

if contains(dataset, "3T")
    x_range = 97:192;
    y_range = 97:192;
elseif contains(dataset, "7T")
    x_range = 120:238;
    y_range = 137:272;
end
if ~contains(dataset, "BL")
    Quad4_fn = strcat(PartialPrefix, '_', param{4}, suffix);
    Quad4_nii = load_nii(Quad4_fn);
    Quad4 = Quad4_nii.img;
    [Quad4] = zero_out_complement(x_range, y_range, Quad4);
else
    Quad4 = single(zeros(size(Quad1)));
end


%% Add them together. They should line up in equal volume quadrants
CombinedVol = Quad1 + Quad2 + Quad3 + Quad4;

end