clear; clc; close all;
fprintf('-- SVM evaluate result --\n');
startTime = clock;

load('./mat/svm_dataset');
load('./mat/svm_model');

cellRealLabels = {svmDataset.Labels};

% Predict labels on the model
cellPredictedLabels = kfoldPredict(model);
% predictedLabels = predict(model, features');

%%%% CELL LEVEL %%%%
fprintf('-- Cell level --\n');
EvaluateResults(cellRealLabels, cellPredictedLabels);

%%%% IMAGE LEVEL %%%%
fprintf('-- Image level --\n');
imageNumber = max([svmDataset.ImageId]);
imageRealLabels = [];
imagePredictedLabels = [];
for imageId = 1:imageNumber
    imageCellsPredictedLabels = cellPredictedLabels([svmDataset.ImageId]==imageId);
    if(length(imageCellsPredictedLabels)>0)
        imageRealLabel = unique(cellRealLabels([svmDataset.ImageId]==imageId));
        imageRealLabels = [imageRealLabels imageRealLabel];
        
        [unique_strings, ~, string_map] = unique(imageCellsPredictedLabels);
        imagePredictedLabel = unique_strings(mode(string_map));
        imagePredictedLabels = [imagePredictedLabels imagePredictedLabel];
    end
end
EvaluateResults(imageRealLabels, imagePredictedLabels);
