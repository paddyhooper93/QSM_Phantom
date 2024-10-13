function [Data] = DataRead(param)

DataRead1 = readtable(strcat('3T_',param,'.csv'),"VariableNamingRule","preserve"); 
Data.USP_3T = cat(2, DataRead1{2:6, 5:2:9}, flip(DataRead1{12:16, 11:2:13}, 1)) ;
Data.FER_3T = cat(2, DataRead1{7:11, 5:2:9}, flip(DataRead1{2:6, 11:2:13}, 1)) ;
Data.CHL_3T = DataRead1{12:16, 5:2:9} ;
% DataRead2 = readtable(strcat('TE1to7_',param, ext,'.csv'),"VariableNamingRule","preserve"); 
Data.CRB_3T = DataRead1{17:21, 9:2:13};
Data.CRB_3T([7 10]) = Data.CRB_3T([10 7]);
Data.CRB_3T([6 9]) = Data.CRB_3T([9 6]);
Data.CRB_3T([11 14]) = Data.CRB_3T([14 11]);
Data.CRB_3T([12 15]) = Data.CRB_3T([15 12]);
DataRead2 = readtable(strcat('7T_',param,'.csv'),"VariableNamingRule","preserve"); 
Data.USP_7T = cat(2, DataRead2{2:6, 5:2:9}, flip(DataRead2{12:16, 11:2:13}, 1)) ;
Data.FER_7T = cat(2, DataRead2{7:11, 5:2:9}, flip(DataRead2{2:6, 11:2:13}, 1)) ;
Data.CHL_7T = DataRead2{12:16, 5:2:9} ;
% DataRead4 = readtable(strcat('TE1to3_',param, ext,'.csv'),"VariableNamingRule","preserve"); 
Data.CRB_7T = DataRead2{17:21, 9:2:13};
Data.CRB_7T([7 10]) = Data.CRB_7T([10 7]);
Data.CRB_7T([6 9]) = Data.CRB_7T([9 6]);
Data.CRB_7T([11 14]) = Data.CRB_7T([14 11]);
Data.CRB_7T([12 15]) = Data.CRB_7T([15 12]);

% Note on 24mth time-point:
% ROIs were flipped for USP, FER and swapped for CRB.
% 2 ROIs (i.e., vials) were removed for CHL, 
% so we didn't analyse CHL for 24mth time-point.

end