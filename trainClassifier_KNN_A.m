function [trainClassifier_KNN_A, validationAccuracy] = trainClassifier_KNN_A(trainingData)

% [trainedClassifier_KNN_A, validationAccuracy] = trainClassifier_KNN_A(trainingData)
% Returns a trained classifier and its accuracy. This code recreates the
% classification model trained in Classification Learner app. Use the
% generated code to automate training the same model with new data, or to
% learn how to programmatically train models.
%
%  Input:
%      trainingData: A table containing the same predictor and response
%       columns as those imported into the app.
%
%       C01.Fault_Code                        [307 x 1 char]
%       C02.Clearance_Factor                  [307 x 1 double]
%       C03.Crest_Factor                      [307 x 1 double]
%       C04.Impulse_Factor                    [307 x 1 double]
%       C05.Kurtosis                          [307 x 1 double]
%       C06.Mean                              [307 x 1 double]
%       C07.Peak_Value                        [307 x 1 double]
%       C08.RMS                               [307 x 1 double]
%       C09.Shape_Factor                      [307 x 1 double]
%       C10.Skewness                          [307 x 1 double]
%       C11.Std                               [307 x 1 double]
%       C12.BPFO_Amplitude                    [307 x 1 double]
%       C13.BPFI_Amplitude                    [307 x 1 double]
%       C14.BSF_Amplitude                     [307 x 1 double]
%       C15.LOG_BPFI_Amplitude_BPFO_Amplitude [307 x 1 double]
%       C16.LOG_BSF_Amplitude_BPFO_Amplitude  [307 x 1 double]
%       C17.LOG_BPFI_Amplitude_BSF_Amplitude  [307 x 1 double]
%
%  Output:
%      trainedClassifier_KNN_A: A struct containing the trained classifier. The
%       struct contains various fields with information about the trained
%       classifier.
%
%      trainedClassifier_KNN_A.predictFcn: A function to make predictions on new
%       data.
%
%      validationAccuracy: A double containing the accuracy in percent. In
%       the app, the History list displays this overall accuracy score for
%       each model.
%
% Use the code to train the model with new data. To retrain your
% classifier, call the function from the command line with your original
% data or new data as the input argument trainingData.
%
% For example, to retrain a classifier trained with the original data set
% T, enter:
%   [trainedClassifier_KNN_A, validationAccuracy] = trainClassifier_KNN_A(T)
%
% To make predictions with the returned 'trainedClassifier_KNN_A' on new data T2,
% use
%   yfit = trainedClassifier_KNN_A.predictFcn(T2)
%
% T2 must be a table containing at least the same predictor columns as used
% during training. For details, enter:
%   trainedClassifier_KNN_A.HowToPredict

%Reference

    %[1] Cascales Fulgencio, D.; Quiles Cucarella, E.; García Moreno, E.
    %Computation and Statistical Analysis of Bearings’ Time- and
    %Frequency-Domain Features Enhanced Using Cepstrum Pre-Whitening: A ML-
    %and DL-Based Classification.
    %Appl. Sci. 2022.

% Auto-generated by MATLAB. Last revision: 17/09/2022.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Extract predictors and response
% This code processes the data into the right shape for training the
% model.
inputTable = trainingData;
predictorNames = {'Clearance_Factor', 'Crest_Factor', 'Impulse_Factor', 'Kurtosis', 'Mean', 'Peak_Value', 'RMS', 'Shape_Factor', 'Skewness', 'Std', 'BPFO_Amplitude', 'BPFI_Amplitude', 'BSF_Amplitude', 'LOG_BPFI_Amplitude_BPFO_Amplitude', 'LOG_BSF_Amplitude_BPFO_Amplitude', 'LOG_BPFI_Amplitude_BSF_Amplitude'};
predictors = inputTable(:, predictorNames);
response = inputTable.Fault_Code;

% Train a classifier
% This code specifies all the classifier options and trains the classifier.
classificationKNN = fitcknn(...
    predictors, ...
    response, ...
    'Distance', 'Euclidean', ...
    'Exponent', [], ...
    'NumNeighbors', 1, ...
    'DistanceWeight', 'Equal', ...
    'Standardize', true, ...
    'ClassNames', ['0'; '1'; '2'; '3']);

% Create the result struct with predict function
predictorExtractionFcn = @(t) t(:, predictorNames);
knnPredictFcn = @(x) predict(classificationKNN, x);
trainClassifier_KNN_A.predictFcn = @(x) knnPredictFcn(predictorExtractionFcn(x));

% Add additional fields to the result struct
trainClassifier_KNN_A.RequiredVariables = {'BPFI_Amplitude', 'BPFO_Amplitude', 'BSF_Amplitude', 'Clearance_Factor', 'Crest_Factor', 'Impulse_Factor', 'Kurtosis', 'LOG_BPFI_Amplitude_BPFO_Amplitude', 'LOG_BPFI_Amplitude_BSF_Amplitude', 'LOG_BSF_Amplitude_BPFO_Amplitude', 'Mean', 'Peak_Value', 'RMS', 'Shape_Factor', 'Skewness', 'Std'};
trainClassifier_KNN_A.ClassificationKNN = classificationKNN;
trainClassifier_KNN_A.About = 'This struct is a trained model exported from Classification Learner R2020a.';
trainClassifier_KNN_A.HowToPredict = sprintf('To make predictions on a new table, T, use: \n  yfit = c.predictFcn(T) \nreplacing ''c'' with the name of the variable that is this struct, e.g. ''trainedModel''. \n \nThe table, T, must contain the variables returned by: \n  c.RequiredVariables \nVariable formats (e.g. matrix/vector, datatype) must match the original training data. \nAdditional variables are ignored. \n \nFor more information, see <a href="matlab:helpview(fullfile(docroot, ''stats'', ''stats.map''), ''appclassification_exportmodeltoworkspace'')">How to predict using an exported model</a>.');

% Perform cross-validation
partitionedModel = crossval(trainClassifier_KNN_A.ClassificationKNN, 'KFold', 5);

% Compute validation predictions
[~, ~] = kfoldPredict(partitionedModel);

% Compute validation accuracy
validationAccuracy = 1 - kfoldLoss(partitionedModel, 'LossFun', 'ClassifError');

end