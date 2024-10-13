%% Wrapper_CombineProcessedVols

param = 'L1L2';
ext = '_14mm_SDC_Data';
path_to = 'C:\Users\rosly\Documents\QSM_PH\Analysis\';
path_to_data = strcat(path_to, param, ext); %,'_Data\'
eval(strcat('cd',32,path_to_data));

i = {'3T_9mth', '3T_24mth', '3T_24mth_Rep', '7T_9mth_SDC', '7T_24mth_SDC', '7T_24mth_Rep_SDC'};

for dataset = i
    [Combined] = CombineProcessedVols(dataset{1}, param);
    CombinedFn = strcat(dataset{1}, '_', param, '_QuadCombined');
    export_nii(Combined, CombinedFn);
end