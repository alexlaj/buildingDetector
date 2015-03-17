function lMax = localMax(im)
    [n, m] = size(im);
    lMax = zeros([n m]);
    for x=1:n
        for y=1:m
            curMax = im(x,y);
            factor = curMax*0.1;
            % Check the pixel to the right
            if (x < n-1)
                if (curMax < im(x+1,y))
                    curMax = im(x+1,y);
                end
            end
            % Check the pixel up
            if (y > 1)
                if (curMax < im(x,y-1))
                    curMax = im(x,y-1);
                end
            end
            % Check the pixel to the left
            if (x > 1)
                if (curMax < im(x-1,y))
                    curMax = im(x-1,y);
                end
            end
            % Check the pixel down
            if (y < m-1)
                if (curMax < im(x,y+1))
                    curMax = im(x,y+1);
                end
            end
            % If it's not the max, set to white
            if (abs(curMax - im(x,y)) < factor)
                curMax = 0;
            end
            lMax(x,y) = curMax;
        end
    end