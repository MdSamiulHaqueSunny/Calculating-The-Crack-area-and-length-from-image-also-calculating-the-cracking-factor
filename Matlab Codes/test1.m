%% load image
I=imread('crack7.jpg');
figure,imshow(I)
title('Original image')
%% Image adjust 
Istrech = imadjust(I,stretchlim(I));
figure,imshow(Istrech)
title('Contrast stretched image')
%% Convert RGB image to gray
Igray_s = rgb2gray(Istrech);
figure,imshow(Igray_s,[])
title('RGB to gray (contrast stretched) ')
%% Image segmentation by thresholding
%use incremental value to run this selection till required threshold 'level' is          
%achieved


level = 0.08;
Ithres = im2bw(Igray_s,level);
figure,imshow(Ithres)
title('Segmented cracks')
%% Image morphological operation
BW = bwmorph(Ithres,'clean',10);
figure,imshow(BW)
title('Cleaned image')
BW = bwmorph(Ithres,'thin', inf);
figure,imshow(BW)
title('Thinned image')
BW = imfill(Ithres, 'holes')
figure,imshow(BW)
title('Filled image')
%% Image tool
figure,imtool(BW)
figure,imtool(I)
%% Calaculate crack length
calibration_length=0.001;   
calibration_pixels=1000;
crack_pixel=350;
crack_length=(crack_pixel *calibration_length)/calibration_pixels;