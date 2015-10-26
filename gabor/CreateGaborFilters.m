function [GR,GI]    =    CreateGaborFilters (Gabor_options)

%  Gabor options:
%
%      Width         Gabor kernel's width
%      Kmax          Gabor kernel's parameter, default(pi/2)
%      f             Gabor kernel's parameter, default(sqrt(2))
%      Sigma         Gabor kernel's parameter, default(2*pi)
%      num_theta     Gabor kernel's number of directions,default(8)
%      num_scale     Gabor kernel's number of scales,default(5)
%      show_plot     Display Gabor filters
%
%

if  (~isfield(Gabor_options, 'Width'))
    Gabor_options.Width = 31;
end

if  (~isfield(Gabor_options, 'Kmax'))
    Gabor_options.Kmax = pi/2;
end

if  (~isfield(Gabor_options, 'f'))
    Gabor_options.f = sqrt(2);
end

if  (~isfield(Gabor_options, 'sigma'))
    Gabor_options.Sigma = 2*pi;
end

if  (~isfield(Gabor_options, 'num_theta'))
    Gabor_options.num_theta = 8;
end

if  (~isfield(Gabor_options, 'num_scale'))
    Gabor_options.num_scale = 5;
end

if  (~isfield(Gabor_options, 'Energy_Ratio'))
    Gabor_options.Energy_Ratio = 2;
end

if  (~isfield(Gabor_options, 'show_plot'))
    Gabor_options.show_plot = false;
end

GaborReal = zeros( Gabor_options.Width, Gabor_options.Width, Gabor_options.num_scale*Gabor_options.num_theta );
GaborImg = zeros( Gabor_options.Width, Gabor_options.Width, Gabor_options.num_scale*Gabor_options.num_theta );

tmpCNTR = 1;
for v = 0 : Gabor_options.num_scale - 1
    for u = 0 : Gabor_options.num_theta - 1
        [GaborReal(:,:,tmpCNTR), GaborImg(:, :, tmpCNTR)] = MakeGaborKernel(Gabor_options, u, v);
        
        if(Gabor_options.show_plot)
            subplot(Gabor_options.num_scale, Gabor_options.num_theta, tmpCNTR);
            imshow(squeeze(GaborReal(:,:,tmpCNTR)),[]);
        end
        
        tmpCNTR = tmpCNTR + 1;
    end
end

if (Gabor_options.Energy_Ratio<1)
    %The following code will compute how much of Gabor energy is concentrated
    %in a disk and resize the filters accordingly.
    radius_w       =    floor(kernel_options.Width/2);
    radius_h       =    radius_w;
    center_w       =    radius_w + 1;
    center_h       =    radius_h + 1;
    ker_ener       =    [];
    
    for step  =  1: (radius_w+radius_h)/2
        ratio          =    0;
        for i  =  1 :Gabor_options.num_scale*Gabor_options.num_theta
            temp_r1 = sum(sum(abs(GaborReal(center_h-radius_h+step:center_h+radius_h-step,center_w-radius_w+step:center_w+radius_w-step,i))));
            temp_r2 = sum(sum(abs(GaborReal(:,:,i))));
            temp_i1 = sum(sum(abs(GaborImg(center_h-radius_h+step:center_h+radius_h-step,center_w-radius_w+step:center_w+radius_w-step,i))));
            temp_i2 = sum(sum(abs(GaborImg(:,:,i))));
            ratio   = ratio + temp_r1/temp_r2/(Gabor_options.num_scale*Gabor_options.num_theta) ...
                + temp_i1/temp_i2/(Gabor_options.num_scale*Gabor_options.num_theta);
        end
        ker_ener = [ker_ener ratio];
        if ratio < Gabor_options.Energy_Ratio
            step = step - 1;
            break;
        end
    end
    
    GR  =  GaborReal(center_h-radius_h+step:center_h+radius_h-step,center_w-radius_w+step:center_w+radius_w-step,:);
    GI  =  GaborImg(center_h-radius_h+step:center_h+radius_h-step,center_w-radius_w+step:center_w+radius_w-step,:);
else
    GR  =  GaborReal;
    GI  =  GaborImg;
end

function [GaborReal, GaborImg] = MakeGaborKernel(Gabor_options, U, V)

%            ||Ku,v||^2
% G(Z) = ---------------- exp(-||Ku,v||^2 * Z^2)/(2*sigma*sigma)(exp(i*Ku,v*Z)-exp(-sigma*sigma/2))
%          sigma*sigma

HarfW = fix(Gabor_options.Width/2);

Qu = pi*U/Gabor_options.num_theta;
sqsigma = Gabor_options.Sigma^2;

Kv = Gabor_options.Kmax/(Gabor_options.f^V);
 
postmean = exp(-sqsigma/2);

for j = -HarfW : HarfW
    for i =  -HarfW : HarfW      
        tmp1 = exp(-(Kv*Kv*(j*j+i*i)/(2*sqsigma)));
        tmp2 = cos(Kv*cos(Qu)*i+Kv*sin(Qu)*j) - postmean;
        tmp3 = sin(Kv*cos(Qu)*i+Kv*sin(Qu)*j);
       
        GaborReal(j + HarfW + 1, i + HarfW + 1) = Kv * Kv * tmp1 * tmp2/sqsigma;
        GaborImg(j + HarfW + 1, i+ HarfW + 1) = Kv * Kv * tmp1 * tmp3/sqsigma;
    end
end
