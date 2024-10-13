function [DataLDR] = ExtractPairsforLDR(Data)

fields = fieldnames(Data);

for i = 1:length(fields)
    varName = fields{i};
    varValue = Data.(varName);
        if contains(varName, ("USP"|"FER"))
            tmp00 = varValue(:,[1,2]);
            tmp09 = varValue(:,3);
            tmp24 = varValue(:,[4 5]);      
            tmp00to09 = cat(2, mean(tmp00,2), tmp09);
            str09 = strcat(varName,"_BLto9mth");
            DataLDR.(str09) = tmp00to09;    
            tmp00to24 = cat(2, mean(tmp00,2), mean(tmp24,2));
            str24 = strcat(varName,"_BLto24mth");     
            DataLDR.(str24) = tmp00to24;
        elseif contains(varName, "CHL")
            tmp00 = varValue(:,[1 2]);
            tmp09 = varValue(:,3);
            tmp00to09 = cat(2, mean(tmp00,2), tmp09);
            str = strcat(varName,"_BLto9mth");    
            DataLDR.(str) = tmp00to09;      
        elseif contains(varName, "CRB")
            tmp09 = varValue(:,3);
            tmp24 = varValue(:,[2 3]);
            tmp09to24 = cat(2, tmp09, mean(tmp24,2));
            str = strcat(varName,"_9mthto24mth");
            DataLDR.(str) = tmp09to24;      
        end
end

end