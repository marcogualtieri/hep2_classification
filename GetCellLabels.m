function labels = GetCellLabels(imgGray)
          
    % adjust contrast
    imgGrayNorm = uint8(255*mat2gray(imadjust(imgGray)));
    % remove noise with adaptive filter
    imgGrayNorm = wiener2(imgGrayNorm, [5 5]);
    
    % compute mask
    mask = im2bw(imgGrayNorm, graythresh(imgGrayNorm));
    % morphological opening
    mask = imopen(mask, strel('disk',5)); 
    % fill mask holes just above a certain size
    mask = ~bwareaopen(~mask, 500);
    % remove small cc from mask
    mask = bwareaopen(mask, 1600);
    
    % calculate euclidean distance
    euclideanDistance = -bwdist(~mask);
    % identify centroids
    centroids = imextendedmin(euclideanDistance,2); 
    % modify the distance transform so it only has minima at the desired locations
    euclideanDistance = imimposemin(euclideanDistance, centroids);
    % apply watershed
    waterShed = watershed(euclideanDistance);
    % find watershed mask
    mask_watershed = mask;
    mask_watershed(waterShed == 0) = 0;   
    % remove cells from the border
    mask_watershed = imclearborder(mask_watershed);
    
    % return segmented components
    labels = bwconncomp(mask_watershed, 8);
end