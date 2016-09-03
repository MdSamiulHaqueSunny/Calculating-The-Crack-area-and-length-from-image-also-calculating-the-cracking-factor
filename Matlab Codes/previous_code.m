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
figure,imshow(PP);
