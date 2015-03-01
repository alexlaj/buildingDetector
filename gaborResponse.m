function R = gaborResponse(im)
    [n, m] = size(im);
    filtSize = 39;
    R = zeros(n+filtSize-1, m+filtSize-1, 6);
    for n=1:5
        R(:,:,n) = conv2(im, gaborFilter(n*pi/6, filtSize, filtSize));
    end
    