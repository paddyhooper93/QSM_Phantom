function [iFreq_uw] = UnwrapSingleEcho(Magn, iFreq_raw, TE, Mask, ...
    voxel_size, path)

    parameters.output_dir = fullfile(path, 'NLF_romeo_tmp');
    parameters.TE = false;
    parameters.mag = Magn(:,:,:,1);
    parameters.mask = Mask;
    parameters.no_unwrapped_output = false;
    parameters.calculate_B0 = false;
    parameters.phase_offset_correction = 'off';
    parameters.voxel_size = voxel_size;

    mkdir(parameters.output_dir);
    [iFreq_uw, ~] = ROMEO(iFreq_raw, parameters);
    rmdir(parameters.output_dir, 's')

end

