clear; clc; close all;
addpath('./gabor');
addpath('./utils');
mkdir('./mat');

trainSet = loadTrainingSet();

[GR, GI] = CreateGaborFilters(configuration.Gabor_options);

processedImgCounter = 1;

startTime = clock;

imageNumber = length(trainSet);   

svmDataset = [];

fprintf('Processing %d images\n\n', imageNumber);
fprintf('Image processed: 0 / 0.00 %% - Elapsed Time: 0.00 s\n');

for imageId = 1:imageNumber
    filename = char(trainSet(imageId, 3)); 

    if(exist(char(filename), 'file') ~= 2)
       warning('Image %s not found. Will not be processed.\n', char(filename));
    else
        image = imread(filename);
        % convert to gray scale if needed
        if(size(image,3)~=1)
            image = rgb2gray(image);
        end
        % segmentate cells and extract features 
        [numCells, cellImages, cellMasks] = SegmentateCells(image);
        for cellIndex = 1:numCells
            [cellFeatures, isSPD] = GaborCovarianceFeatures(cellImages{cellIndex}, cellMasks{cellIndex}, GR, GI, 0.1, ...
                                    configuration.concatExtraFeatures, configuration.topHatRadiusA, configuration.topHatRadiusB);
            if(isSPD == 1)
                svmDataset = [svmDataset ...
                                struct(...
                                   'ImageId', imageId, ...
                                   'CellId', cellIndex, ...
                                   'Features', cellFeatures, ...
                                   'Labels', trainSet(imageId, 2))...
                               ];
            else
                warning('NON SPD COVD MATRIX');
            end
        end
    end
    
    fprintf('Image processed: %d / %.2f %%', processedImgCounter, ...
        (processedImgCounter * 100/imageNumber));
    fprintf(' - Elapsed time: %.2f s\n', etime(clock, startTime));
    processedImgCounter = processedImgCounter + 1;  
end

save('./mat/svm_dataset','svmDataset');