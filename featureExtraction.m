function [F] = featureExtraction(I,R)
%This function takes in the 6 gabor filtered images and the oringinal image
%and it should return an image with extracted features on it
[n,m] = size(I)

%For the next line we need to compare each pixel with all other pixels that
%are within 4 pixels the current pixel. If it is the largest pixel then we
%save it as a local maximum. I am not sure what value is saved if the
%current pixel is a maximum though. A thought about approaching this was to
%create a new matrix disk of radis from the image and running max then
%comparing location.


%This will use Otsu's method to threshold the image
threshold = graythresh(Ro)
end

