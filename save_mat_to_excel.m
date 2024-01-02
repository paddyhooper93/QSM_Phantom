data=load('workspace.mat');
A = struct2cell(data);
B = fieldnames(data);
C = [A, B];
writecell(C, 'PhantomData_ROI_Mean.xlsx', 'Sheet', 1, 'Range', 'A1')