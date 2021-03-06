function lMax = gaborResponse(inIm)
	% Get the local maxima of the Gabor response in 6 different directions
	% for a given image.
    %
    % The actual Gabor responses are not used outside of this function and
    % so are not retunred.
    
    % Preallocate matricies
    [n, m] = size(inIm);
    lMax = zeros(n, m, 6);
    im = double(inIm);
    filtSize = 5;
    R = zeros(n+filtSize-1, m+filtSize-1, 6);
    % Get our 6 filtered images, each for a different direction
    for i=1:6
        R(:,:,i) = conv2(im, gaborFilter(i*pi/6, filtSize, filtSize));
    end
    % Crop to get rid of extra stuff from convolution
    R = R(1:n,1:m,:);
    % Find local maxima in each neighborhood
    for i=1:6
        lMax(:,:,i) = localMax(abs(R(:,:,i)));
    end
    
    % If you want to see the magnitude of the Gabor responses and the local
    % maxima just uncomment the plots below.
    
    % Plot Gabor Filter Responses
%     subplot(4,4,1), imshow(abs(R(:,:,1))), title('Abs Gabor, 0');
%     subplot(4,4,2), imshow(abs(R(:,:,2))), title('Abs Gabor, 1/6');
%     subplot(4,4,3), imshow(abs(R(:,:,3))), title('Abs Gabor, 2/6');
%     subplot(4,4,4), imshow(abs(R(:,:,4))), title('Abs Gabor, 3/6');
%     subplot(4,4,5), imshow(abs(R(:,:,5))), title('Abs Gabor, 4/6')
%     subplot(4,4,6), imshow(abs(R(:,:,6))), title('Abs Gabor, 5/6');
    % Plot Local Maxima
%     subplot(4,4,7), imshow(abs(lMax(:,:,1))), title('Local Max, 0');
%     subplot(4,4,8), imshow(abs(lMax(:,:,2))), title('Local Max, 1/6');
%     subplot(4,4,9), imshow(abs(lMax(:,:,3))), title('Local Max, 2/6');
%     subplot(4,4,10), imshow(abs(lMax(:,:,4))), title('Local Max, 3/6');
%     subplot(4,4,11), imshow(abs(lMax(:,:,5))), title('Local Max, 4/6');
%     subplot(4,4,12), imshow(abs(lMax(:,:,6))), title('Local Max, 5/6');
    % Plot Original Image
%    subplot(4,4,13), imshow(inIm), title('Original Image');
end
