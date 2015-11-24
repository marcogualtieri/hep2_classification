clear; clc; close all;
addpath('./utils');

fprintf('-- SVM evaluate result --\n');
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

%%%% CELL LEVEL %%%%
fprintf('-- Cell level --\n');
EvaluateResults(cellRealLabels, cellPredictedLabels);

%%%% IMAGE LEVEL %%%%
fprintf('\n-- Image level --\n');
imageIds = unique([svmDataset.ImageId]);

imageRealLabels = [];
imagePredictedLabels = [];
wrongImageIds = [];
wrongImageRealLabels = [];
wrongImagePredictedLabels = [];

for imageCounter = 1:size(imageIds,2)
    imageId = imageIds(imageCounter);
    imageCellsPredictedLabels = cellPredictedLabels([svmDataset.ImageId]==imageId);
    if(length(imageCellsPredictedLabels)>0)
        imageRealLabel = unique(cellRealLabels([svmDataset.ImageId]==imageId));
        imageRealLabels = [imageRealLabels imageRealLabel];
        
        [unique_strings, ~, string_map] = unique(imageCellsPredictedLabels);
        imagePredictedLabel = unique_strings(mode(string_map));
        imagePredictedLabels = [imagePredictedLabels imagePredictedLabel];
        
        if(~strcmp(imageRealLabel,imagePredictedLabel))
            wrongImageIds = [wrongImageIds imageId];
            wrongImageRealLabels = [wrongImageRealLabels imageRealLabel];
            wrongImagePredictedLabels = [wrongImagePredictedLabels imagePredictedLabel];
        end
    end
end
EvaluateResults(imageRealLabels, imagePredictedLabels);

% Identify not correctly classified images

fprintf('\n-- Wrongly classified images --\n');
table(wrongImageIds', wrongImageRealLabels', wrongImagePredictedLabels', ...
        'VariableNames', {'ImageId', 'Real', 'Predicted'})