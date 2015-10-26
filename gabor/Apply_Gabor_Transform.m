function [gabordata] = Apply_Gabor_Transform(img, downsampling, GR, GI)
    
    A = im2double(img);
    [Sx,Sy]=size(A);
    B = [];
    for j = 1 : size(GR,3)
        face_real   =   conv2( A, GR(:,:,j), 'same' );
        face_img    =   conv2( A, GI(:,:,j), 'same' );
        face_mode   =   sqrt(face_real.^2 + face_img.^2);
        face_mode   =   imresize( face_mode, [floor(Sx/downsampling), floor(Sy/downsampling)], 'bilinear' );
        face_mode   =   face_mode(:);
        tmean       =   mean(face_mode);
        tstd        =   std( face_mode );
        face_mode   =   (face_mode - tmean )/tstd;
        B           =   [B, face_mode];
    end
    gabordata = B;
end