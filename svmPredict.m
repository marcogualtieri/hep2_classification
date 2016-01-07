clear; clc; close all;
addpath('./utils');

fprintf('-- SVM predict result --\n');
startTime = clock;

load('./mat/svm_dataset');
load('./mat/cp_ecoc_model');

features = [svmDataset.Features]';
cellRealLabels = {svmDataset.Labels};

% If the prediction is performed on the same dataset used for training,
% we use kfoldPredict method (for each fold of the datset, labels are 
% predicted for in-fold observations using a model trained on out-of-fold observations.
if(isequal(cpEcocModel.X, features))
    cellPredictedLabels = kfoldPredict(cpEcocModel);

% If the prediction is performed on a different dataset, we use all the k
% models to predict classes, then we use a majority voting strategy
else
    cellPredictedLabelsTmp = [];
    for i=1:length(cpEcocModel.Trained)
        cellPredictedLabelsTmp = [cellPredictedLabelsTmp predict(cpEcocModel.Trained{i}, features)];
    end
    cellPredictedLabels = [];
    for j=1:length(cellPredictedLabelsTmp)
        [unique_strings, ~, string_map] = unique(cellPredictedLabelsTmp(j,:));
        cellPredictedLabels = [cellPredictedLabels unique_strings(mode(string_map))];
    end
end

% Group at image level
allImageIds = unique([svmDataset.ImageId]);

svmPredictionResults = [];

imageIds = [];
imageRealLabels = [];
imagePredictedLabels = [];

for imageCounter = 1:size(allImageIds,2)
    imageId = allImageIds(imageCounter);
    imageCellsPredictedLabels = cellPredictedLabels([svmDataset.ImageId]==imageId);
    if(~isempty(imageCellsPredictedLabels))
        imageRealLabel = unique(cellRealLabels([svmDataset.ImageId]==imageId));      
        [unique_strings, ~, string_map] = unique(imageCellsPredictedLabels);
        imagePredictedLabel = unique_strings(mode(string_map));        
        svmPredictionResults = [svmPredictionResults ...
            struct(...
                'ImageIds', imageId, ...
                'ImageRealLabels', imageRealLabel, ...
                'ImagePredictedLabels', imagePredictedLabel ...
        )];
    end
end

% Print prediction result
table([svmPredictionResults.ImageIds]', {svmPredictionResults.ImageRealLabels}', {svmPredictionResults.ImagePredictedLabels}', ...
        'VariableNames', {'ImageId', 'Real', 'Predicted'})
    
% Save prediction result
save('./mat/svm_prediction_results','svmPredictionResults');
fprintf('Results saved in /mat/svm_prediction_results \n');