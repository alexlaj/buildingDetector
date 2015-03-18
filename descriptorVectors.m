function [ decVect] = descriptorVectors( R, lMax)
%This function will take in the gabour filters and create a descriptor
%vectors from it. The 4 by K matrix will have location, possible distance
%from the building center, and the orrientation. 
[n, m, i] = size(lMax);
features = zeros(n,m);
for j = 1:i
   features = features|lMax(:,:,j); 
end

[y, x] = find(features);
[length, ~] = size(x);
decVect = zeros(4,length);

%decVect(:,1) = x.';
%decVect(:,2) = y.';


%This section finds the length of each feature

Rmag = abs(R);
Rbw = zeros(n,m,i);
for j = 1:i
    Rbw(:,:,j) = im2bw(Rmag(:,:,j),graythresh(Rmag(:,:,j)));
end

%The next section will create a matrix which each of the connected
%componets labeled with the interger value of the component. It will then
%have to use ismember of to determine how many pixels are in each
%component. After finding the components we can use the location of a
%feature to determine its component and therefore edge lenght (or number of
%pixels in the component).
numOfComp = 0;
for j = 1:i
    [CC(j), temp] = bwlabel(Rbw(:,:,j),8);
    numOfComp = numOfComp + temp;
end



%CC = bwconncomp(Rbw, 4)


figure;
imshow(CC(1));


end

