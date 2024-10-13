function [Phs_rs] = DICOM2Radians(Phs)
    [min_phs, max_phs]  = bounds( Phs(:) , "all" );
    Phs_rs = 2*pi * ( Phs - min_phs ) / ( max_phs - min_phs ) - pi ;
end