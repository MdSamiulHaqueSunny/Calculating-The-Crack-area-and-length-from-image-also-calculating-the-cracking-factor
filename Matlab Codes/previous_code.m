%step one: Loading the image
I1 = imread('crack1.jpg');
figure, imshow(I1);
level=.30;
B = im2bw(I1, level);
figure, imshow(B);

%step two: Detect the liner specimen
j=276;
for i=1:1:150
c=B(i,j);
if c==0
y1=i
break
end
end

for i=182:-1:0
c=B(i,j);
if c==0
y2=i
break
end
end

i=75;
for j=1:1:276
c=B(i,j);
if c==0
x1=j
break
end
end
for j=276:-1:0
c=B(i,j);
if c==0
x2=j
break
end
end

%%step three: Crop the liner surface from RGB image
topLine = x1;
bottomLine = x2;
leftColumn =y1;
rightColumn =y2;
width = bottomLine - topLine + 1;
height = rightColumn - leftColumn + 1;
PP = imcrop(I1,[topLine, leftColumn, width,height]);
figure, imshow(PP);

%Step 4: Convert the cropped RGB image of liner surface to grayscale image and then convert 
%the grayscale image to bi-nary image
K = rgb2gray(PP);
figure, imshow(K);
level = 0.30;
bw = im2bw(K,level);
bw = bwareaopen(bw, 250);
figure, imshow(bw);

%Step 5: Calculation of crack area and CIF

a1=0; % number of black
a0=0; % number of white
for i=1:1:height
for j=1:1:width
vvvv(i,j)=bw(i,j);
if bw(i,j)==0
a1=a1+1;
else
a0=a0+1;
end
end
end
black_pixel=a1 %no of black
white_pixel=a0 %no of white
totalarea=240;
crackarea=(totalarea/(a0+a1))*a1
CIF=(crackarea/240)*100

