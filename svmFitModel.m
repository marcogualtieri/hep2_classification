clear; clc; close all;

fprintf('-- SVM fit model --\n');
startTime = clock;

load('./mat/svm_dataset');

features = [svmDataset.Features];
labels = {svmDataset.Labels};

% Using gaussian kernel
t = templateSVM('KernelFunction','gaussian');

% fit with cross-validation (obtaining a ClassificationPartitionedECOC)
kFolds = configuration.kFolds;
cpEcocModel = fitcecoc(features', labels, 'Learners', t, ...
     'Prior', 'uniform', 'CrossVal', 'on', 'KFold', kFolds);

fprintf('Elapsed time: %.2f s\n\n', etime(clock, startTime));

save('./mat/cp_ecoc_model','cpEcocModel');