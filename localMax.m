function lMax = localMax(im)
    % Returns a matrix of local maxima found in an area with an eucludian
    % radius of 4 around each point.
    
    % For every pixel, check all pixels with an ecludian radius of 4 to see
    % if the current pixel is a local maxima. This function uses a mask to
    % find all pixels within an ecludian distance of 4.
    
    % This function also formed the basis for the colourSeg function used
    % in the building detector, so they will look similar.
    
    thresh = 0.3*max(max(im));
    [n, m] = size(im);
    lMax = zeros([n m]);
    mask = [0 0 0 0 1 0 0 0 0;
            0 0 0 1 1 1 0 0 0;
            0 0 1 1 1 1 1 0 0;
            0 1 1 1 1 1 1 1 0;
            1 1 1 1 1 1 1 1 1;
            0 1 1 1 1 1 1 1 0;
            0 0 1 1 1 1 1 0 0;
            0 0 0 1 1 1 0 0 0;
            0 0 0 0 1 0 0 0 0];
    mask = logical(mask);
    tmpMask = zeros([n m]);
    % 1s are with a ecludian radius of 4 of the center pixel
    local = zeros([9 9]);
    % Boundary conditions
    
    % For every pixel
    for x = 1:n
        for y = 1:m
            tmpMask = mask;
            % Get the 9x9 matrix surrounding the current pixel. Have to
            % adjust the mask for the pixels near the edge of the image.
            sX = max(1,x-4);
            eX = min(9+sX,n);
            sY = max(1,y-4);
            eY = min(9+sY,m);
            local = im(sX:eX, sY:eY);           
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
            local = local(tmpMask);
            % See if the max is larger than the current pixel. If a pixel
            % is a local maxima, set it to 0, otherwise set the pixel to 1.
            if max(local) > (im(x,y) + thresh)
                lMax(x,y) = 1;
            else
                lMax(x,y) = 0;
            end
        end
    end
