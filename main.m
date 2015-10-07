clear; clc; close all;

for i = 1:149
    filename = strcat('../HEp-2CellsClassification/dataset/immagini_contest/', 'Siero_', int2str(i), '.bmp');       

    if(exist(char(filename), 'file') ~= 2)
       warning('Image %s not found. Will not be processed.\n', char(filename));
    else
        components = SegmentateCells(filename);
        figure, imshow(label2rgb(components));
    end
end
