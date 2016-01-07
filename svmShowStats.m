clear; clc; close all;
addpath('./utils');

fprintf('-- SVM show stats --\n');

load('./mat/svm_prediction_results');

EvaluateResults({svmPredictionResults.ImageRealLabels}, {svmPredictionResults.ImagePredictedLabels});