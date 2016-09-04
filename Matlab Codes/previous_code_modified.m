%step one: Loading the image
%imtool('crack6.jpg')
I1 = imread('F:\debu ce\imege 5\DSC01289.JPG');
%figure, imshow(I1);
level=.3;
B = im2bw(I1, level);
%figure, imshow(B);
imtool(B)

% %step two: Detect the liner specimen

for row_x=1:1:182
    c=B(row_x,:)
    m=sum(c(1,:))
    if m>273
        continue
    else 
        y1=row_x 
        break
    end  
end

for column_x=1:1:276
    c=B(:,column_x)
    m=sum(c(:,1))
    if m>181
        continue
    else 
        x1=column_x
        break
    end  
end

for row_x=182:-1:1
    c=B(row_x,:)
    m=sum(c(1,:))
    if m>273
        continue
    else 
        y2=row_x 
        break
    end  
end

for column_x=276:-1:1
    c=B(:,column_x)
    m=sum(c(:,1))
    if m>181
        continue
    else 
        x2=column_x
        break
    end  
end
rect=[x1 y1 x2 y2]

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

