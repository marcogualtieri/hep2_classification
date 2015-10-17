clear; clc; close all;

for i = 1:1
    filename = strcat('../HEp-2CellsClassification/dataset/immagini_contest/', 'Siero_', int2str(i), '.bmp');       

    if(exist(char(filename), 'file') ~= 2)
       warning('Image %s not found. Will not be processed.\n', char(filename));
    else
        image = rgb2gray(imread(filename));
        labels = GetCellLabels(image);
        cells = GetCellImages(image, labels);
        for j = 1:size(cells)
            figure, imshow(cells{j});
        end
    end
end