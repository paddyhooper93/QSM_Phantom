%% Wrapper_QSM_Main

%% clear cmd window, wkspace, figures window
clc
clear
close all

%% Set directory for data input
path_to_data = 'C:\Users\rosly\Documents\QSM_PH\Data\Input\';
eval(strcat('cd', 32, path_to_data));

%% Set and write directory for processing & output
hdr = struct();
hdr.output_dir = 'C:\Users\rosly\Documents\QSM_PH\Analysis\L1L2_14mm_Eddy_RR05_Idpt\tmp\';
if 7~=exist(hdr.output_dir, 'dir')
    eval(strcat('mkdir', 32, hdr.output_dir));
end

%% Loop through QSM_Main
% i = {'7T_BL', '7T_BL_Rep', '7T_9mth', '7T_24mth', '7T_24mth_Rep', ...
%     'TE1to3_9mth', 'TE1to3_24mth', 'TE1to3_24mth_Rep'};
% '7T_24mth', '7T_24mth_Rep','7T_BL',  '7T_BL_Rep', 
% '7T_BL', '7T_BL_Rep', 
i =  {'7T_9mth', '7T_24mth', '7T_24mth_Rep', '7T_BL', '7T_BL_Rep', ...
    '3T_BL', '3T_BL_Rep', '3T_9mth', '3T_24mth', '3T_24mth_Rep'};
for dataset = i
    for j = 1:3
        hdr.j = j;
        QSM_Main(dataset{1}, hdr);
        fprintf('Processed Quad %d \n', j);
    end
    fprintf('Processed Dataset %s \n', dataset{1});
end
%%
i = {'TE1to3_9mth', 'TE1to3_24mth', 'TE1to3_24mth_Rep', ...
    'TE1to7_9mth', 'TE1to7_24mth', 'TE1to7_24mth_Rep' };


for dataset = i
    hdr.j = 4;
    QSM_Main(dataset{1}, hdr);
    fprintf('Processed Quad %d \n', j);
    fprintf('Processed Dataset %s \n', dataset{1});
end

% i = {'3T_BL', '3T_BL_Rep', '3T_9mth', '3T_24mth', '3T_24mth_Rep', ...
%    'TE1to7_9mth', 'TE1to7_24mth', 'TE1to7_24mth_Rep', ...
% i = {'3T_Prelim', '7T_Prelim'};

%% Combine together into a single volume.

hdr.input_dir = 'C:\Users\rosly\Documents\QSM_PH\Analysis\L1L2_14mm_Eddy_RR05_Idpt\tmp\';
eval(strcat('cd', 32, hdr.input_dir));

output_dir = 'C:\Users\rosly\Documents\QSM_PH\Analysis\L1L2_14mm_Eddy_RR05_Idpt\';
if 7~=exist(output_dir, 'dir')
    eval(strcat('mkdir', 32, output_dir));
end

i = {'3T_BL', '3T_BL_Rep', '3T_9mth', '3T_24mth', '3T_24mth_Rep', ...
    '7T_BL', '7T_BL_Rep', '7T_9mth', '7T_24mth', '7T_24mth_Rep'};

for dataset = i
    [CombinedVol] = CombineIdptProcessedVols(dataset{1}, hdr);
    CombinedFn = fullfile(output_dir, strcat(dataset{1}, '_L1L2'));
    export_nii(CombinedVol, CombinedFn);
end