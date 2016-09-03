input_im=imread('crack7.jpg');
input_im=rgb2gray(input_im);
imshow(input_im)
title('Original Object')

sum_of_x_axis=sum(input_im,1);
sum_of_y_axis=sum(input_im,2);
location_of_object_on_x=find(sum_of_x_axis>0);
location_of_object_on_y=find(sum_of_y_axis>0);    
seperated_object=input_im(location_of_object_on_y(1):...
    location_of_object_on_y(end),location_of_object_on_x(1):...
    location_of_object_on_x(end));
figure;
imshow(seperated_object);
title('Seperated Object')

detected_outer_surface=im2bw(seperated_object);
sum_of_outer_space=0;
for i=1:size(seperated_object,1)
   if seperated_object(i,1)>0
       break
   end
    for j=1:size(seperated_object,2)
         if seperated_object(i,j)>0
        break
         end
         detected_outer_surface(i,j)=1;
         sum_of_outer_space=sum_of_outer_space+1;
    end
end
for i=1:size(seperated_object,1)
   if seperated_object(i,size(seperated_object,2))>0
       break
   end
    for j=size(seperated_object,2):-1:1
         if seperated_object(i,j)>0
        break
         end
         detected_outer_surface(i,j)=1;
         sum_of_outer_space=sum_of_outer_space+1;
    end
end
figure;
imshow(detected_outer_surface)
title('Detected outer Surface which does not belong to object')
Area_of_object=size(seperated_object,1)*size(seperated_object,2);
Area_of_object=Area_of_object-sum_of_outer_space
Height_of_the_line=max(sum_of_x_axis)