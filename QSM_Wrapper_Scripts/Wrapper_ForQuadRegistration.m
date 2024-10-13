% Wrapper_ForQuadRegistration.m

input_dir = 'C:\Users\rosly\Documents\QSM_PH\Data\NC\';

i = {'3T_BL', '3T_BL_Rep'}; 

for dataset = i
    Phs_fn = fullfile(input_dir, strcat(dataset{1},'_Phs.nii.gz'));
    Phs_nii = load_untouch_nii(Phs_fn);
    Phs = Phs_nii.img;
    Phs(isnan(Phs))=0;
    Phs(isinf(Phs))=0;
    export_nii(Phs, Phs_fn)
    mat_fn = fullfile(input_dir, strcat(dataset{1},'.mat'));
    save(mat_fn, "Phs", '-append')
end



%%

dir = 'C:\Users\rosly\Documents\QSM_PH\Data\NIfTIs_Quad\';

output_dir = 'C:\Users\rosly\Documents\QSM_PH\Data\Input\';

i =      {'7T_9mth', '7T_BL', '7T_BL_Rep', 'TE1to3_9mth', '7T_24mth',  ...   
          '7T_24mth_Rep', 'TE1to3_24mth', 'TE1to3_24mth_Rep', ...
          '3T_BL', '3T_BL_Rep', '3T_9mth', '3T_24mth', '3T_24mth_Rep', ... 
          'TE1to7_9mth', 'TE1to7_24mth', 'TE1to7_24mth_Rep'};

for dataset = i
    str = dataset{1};
    Phs_fn = fullfile(dir, strcat(str,'_Phs_Quad.nii.gz'));
    Phs_nii = load_untouch_nii(Phs_fn);
    Phs = Phs_nii.img;
    mat_fn = fullfile(output_dir, strcat(str,'.mat'));
    save(mat_fn, "Phs", '-append')
end


%%
path_to_data = 'C:\Users\rosly\Documents\QSM_PH\Data\NIfTIs_Quad\';
eval(strcat('cd', 32, path_to_data));

output_dir = 'C:\Users\rosly\Documents\QSM_PH\Data\Input\';

i =    {'3T_24mth', '3T_24mth_Rep'};

for dataset = i
    Phs_fn = append(dataset{1}, '_Phs_Quad.nii.gz');
    Phs_nii = load_untouch_nii(Phs_fn);
    Phs = Phs_nii.img;
    Magn_fn = append(dataset{1}, '_Magn_Quad.nii.gz');
    Magn_nii = load_untouch_nii(Magn_fn);
    Magn = Magn_nii.img;
    str = fullfile(output_dir, append(dataset{1}, '.mat'));
    save(str,'Phs','-append');
end


%%
% '7T_BL', '7T_BL_Rep', '7T_9mth', 'TE1to3_9mth',


for dataset = i
    Phs_fn = strcat(dataset{1}, '_Phs_Quad.nii.gz');
    Phs_nii = load_untouch_nii(Phs_fn);
    Phs = Phs_nii.img;
    Magn_fn = strcat(dataset{1}, '_Magn_Quad.nii.gz');
    Magn_nii = load_untouch_nii(Magn_fn);
    Magn = Magn_nii.img;
    str = fullfile(output_dir, append(dataset{1}, '.mat'));
    save(str,"Phs")
end


% for dataset = i
%     Phs_nii = load_untouch_nii(strcat(dataset{1},'_Phs_Quad.nii.gz'));
%     Phs = Phs_nii.img;
%     Magn_nii = load_untouch_nii(strcat(dataset{1},'_Magn_Quad.nii.gz'));
%     Magn = Magn_nii.img;
%     save(fullfile(hdr.output_dir, dataset{1}), "Magn", "Phs", '-mat');
% end