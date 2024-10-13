function [hdr] = CreateHeader(hdr)

hdr.refine_using_r2s = false;
hdr.RefineMethod = 'PolyFit'; % Useage: 'PolyFit' | 'Shim'
hdr.fieldMap_Method = 'NLF'; % Useage: 'NLF'|'ROMEO'. NLF field mapping produces most robust field maps (reduces slice-by-slice heterogeneity at 7T).
% If unwrapping errors occur, use 'ROMEO' ROMEO 1st-echo template unwrapping followed by ROMEO field map computation.
hdr.excludeDistal = true; % Do not adjust. More consistent masking.
hdr.RelativeResidualWeighting = false;
hdr.RelativeResidualMasking = true;

hdr.InfCyl = true; % Saves susceptibility map calculated by (prl) infinite cylinder model
hdr.DplInv_Method = 'MEDI0'; % Useage: 'MEDI' | 'MEDI0' | 'MEDI-SMV' | 'ALL' (MEDI, MEDI0)

end