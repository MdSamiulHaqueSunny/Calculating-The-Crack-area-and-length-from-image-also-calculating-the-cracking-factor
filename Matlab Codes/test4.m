%%Load Image
i=imread('crack5.jpg');
imshow(i);
%Image Adjust
adj=imadjust(i,stretchlim(i));
imshow(adj);
%%Convert RGB to Gray
gry=rgb2gray(adj);
imshow(gry,[]);
%%Image segementation by thresholding
level=0.3;
thres=im2bw(gry,level);
imshow(thres);
% Image morphological operation
bw=bwmorph(thres,'clean',20);
imshow(bw);
%%End
xx=sum(bw(:) == 1)
yy=sum(bw(:)==0)
zz=xx+yy