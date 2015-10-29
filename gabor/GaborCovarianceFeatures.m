function [outCov, isSPD] = GaborCovarianceFeatures(image, mask, GR, GI, thresholdWhitePixels, concatExtraFeatures, topHatRadiusA, topHatRadiusB)
    isSPD = 1;
    outCov = [];
    if sum(mask(:)) / (size(mask, 1) * size(mask, 2)) < thresholdWhitePixels
        isSPD = 0;
        return;
    end
    
    [SizeX, SizeY] = size(image);
    [posX,posY] = meshgrid(0:1/SizeX:1-1/SizeX,0:1/SizeY:1-1/SizeY);
    
    r = reshape(image,[1, SizeX * SizeY]);
    rX = reshape(posX,[1, SizeX * SizeY]);
    rY = reshape(posY,[1, SizeX * SizeY]);
    
    if(topHatRadiusA)
        imageA = imtophat(image, strel('disk',topHatRadiusA));
    else
        imageA = image;
    end
    
    covSamples = [r; rX; rY; Apply_Gabor_Transform(imageA, 1, GR, GI)'];
    
    if(concatExtraFeatures)
        if(topHatRadiusB)
            imageB = imtophat(image, strel('disk',topHatRadiusB));
        else
            imageB = image;
        end
        covSamples = [covSamples; Apply_Gabor_Transform(imageB, 1, GR, GI)'];
    end

    %Computing the covariance matrix
    outCov = cov(covSamples');
    
    % stabilization for ill-conditioned matrices
    outCov = outCov + 100 * eps * eye(size(outCov,1));
    
    % check if is SPD (depending on precision)
    temp3 = eig(outCov);
    if ~isempty(find(temp3 <= 0, 1)) %Not SPD
        isSPD = 0;
    else 
        outCov = map2IDS_vectorize(outCov);       
    end
    
end


function y = map2IDS_vectorize(input)
    input = logm(input);    
    offDiagonals = tril(input, -1) * sqrt(2);
    diagonals = diag(diag(input));
    vecInMat = diagonals + offDiagonals; 
    vecInds = tril(ones(size(input)));
    map2ITS = vecInMat(:);
    vecInds = vecInds(:);
    y = map2ITS(vecInds == 1);
end