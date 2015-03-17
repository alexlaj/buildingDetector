function [ features ] = descriptorVectors( R, lMax)
%This function will take in the gabour filters and create a descriptor
%vectors from it. The 4 by K matrix will have location, possible distance
%from the building center, and the orrientation. 
[n, m, i] = size(lMax);
features = zeros(n,m);
for j =1:i
    features = imfuse(lMax(:,:,j),features);
end
figure;
imshow(features)
%Finds maximum number of features, may create to many if lots of features
%have two orientations. Can change later, just helps to allocate
%vectors = nnz(lMax);

%prealocats descriptor vectors with zeros
%decVect = zeros(4,vectors);



%The below code fills in the location of all the gabour features which can
%then be used to find orrientation and edge length


%This section finds the length of each feature

Rmag = abs(R);
for j = 1:i
    Rbw = im2bw(Rmag(:,:,j),graythresh(Rmag(:,:,j)));
end

CC = bwconncomp(Rbw);

end

