function components = SegmentateCells(imgGray, plotSteps)

    if nargin < 2
        plotSteps = false;
    end

    % original
    if(plotSteps); figure, imshow(imgGray), title('Gray'); end;
    % adjust contrast
    imgGrayNorm = uint8(255*mat2gray(imadjust(imgGray)));
    if(plotSteps); figure, imshow(imgGrayNorm), title('Gray Normalized'); end;
    % remove noise with adaptive filter
    imgGrayNorm = wiener2(imgGrayNorm, [5 5]);
    if(plotSteps); figure, imshow(imgGrayNorm), title('Remove noise'); end;
    
    % compute mask
    mask = im2bw(imgGrayNorm, graythresh(imgGrayNorm));
    if(plotSteps); figure, imshow(mask), title('Mask'); end;
    % morphological opening
    mask = imopen(mask, strel('disk',5)); 
    if(plotSteps); figure, imshow(mask), title('Mask - Morphological opening'); end;
    % fill mask holes just above a certain size
    mask = ~bwareaopen(~mask, 500);
    if(plotSteps); figure, imshow(mask), title('Mask - Fill holes opening'); end;
    % remove small cc from mask
    mask = bwareaopen(mask, 1600);
    if(plotSteps); figure, imshow(mask), title('Mask - Remove small cc'); end;
    % print mask overlay
    mask_perim = bwperim(mask);
    overlay1 = imoverlay(imgGrayNorm, mask_perim, [1 .3 .3]);
    if(plotSteps); figure, imshow(overlay1), title('Mask - Perimeter overlay'); end;
    
    % calculate euclidean distance
    euclideanDistance = -bwdist(~mask);
    if(plotSteps); figure, imshow(euclideanDistance, []), title('Mask - Euclidean distance'); end;
    % compute watershed transform
    waterShed = watershed(euclideanDistance);
    if(plotSteps); figure, imshow(label2rgb(waterShed)), title('Watershed transform'); end;  
    % transform watershed ridge lines to background pixels
    mask_watershed = mask;
    mask_watershed(waterShed == 0) = 0;
    if(plotSteps); figure, imshow(mask_watershed), title('Mask watershed'); end;  
    % identify centroids
    centroids = imextendedmin(euclideanDistance,2);
    if(plotSteps); figure, imshowpair(mask,centroids,'blend'), title('Mask & centroids'); end;  
        
    % Modify the distance transform so it only has minima at the desired locations, and then repeat the watershed 
    euclideanDistance2 = imimposemin(euclideanDistance,centroids);
    waterShed2 = watershed(euclideanDistance2);
    mask_watershed2 = mask;
    mask_watershed2(waterShed2 == 0) = 0;
    if(plotSteps); figure, imshow(mask_watershed2), title('Mask watershed'); end;  
    
    % print mask overlay
    mask_perim2 = bwperim(mask_watershed2);
    overlay2 = imoverlay(imgGray, mask_perim2, [1 .3 .3]);
    if(plotSteps); figure, imshow(overlay2), title('Mask - Perimeter overlay'); end;
    
    % remove cells from the border
    mask_watershed2 = imclearborder(mask_watershed2);
    
    % return segmented components
    components = bwconncomp(mask_watershed2, 8);
    labeled_components = labelmatrix(components);
    if(plotSteps); figure, imshow(label2rgb(labeled_components)), title('Mask - Components'); end;

end