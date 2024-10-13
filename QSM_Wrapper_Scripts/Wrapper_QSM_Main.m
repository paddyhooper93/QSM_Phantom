%% Wrapper_QSM_Main

%% clear cmd window, wkspace, figures window
clc
clear
close all

%% Set directory for data input
input_dir = 'C:\Users\rosly\Documents\QSM_PH\Data\NC\';
eval(strcat('cd', 32, input_dir));

%% Set and write directory for temp processing
hdr = struct();
hdr.output_dir = 'C:\Users\rosly\Documents\QSM_PH\Registration\Unregistered\L1L2_14mm_Eddy_RR05\tmp\';
if 7~=exist(hdr.output_dir, 'dir')
    eval(strcat('mkdir', 32, hdr.output_dir));
end

%% Loop through QSM_Main
i = {'7T_BL_Rep', '7T_BL', '7T_9mth', '7T_24mth_Rep', '7T_24mth', ...
    '3T_BL', '3T_BL_Rep', '3T_9mth', '3T_24mth', '3T_24mth_Rep'};
% Done =    {'7T_9mth', '7T_24mth_Rep', '7T_BL', '7T_BL_Rep', '7T_24mth',  ...   
%         'TE1to3_24mth', 'TE1to3_24mth_Rep', 'TE1to3_9mth', ...
%         '3T_BL', '3T_BL_Rep', '3T_9mth', '3T_24mth', '3T_24mth_Rep', ... 
%         'TE1to7_9mth', 'TE1to7_24mth', 'TE1to7_24mth_Rep'};
for dataset = i
    QSM_Main(dataset{1}, hdr);
    fprintf('Processed Dataset %s \n', dataset{1});
end

%% Apply Transformation matrix with linear regridding

unix("bash Run_antsApplyTransforms.sh")
%% Set up write directory for input and output

param = 'L1L2_Quad';
hdr.input_dir = 'C:\Users\rosly\Documents\QSM_PH\Analysis\L1L2_14mm_Eddy_RR05\tmp\';
output_dir = 'C:\Users\rosly\Documents\QSM_PH\Analysis\L1L2_14mm_Eddy_RR05\';

%% Combine processed volumes

i =    {'3T_BL', '3T_BL_Rep', '3T_9mth', '3T_24mth', '3T_24mth_Rep', ... 
        '7T_9mth', '7T_24mth_Rep', '7T_BL', '7T_BL_Rep', '7T_24mth'};
for dataset = i
    [CombinedVol] = CombineProcessedVols(dataset{1}, param, hdr);
    CombinedFn = fullfile(output_dir, strcat(dataset{1}, '_', param));
    export_nii(CombinedVol, CombinedFn);
end

% for dataset = i
%     Phs_nii = load_untouch_nii(strcat(dataset{1},'_Phs_Quad.nii.gz'));
%     Phs = Phs_nii.img;
%     Magn_nii = load_untouch_nii(strcat(dataset{1},'_Magn_Quad.nii.gz'));
%     Magn = Magn_nii.img;
%     save(fullfile(hdr.output_dir, dataset{1}), "Magn", "Phs", '-mat');
% end


%%

% ROIs_nii = load_untouch_nii('7T_ROIs.nii.gz');
% ROIs = double(ROIs_nii.img);
% 
% i = {'7T_9mth', '7T_BL', '7T_BL_Rep', 'TE1to3_9mth', '7T_24mth'};
% 
% for dataset = i
%     Vol_nii = load_untouch_nii(strcat(dataset{1},'_QSMMask.nii.gz'));
%     Vol = Vol_nii.img;
%     ROIs = ROIs .* Vol;
% end
% 
% export_nii(ROIs,'7T_ROIs_RR.nii.gz')

% TODO = {
% TODO = {}
% 
% i =    {'7T_9mth', '7T_24mth_Rep', '7T_BL', '7T_BL_Rep', 'TE1to3_9mth', '7T_24mth',  ...   
%         'TE1to3_24mth', 'TE1to3_24mth_Rep'};
% input_dir = 'C:\Users\rosly\Documents\QSM_PH\Data\NC\';
% 
% % Done = '3T_BL', '3T_BL_Rep', '3T_9mth', '3T_24mth', '3T_24mth_Rep' ... 
%         % 'TE1to7_9mth', 'TE1to7_24mth', 'TE1to7_24mth_Rep'
% for dataset = i
%     R2s_nii = load_untouch_nii(strcat(dataset{1}, '_SDC_R2s.nii.gz'));
%     R2s = R2s_nii.img;
%     save(fullfile(input_dir, dataset{1}), 'R2s', '-append');
% end



