%% Wrapper_StatisticalAnalysis(path_to_data,param)

param = 'L1L2';
ext = '_14mm_Eddy_RR05';
path_to = 'C:\Users\rosly\Documents\QSM_PH\Analysis\';
path_to_data = strcat(path_to, param, ext, '\'); 
eval(strcat('cd',32,path_to_data));

[Data] = DataRead(param);
[DataTRR] = ExtractPairsforTRR(Data);
[DataLDR] = ExtractPairsforLDR(Data);
[DataFSR] = ExtractPairsforFSR(Data);
[TRR_ICC, LDR_ICC, FSR_ICC] = Wrapper_ICC(DataTRR, DataLDR, DataFSR);
writeICCtoExcel(TRR_ICC, LDR_ICC, FSR_ICC, strcat(param, ext));
[Bias] = QSM_Accuracy(DataFSR);
writeBiastoExcel(Bias, strcat(param, ext));