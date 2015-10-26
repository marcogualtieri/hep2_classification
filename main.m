clear; clc; close all;

addpath('./gabor');

loadTrainingSet();

load('./mat/trainSet.mat');

[GR, GI] = CreateGaborFilters(configuration.Gabor_options);

processedImgCounter = 1;

startTime = clock;

imageNumber = length(trainSet);   

if(configuration.concatExtraFeatures)
    gaborFeaturesLength = 27;
else
    gaborFeaturesLength = 15;
end
covdFeaturesLength = (((gaborFeaturesLength*gaborFeaturesLength)-gaborFeaturesLength)/2)+gaborFeaturesLength;

features = [];
labels = [];

fprintf('Processing %d images\n\n', imageNumber);
fprintf('Image processed: 0 / 0.00 %% - Elapsed Time: 0.00 s\n');

for imageId = 1:imageNumber
    filename = char(trainSet(imageId, 3)); 

    if(exist(char(filename), 'file') ~= 2)
       warning('Image %s not found. Will not be processed.\n', char(filename));
    else
        image = rgb2gray(imread(filename));
        [numCells, cellImages, cellMasks] = SegmentateCells(image);
        imageFeatures = zeros(covdFeaturesLength, numCells);
        for cellIndex = 1:numCells
            [cellFeatures, isSPD] = GaborCovarianceFeatures(cellImages{cellIndex}, cellMasks{cellIndex}, GR, GI, 0.1, ...
                                    configuration.topHatRadiusA, configuration.concatExtraFeatures, configuration.topHatRadiusB);
            if(isSPD == 1)
                imageFeatures(:,cellIndex) = cellFeatures;
                labels = [labels trainSet(imageId, 2)];
            else
                warning('NON SPD COVD MATRIX'));
            end
        end
        features = [features imageFeatures];
    end
    
    fprintf('Image processed: %d / %.2f %%', processedImgCounter, ...
        (processedImgCounter * 100/imageNumber));
    fprintf(' - Elapsed time: %.2f s\n', etime(clock, startTime));
    processedImgCounter = processedImgCounter + 1;  
end

save('./mat/svm_input','features','labels');