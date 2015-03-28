function [Edge, Color, intCenter, Vote] = descVec(cIm, lMax)
%This function will take in the gabour filters and create a descriptor
%vectors from it. The 4 by K matrix will have location, possible distance
%from the building center, and the orrientation. 
[n, m, i] = size(lMax);
features = zeros(n,m);
for j = 1:i
   features = features|lMax(:,:,j); 
end

% Dilate cIm and and it with lMax to try and remove some junk from gabor
% filtering.
nhood = ones([13 13]);
se = strel('arbitrary',nhood);
tmpcIm = imdilate(cIm,se);
features = tmpcIm & features;

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
    if(arcLength(n)<80 || arcLength(n)>4000)
        Color(Color==n)=0;
        numOfComp= numOfComp - 1;
    end
end

[Edge(:,:), numOfComp2] = bwlabel(features(:,:),4);
arcLength2 = [1, numOfComp2];
for n = 1:numOfComp2
    arcLength2(n) = nnz(Edge(:,:)==n);
    if(arcLength2(n)<40)% || arcLength2(n)>2000)
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

intCenter = round(Centroids(:,:));
intCenter(all(intCenter==0,2),:)=[];
[Centers, ~] = size(intCenter);
Vote = zeros(Centers,1);
for t = 1:Centers
    if(Color(intCenter(t,2),intCenter(t,1)))
       num = Color(intCenter(t,2),intCenter(t,1)); 
       Object = (Color==num);
       SE = strel('square', 5);
       IM2 = imdilate(Object,SE);
       Vote(t,1) = nnz(IM2&Edge);
    else
       %intCenter(t,:)=[];
    end
end
%}
figure
imshow(Edge);
title(['All feature from lMax'])

figure
imshow(Color)
title(['All feature from Colour'])

%figure
%imshow(combineIndex)
%title(['should combine'])

figure
imshow(cat(3, Color, Edge, Edge));
hold on
for i = 1:Centers
    if(Vote(i,1)>=10)
        plot(intCenter(i,1),intCenter(i,2), 'b*')
    end
end
title(['lMax in Cyan, Colour in Red'])
hold off
end