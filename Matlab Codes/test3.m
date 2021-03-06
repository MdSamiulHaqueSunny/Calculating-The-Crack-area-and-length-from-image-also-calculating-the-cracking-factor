%% load image
I=imread('crack6.jpg');
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


level = 0.3;
Ithres = im2bw(Igray_s,level);
figure,imshow(Ithres)
title('Segmented cracks')

binaryImage = bwmorph(Ithres, 'skel', inf');
measurements = regionprops(binaryImage, 'Area');