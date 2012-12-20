function [  ] = showEdges( array )

I = mat2gray(array);
subplot(1,3,1);
imshow(I);

h = fspecial('gaussian',10,10);
I1 = imfilter(I,h);
subplot(1,3,2);
imshow(I1);

subplot(1,3,3);
Ibw = im2bw(I1,graythresh(I1));
imshow(Ibw);


end

