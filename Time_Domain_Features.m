function [featureTable,outputTable] = Time_Domain_Features(inputData)

%Time_Domain_Features recreates results in Diagnostic Feature Designer.
%
% Input:
%  inputData: A table or a cell array of tables/matrices containing the
%  data as those imported into the app.
%
% Output:
%  featureTable: A table containing all features and condition variables.
%  outputTable: A table containing the computation results.
%
%       C01.Fault_Code                        [307 x 1 cell]
%       C02.Signal                            [307 x 1 cell]
%
% This function computes features:
%  Signal_stats/Col1_ClearanceFactor
%  Signal_stats/Col1_CrestFactor
%  Signal_stats/Col1_ImpulseFactor
%  Signal_stats/Col1_Kurtosis
%  Signal_stats/Col1_Mean
%  Signal_stats/Col1_PeakValue
%  Signal_stats/Col1_RMS
%  Signal_stats/Col1_ShapeFactor
%  Signal_stats/Col1_Skewness
%  Signal_stats/Col1_Std
%
% Organization of the function:
% 1. Compute signals/spectra/features
% 2. Extract computed features into a table
%
% Modify the function to add or remove data processing, feature generation
% or ranking operations.

%Reference

    %[1] Cascales Fulgencio, D.; Quiles Cucarella, E.; García Moreno, E.
    %Computation and Statistical Analysis of Bearings’ Time- and
    %Frequency-Domain Features Enhanced Using Cepstrum Pre-Whitening: A ML-
    %and DL-Based Classification.
    %Appl. Sci. 2022.

% Auto-generated by MATLAB. Last revision: 17/09/2022.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Create output ensemble.
outputEnsemble = workspaceEnsemble(inputData,'DataVariables',"Signal",'ConditionVariables',"Fault_code");

% Reset the ensemble to read from the beginning of the ensemble.
reset(outputEnsemble);

% Append new signal or feature names to DataVariables.
outputEnsemble.DataVariables = unique([outputEnsemble.DataVariables;"Signal_stats"],'stable');

% Set SelectedVariables to select variables to read from the ensemble.
outputEnsemble.SelectedVariables = "Signal";

% Loop through all ensemble members to read and write data.
while hasdata(outputEnsemble)
    % Read one member.
    member = read(outputEnsemble);
    
    % Get all input variables.
    Signal.Col1 = readMemberData(member,"Signal","Col1");
    
    % Initialize a table to store results.
    memberResult = table;
    
    % SignalFeatures
    try
        % Compute signal features.
        inputSignal = Signal.Col1;
        Col1_ClearanceFactor = max(abs(inputSignal))/(mean(sqrt(abs(inputSignal)))^2);
        Col1_CrestFactor = peak2rms(inputSignal);
        Col1_ImpulseFactor = max(abs(inputSignal))/mean(abs(inputSignal));
        Col1_Kurtosis = kurtosis(inputSignal);
        Col1_Mean = mean(inputSignal,'omitnan');
        Col1_PeakValue = max(abs(inputSignal));
        Col1_RMS = rms(inputSignal,'omitnan');
        Col1_ShapeFactor = rms(inputSignal,'omitnan')/mean(abs(inputSignal),'omitnan');
        Col1_Skewness = skewness(inputSignal);
        Col1_Std = std(inputSignal,'omitnan');
        
        % Concatenate signal features.
        featureValues = [Col1_ClearanceFactor,Col1_CrestFactor,Col1_ImpulseFactor,Col1_Kurtosis,Col1_Mean,Col1_PeakValue,Col1_RMS,Col1_ShapeFactor,Col1_Skewness,Col1_Std];
        
        % Package computed features into a table.
        featureNames = ["Col1_ClearanceFactor","Col1_CrestFactor","Col1_ImpulseFactor","Col1_Kurtosis","Col1_Mean","Col1_PeakValue","Col1_RMS","Col1_ShapeFactor","Col1_Skewness","Col1_Std"];
        Signal_stats = array2table(featureValues,'VariableNames',featureNames);
    catch
        % Package computed features into a table.
        featureValues = NaN(1,10);
        featureNames = ["Col1_ClearanceFactor","Col1_CrestFactor","Col1_ImpulseFactor","Col1_Kurtosis","Col1_Mean","Col1_PeakValue","Col1_RMS","Col1_ShapeFactor","Col1_Skewness","Col1_Std"];
        Signal_stats = array2table(featureValues,'VariableNames',featureNames);
    end
    
    % Append computed results to the member table.
    memberResult = [memberResult, ...
        table({Signal_stats},'VariableNames',"Signal_stats")]; %#ok<AGROW>
    
    % Write all the results for the current member to the ensemble.
    writeToLastMemberRead(outputEnsemble,memberResult)
end

% Gather all features into a table.
featureTable = readFeatureTable(outputEnsemble);

% Set SelectedVariables to select variables to read from the ensemble.
outputEnsemble.SelectedVariables = unique([outputEnsemble.DataVariables;outputEnsemble.ConditionVariables;outputEnsemble.IndependentVariables],'stable');

% Gather results into a table.
outputTable = readall(outputEnsemble);

end