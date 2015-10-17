function images = GetCellImages(imgGray, labels)
    
    imgGray = double(imgGray)/255.0;
    
    imgProps = regionprops(labels, 'Image', 'SubarrayIdx');
    
    [numCells, ~] = size(imgProps);
    images = cell(numCells,1);
    
    for i=1:numCells
        cellMask = imgProps(i).Image;
        cellSubImage = imgGray(imgProps(i).SubarrayIdx{:});
        images{i} = cellSubImage .*cellMask;
    end

end