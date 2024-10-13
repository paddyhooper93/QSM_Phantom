function [TRR_ICC, LDR_ICC, FSR_ICC] = Wrapper_ICC(DataTRR, DataLDR, DataFSR)

type = 'A-k';

% Initialize outputs
TRR_ICC = struct();
LDR_ICC = struct();
FSR_ICC = struct();

% Process DataTRR
fieldsTRR = fieldnames(DataTRR);
for i = 1:length(fieldsTRR)
    varName = fieldsTRR{i};
    varValue = DataTRR.(varName);
    TRR_ICC.(varName) = calculateICC(varValue, type);
end

% Process DataLDR
fieldsLDR = fieldnames(DataLDR);
for i = 1:length(fieldsLDR)
    varName = fieldsLDR{i};
    varValue = DataLDR.(varName);
    LDR_ICC.(varName) = calculateICC(varValue, type);
end

% Process DataFSR
fieldsFSR = fieldnames(DataFSR);
for i = 1:length(fieldsFSR)
    varName = fieldsFSR{i};
    varValue = DataFSR.(varName);
    FSR_ICC.(varName) = calculateICC(varValue, type);
end

    function ICC_Data = calculateICC(varValue, type)
        % Placeholder for ICC calculation function
        str_r = 'r';
        str_low = 'lb';
        str_high = 'ub';
        str_F = 'F';
        str_df1 = 'df1';
        str_df2 = 'df2';
        str_p = 'p';
        str_judgement = 'reliability';
        [ICC_Data.(str_r), ICC_Data.(str_low), ICC_Data.(str_high), ICC_Data.(str_F), ...
            ICC_Data.(str_df1), ICC_Data.(str_df2), ICC_Data.(str_p)] = ...
            ICC(varValue, type);

        % Classify ICC reliability
        if ICC_Data.(str_low) > 0.9
            ICC_Data.(str_judgement) = 'excellent';
        elseif (ICC_Data.(str_low) > 0.75) && (ICC_Data.(str_low) < 0.9) && ...
                (ICC_Data.(str_high) > 0.9)
            ICC_Data.(str_judgement) = 'good to excellent';
        elseif (ICC_Data.(str_low) > 0.75) && (ICC_Data.(str_low) < 0.9) && ... 
                (ICC_Data.(str_high) > 0.75) && (ICC_Data.(str_high) < 0.9)
            ICC_Data.(str_judgement) = 'good';
        elseif (ICC_Data.(str_low) > 0.5) && (ICC_Data.(str_low) < 0.75) && ... 
                (ICC_Data.(str_high) > 0.75) 
            ICC_Data.(str_judgement) = 'moderate to good';
        elseif (ICC_Data.(str_low) > 0.5) && (ICC_Data.(str_low) < 0.75) && ... 
                (ICC_Data.(str_high) > 0.5) && (ICC_Data.(str_high) < 0.75)
            ICC_Data.(str_judgement) = 'moderate';            
        else
            ICC_Data.(str_judgement) = 'poor';
        end

    end
end