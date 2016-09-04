I = imread('circuit.tif');
imtool('circuit.tif')
I2 = imcrop(I,[1 1 130 112]);
subplot(1,2,1)
imshow(I)
title('Original Image')
subplot(1,2,2)
imshow(I2)
title('Cropped Image')