# QSM_Phantom
CAD_Files: A computer-aided-drawing (CAD) of the phantom. 
--> Two assembly files are provided, the phantom itself, and its placement within the 7 Tesla Nova Medical head coil.
--> Input files are required for the assembly to work.

Data: CSV files of the ROIs from the QSM and R2star NIfTI files

NIfTIs: QSM and R2star NIfTI files at 3 T/7 T. 
--> The transformation matrices were provided using an R2star map as a reference. 
--> The ROIs were provided for each material and field strength.

QSM_Phantom_Production: 
--> Lab-Instructions.txt: Instructions for mixed agarose gel production.
--> Workshop-Instructions.txt: Instructions for phantom construction.

Repeatability_Scripts: 
--> QSM_Repeatability.m: Intra-session, inter-session repeatability of QSM measurements
--> R2star_Repeatability.m: Intra-session, inter-session repeatability of R2star measurements
--> At the end of each Matlab file, is also script for inter-scanner reproducibility measurements. Only use if p > 0.05 in Student's t-test.
--> Inter-scanner-reproducibility.xlsx: A student's t-test for QSM, Rstar comparing 3 T to 7 T.