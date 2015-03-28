function [segmentedImage] = colourSeg(im)
    % Returns a matrix of local maxima found in an area with an eucludian
    % radius of 4.
    cThresh = 0.1;
    gThresh = 1.08;
    [n, m, ~] = size(im);
    segmentedImage = zeros([n m]);
    %mask = [0 0 0 0 1 0 0 0 0;
    %        0 0 0 1 1 1 0 0 0;
    %        0 0 1 1 1 1 1 0 0;
    %        0 1 1 1 1 1 1 1 0;
    %        1 1 1 1 1 1 1 1 1;
    %        0 1 1 1 1 1 1 1 0;
    %        0 0 1 1 1 1 1 0 0;
    %        0 0 0 1 1 1 0 0 0;
    %        0 0 0 0 1 0 0 0 0];
    mask = ones([9 9]);
    mask = logical(mask);
    tmpMask = zeros([n m]);
    % 1s are with a ecludian radius of 4 of the center pixel
    local = zeros([9 9]);
    % Boundary conditions
    
    % For each pixel far enough away from the boundary
    for x = 1:n
        for y = 1:m
            tmpMask = mask;
            % Get the 9x9 matrix surrounding it
            % Get neighborhood from image matrix
            sX = max(1,x-4);
            eX = min(9+sX,n);
            sY = max(1,y-4);
            eY = min(9+sY,m);
            localR = im(sX:eX, sY:eY,1);
            localG = im(sX:eX, sY:eY,2); 
            localB = im(sX:eX, sY:eY,3); 
            % This IF chain is to handle the border pixles. If the mask
            % would fall outside the border of the image it does not check
            % those pixels. When reading this remember that x,y is our center
            % pixel and so the mask extends 4 pixels on each side of x,y
            if x-4<1
                sX = 5-x;
            else
                sX = 1;
            end
            if x+4>n
                eX = 9-(x+4-n);
            else
                eX = 9;
            end
            if y-4<1
                sY = 5-y;
            else
                sY = 1;
            end
            if y+4>m
                eY = 9-(y+4-m);
            else
                eY = 9;
            end
            % Here we crop the mask
            tmpMask = mask(sX:eX, sY:eY);
            % And now logical indexing to get an array of values where the
            % mask was 1.
            localR = localR(tmpMask);
            localG = localG(tmpMask);
            localB = localB(tmpMask);
            nn = size(localR);
            red = im(x,y,1);
            green = im(x,y,2);
            blue = im(x,y,3);
            cnt = 0;
            % Try to remove green
            % Checks if G is a percentage higher than R and B
            if im(x,y,2) > im(x,y,1)*gThresh && im(x,y,2) > im(x,y,3)*gThresh 
                segmentedImage(x,y) = 0; 
            % If pixel is completely black do not count as a segment 
            % This is mostly for the second run through 
            elseif im(x,y,1)==0 && im(x,y,2)==0 && im(x,y,3)==0 
                segmentedImage(x,y) = 0; 
            else
                for xx = 1:nn
                    if (localR(xx)<(red+cThresh*red)) && (localR(xx)>(red-cThresh*red)) && (localG(xx)<(green+cThresh*green)) && (localG(xx)>(green-cThresh*green)) && (localB(xx)<(blue+cThresh*blue)) && (localB(xx)>(blue-cThresh*blue))
                        cnt = cnt+1;
                    else
                        cnt = cnt-1;
                    end
                end
                if cnt>2
                    segmentedImage(x,y) = 1;
                else
                    segmentedImage(x,y) = 0;
                end
            end
        end
    end
    