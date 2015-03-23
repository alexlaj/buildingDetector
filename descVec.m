function [Edge, Color, Centroids] = descVec(cIm, lMax)
%This function will take in the gabour filters and create a descriptor
%vectors from it. The 4 by K matrix will have location, possible distance
%from the building center, and the orrientation. 
[n, m, i] = size(lMax);
features = zeros(n,m);
for j = 1:i
   features = features|lMax(:,:,j); 
end

%{
[row, col] = find(features);
[length, ~] = size(row);
decVect = zeros(length,4);

decVect(:,1) = row;
decVect(:,2) = col;
%}

%This section finds the length of each feature


[Color(:,:), numOfComp] = bwlabel(cIm(:,:),4);
arcLength = [1, numOfComp];
for n = 1:numOfComp
    arcLength(n) = nnz(Color(:,:)==n);
    if(arcLength(n)<70)
        Color(Color==n)=0;
        numOfComp= numOfComp - 1;
    end
end

[Edge(:,:), numOfComp2] = bwlabel(features(:,:),4);
arcLength2 = [1, numOfComp2];
for n = 1:numOfComp2
    arcLength2(n) = nnz(Edge(:,:)==n);
    if(arcLength2(n)<40)
        Edge(Edge==n)=0;
        numOfComp2= numOfComp2 - 1;
    end
end


%This section gets rid of features found in both images. This helps
%eliminate the roads as they are they have many stright lines and lots of
%edges. Not sure why but I had to redefine the size again... n and m from
%above did not work for some reason.

%SE = strel('square', 4);
%Edge = imerode(features,SE);
%Color = imerode(cIm,SE);

[n1, m1] = size(Color);
for x =1:n1
    for y = 1:m1
        if(Color(x,y) && Edge(x,y))
            Color(x,y)=0;
            Edge(x,y)=0;
        end
    end
end



sc = regionprops(Color,'centroid');
%sb = regionprops(Color,'BoundingBox')
Centroids = cat(1, sc.Centroid);
Centroids(~any(~isnan(Centroids), 2),:)=0;

%Perim = bwperim(Color);


%{
mask = [0 0 0 0 1 0 0 0 0;
        0 0 0 1 1 1 0 0 0;
        0 0 1 1 1 1 1 0 0;
        0 1 1 1 1 1 1 1 0;
        1 1 1 1 1 1 1 1 1;
        0 1 1 1 1 1 1 1 0;
        0 0 1 1 1 1 1 0 0;
        0 0 0 1 1 1 0 0 0;
        0 0 0 0 1 0 0 0 0];
for x =1:n1
    for y = 1:m1
        if(Edge(x,y))
            
        end
    end 
end
%}    

%{
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
%}

%maxarc = max(decVect(:,3));

figure
imshow(Edge);
title(['All feature from lMax'])

figure
imshow(Color)
title(['All feature from Colour'])


figure
imshow(cat(3, Color, Edge, Edge));
hold on
plot(Centroids(:,1),Centroids(:,2), 'b*')
title(['lMax in Cyan, Colour in Red'])
hold off
end

