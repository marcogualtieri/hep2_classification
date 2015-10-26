clear; clc;
fprintf('-- SVM classifier --\n');
start_time = clock;

load('./mat/svm_input');

image_number = length(labels);

% Using gaussian kernel
t = templateSVM('KernelFunction','gaussian');

% Fit SVM model. Using matlab function for multiclass training
kFolds = configuration.kFolds;

model = fitcecoc(features', labels, 'Learners', t, ...
    'Prior', 'uniform', 'CrossVal', 'on', 'KFold', kFolds);

% Predict labels on the model
predictedLabels = kfoldPredict(model);

% Generate and plot confusion matrix
[confusionMatrix, classes] = plotConfusionMatrix(labels, predictedLabels');

% Evaluate results
classFrequency = sum(confusionMatrix, 2);
classCorrectedPred = diag(confusionMatrix);
classCorrectRate = (classCorrectedPred .* 100) ./ classFrequency;
table(classes, classFrequency, classCorrectedPred, classCorrectRate, ...
    'VariableNames', {'Class', 'Total', 'Correct', 'Rate'})

correctClassifiedCells = sum(classCorrectedPred);
fprintf('Correct classified cells: %d / %d\n', correctClassifiedCells, image_number);

accuracy = correctClassifiedCells/image_number;
fprintf('Accuracy: %.2f %%\n', accuracy * 100);

fprintf('Elapsed time: %.2f s\n\n', etime(clock, start_time));
    
