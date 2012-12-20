function [  ] = showEdges( array )

I = mat2gray(array);
subplot(1,2,1);
imshow(I);

subplot(1,2,2);
Ibw = im2bw(I,graythresh(I));
imshow(Ibw);


end

