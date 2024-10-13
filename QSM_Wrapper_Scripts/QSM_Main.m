function QSM_Main(dataset, hdr)
% 
%% Step 0: Initialize header opts
[hdr] = CreateHeader(hdr); % Adjust parameters here
[hdr] = InitializeVar(dataset, hdr);

%% Step 1: Generate BET Mask (Holes Filled In)
[hdr] = MaskingPipeline(hdr); 

%% Step 2: Unwrapping and Fieldmap calculation
[iFreq, hdr] = FieldMap_UnwrapPhase(hdr);
 
%% Step 3: Data fidelity/consistency weighting
[weights, hdr] = DataConsistencyWeighting(iFreq, hdr);

%% Step 4: Background field correction
hdr.isBFC = true; hdr.isMEDI0 = false;
[hdr] = MaskingPipeline(hdr); 
[RDF] = BackgroundFieldCorrection(iFreq, hdr);

%% Step 5: Dipole inversion
hdr.isBFC = false; hdr.isMEDI0 = true;
[hdr] = MaskingPipeline(hdr);
DipoleInversion(iFreq, weights, RDF, hdr);

end