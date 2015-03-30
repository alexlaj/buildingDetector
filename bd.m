function [Edge, Color, Centroids, Centers] = bd(inImFile)
    tic
    % Main function for the building detector.
    % Takes in a screenshot of a satellite image and searches for
    % buildings in it. Outputs the original image with buildings it finds
    % marked.
    % 
    % Overview of steps
    % 1. Make a greyscale copy of the image
    % 2. Run the colour image through colour segmentation twice
    % 3. Run the greyscale image through a 5x5 median filter
    % 4. Get the local maxima from the gabor response of the greyscale image
    % 5. Generate description vectors and mark buildings
    
    
    % 1. Greyscale
    origIm = imread(inImFile);
    [n, m, z] = size(origIm);
    
    estRunTime = 0.0002*n*m-7.8363;
    disp('Estimated runtime in seconds: ')
    disp(estRunTime)
    if (z == 3)
        gIm = rgb2gray(origIm);
    else
        gIm = origIm;
    end
    
    % 2. Colour segmentation
    disp('Starting first round of colour segmentation...')
    cIm = colourSeg(origIm);
    cIm = uint8(cIm);
    tmp(:,:,1) = cIm.*origIm(:,:,1);
    tmp(:,:,2) = cIm.*origIm(:,:,2);
    tmp(:,:,3) = cIm.*origIm(:,:,3);
    disp('Starting second round of colour segmentation...')
    cIm = colourSeg(tmp);
    
    % 3. 5x5 Median filter. Takes median of pixels in 5x5 grid around
    % center pixel and sets center pixel to that value.
    disp('Starting median filtering...')
    gIm = medfilt2(gIm, [5 5]);
    
    % 4. Gabor filtering
    disp('Starting Gabor filtering...')
    lMax = gaborResponse(gIm);

    % 5. Generate description vectors
    disp('Finding building centers...')
    [Edge, Color, Centroids, Vote] = descVec(cIm, lMax);
    [Centers, ~] = size(Centroids);
    
    % Plot original image with buildings marked
    disp('Plotting results...')
    figure
    imshow(origIm);
    hold on
    for i = 1:Centers
        if(Vote(i,1)>=10)
            plot(Centroids(i,1),Centroids(i,2), 'r+')
        end
    end
    title(['Buildings marked with a red +'])
    hold off
    disp('All done!')
    toc
    end
