function [DataFSR] = ExtractPairsforFSR(Data)

fields = fieldnames(Data);

for i = 1:length(fields)
    varName = fields{i};
    varValue = Data.(varName);
        if contains(varName, ("USP" | "FER"))
            tmp00 = varValue(:,[1,2]);
            tmp09 = varValue(:,3);
            tmp24 = varValue(:,[4 5]);      
            tmp = cat(2, tmp00, tmp09, tmp24);
            tmp = mean(tmp,2);
            TempStruct.(varName) = tmp; % in units ppm           
            if contains(varName, ("USP_3T"))
                TempStruct.(varName) = (tmp.*2.893); 
            elseif contains(varName, ("USP_7T"))
                TempStruct.(varName) = (tmp.*7);
            else
            TempStruct.(varName) = tmp; % in units ppm      
            end
        elseif contains(varName, "CHL")
            tmp00 = varValue(:,[1 2]);
            tmp09 = varValue(:,3);
            tmp = cat(2, tmp00, tmp09);
            tmp = mean(tmp,2);
            TempStruct.(varName) = tmp;      
        elseif contains(varName, "CRB")
            tmp09 = varValue(:,3);
            tmp24 = varValue(:,[2 3]);
            tmp = cat(2, tmp09, tmp24);
            tmp = mean(tmp,2);            
            TempStruct.(varName) = tmp;      
        end
end
clear fields varName varValue
% Initialize an empty structure to hold the empty fields 
DataFSR = struct();
% Get all field names of the structure
fieldNames = fieldnames(TempStruct);
% Loop over the field names
for i = 1:length(fieldNames)
    for j = i+1:length(fieldNames)
        % Compare first three characters of the field names
        if strncmp(fieldNames{i}, fieldNames{j}, 3)
            % Concatenate arrays and store in the new structure
            DataFSR.(fieldNames{i}(1:3)) = ...
                [TempStruct.(fieldNames{i}), TempStruct.(fieldNames{j})];
        end
    end
end


end