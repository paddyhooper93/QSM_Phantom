function [Magn, Phs] = ProcessQuad3Idpt(dataset, Magn, Phs)
if contains(dataset, "3T") || contains(dataset, "TE1to7")
    % Specify regions to keep
    x_keep = 93:192;
    y_keep = 1:100;
elseif contains(dataset, "7T") || contains(dataset, "TE1to3")
    % (length(dimx) = 128, length(dimy) = 142)
    x_keep = 111:238;
    y_keep = 1:142;
end

[Magn, Phs] = zero_out_complement(x_keep, y_keep, Magn, Phs);
end