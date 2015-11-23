function [segmentationOverlay] = GetSegmentationPreview(img)
    % convert to gray scale if needed
    if(size(img,3)~=1)
        imgGray = rgb2gray(img);
    else
        imgGray = img;
    end
    
    [numCells, cellsPerimeter, cellImages, cellMasks] = SegmentateCells(imgGray);
    
    segmentationOverlay = imoverlay(img, imdilate(cellsPerimeter, true(3)), [1 .3 .3]);
end