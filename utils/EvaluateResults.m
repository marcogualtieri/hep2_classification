function [] = EvaluateResults(labels, predictedLabels)
    samplesNumber = length(labels);
    % Generate and plot confusion matrix
    [confusionMatrix, classes] = plotConfusionMatrix(labels, predictedLabels');
    % Evaluate results
    classFrequency = sum(confusionMatrix, 2);
    classCorrectedPred = diag(confusionMatrix);
    classCorrectRate = (classCorrectedPred .* 100) ./ classFrequency;
    table(classes, classFrequency, classCorrectedPred, classCorrectRate, ...
        'VariableNames', {'Class', 'Total', 'Correct', 'Rate'})
    % Print results
    correctClassifiedCells = sum(classCorrectedPred);
    fprintf('Correct classified cells: %d / %d\n', correctClassifiedCells, samplesNumber);
    accuracy = correctClassifiedCells/samplesNumber;
    fprintf('Accuracy: %.2f %%\n', accuracy * 100);
end