%% Removeoutliers_fromHistogram.m
% Partitions a stacked histogram from a 3D VOI 
% generated from ImageJ into a set of raw voxel values.

%Removes outliers more than 3 scaled MAD from the median.
%The scaled MAD is defined as c*median(abs(A-median(A))), 
%where c=-1/(sqrt(2)*erfcinv(3/2)).

clc
clearvars

%name file suffix material, #1to5
file_suffix = "ferritin5";
example=csvread(strcat("Histogram_",file_suffix,".csv"),1,0);
% When using FIJI, you have to remove the first column
% example = example(:,2:3);

partitioned_value = zeros([256 1]);
bin_count = zeros([256 1]);
m = length(partitioned_value(:,1));

%% Partitioned values
for row = 1:m
    if example(row,2) == 0
            example(row) = 0;
    else
        for col = 1:example(row,2)
            partitioned_value = cat(1,partitioned_value,example(row,1));
        end
    end
end
partitioned_value = partitioned_value(row+1:end);
partitioned_value(partitioned_value==0) = [];

%% Bin count

for row = 1:m
    if example(row,2) == 0
            example(row) = 0;
    else
        for col = 1:example(row,2)
            bin_count = cat(1,bin_count,example(row,2));
        end
    end
end
bin_count = bin_count(row+1:end);
bin_count(bin_count==0) = [];

%% Combine partitioned value and bin count

example = [partitioned_value bin_count];

%% Combine into single file

new_matrix = zeros([length(partitioned_value) 1]);

for row = 1:length(partitioned_value)
% Loop through each partitioned value 'bin_count' times
    for col = 1:bin_count(row)
        new_matrix = cat(1,new_matrix,partitioned_value(row,1));
    end
end

% Remove extra 256 zeros during initialization
new_matrix = new_matrix(row+1:end);
new_matrix(new_matrix==0)=[];

B = rmoutliers(new_matrix);
B_m = mean(B);
B_sd = std(B);

if size(example) == size(new_matrix)
    disp( 'no outliers' )
else
    disp([ strcat('outlier exist, enter new mean ',{' '}, num2str(B_m), ' and standard deviation',{' '}, num2str(B_sd)) ])
end
    
% csvwrite(strcat("raw_",file_suffix,".csv"),new_matrix);


