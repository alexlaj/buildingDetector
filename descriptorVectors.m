function [decVect CC] = descriptorVectors( R, lMax)
%This function will take in the gabour filters and create a descriptor
%vectors from it. The 4 by K matrix will have location, possible distance
%from the building center, and the orrientation. 
[n, m, i] = size(lMax);
features = zeros(n,m);
for j = 1:i
   features = features|lMax(:,:,j); 
end

[row, col] = find(features);
[length, ~] = size(row);
decVect = zeros(length,4);

decVect(:,1) = row;
decVect(:,2) = col;


%This section finds the length of each feature

Rmag = abs(R);
Rbw = zeros(n,m,i);
for j = 1:i
    Rbw(:,:,j) = im2bw(Rmag(:,:,j),(graythresh(Rmag(:,:,j))));
end
Rbw(:,:,:) = ~Rbw(:,:,:);
figure
imshow(Rbw(:,:,1))
title(['Connected Comp. Length aka shadow'])
%The next section will create a matrix which each of the connected
%componets labeled with the interger value of the component. It will then
%have to use ismember of to determine how many pixels are in each
%component. After finding the components we can use the location of a
%feature to determine its component and therefore edge lenght (or number of
%pixels in the component).
numOfComp = zeros(i,1);
for j = 1:i
    [CC(:,:,j), numOfComp(j,1)] = bwlabel(Rbw(:,:,j),4);
end

arcLength = zeros(length,i);
for j = 1:i
    for n = 1:numOfComp
        arcLength(n,j) = nnz(CC(:,:,j)==n);
    end
end

for n =1:length
    arc = 0;
    rowVect = decVect(n,1);
    colVect = decVect(n,2);
    for j = 1:i
        if (CC(rowVect,colVect,j)~= 0)
            arc = arc + arcLength((CC(rowVect,colVect,j)),j);
        end
    end
    decVect(n,3) = arc;
end
maxarc = max(decVect(:,3));

figure
imshow(features);
title(['All feature from lMax'])

figure
imshow(lMax(:,:,1))
title([ 'Features with Arclength greater than 0'])
hold on;
for n =1:length
   if(decVect(n,3)>(0.01*maxarc))
     plot(decVect(n,2),decVect(n,1),'r');
   end
end


end

