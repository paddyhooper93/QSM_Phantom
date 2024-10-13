function [Magn, Phs] = ProcessQuadIdpt(dataset, Magn, Phs, hdr)
% hdr.j is parsed externally as a for loop.

if ~isfield(hdr, 'j')
    return
elseif hdr.j == 1
    [Magn, Phs] = ProcessQuad1Idpt(dataset, Magn, Phs);
elseif hdr.j == 2
    [Magn, Phs] = ProcessQuad2Idpt(dataset, Magn, Phs);
elseif hdr.j == 3
    [Magn, Phs] = ProcessQuad3Idpt(dataset, Magn, Phs);
elseif hdr.j == 4
    [Magn, Phs] = ProcessQuad4Idpt(dataset, Magn, Phs);
end

end