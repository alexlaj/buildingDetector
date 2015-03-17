function Response = gaborResponse(im)
    [n, m] = size(im);
    filtSize = 39;
    R = zeros(n +filtSize-1, m+filtSize-1, 6);
    for i=1:6
        R(:,:,i) = conv2(im, gaborFilter(i*pi/6, filtSize, filtSize));
    end
    Ro = R(1:n,1:m,:);
    lMax = zeros(n, m, 6);
    for i=1:6
        lMax(:,:,i) = imregionalmax(abs(Ro(:,:,i)),4);
    end
    Response = lMax.*Ro;
    