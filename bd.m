function oIm = bd(inImFile)
    % Main function for the building detector.
    % Takes in a screenshot of google maps satellite image and searches for
    % buildings in it.
    
    % Tentative steps
    % 1. Get image into greyscale
    % 2. Preprocess image with 5x5 median image filter
    % 3. Process image with Gabor filters in multiple directions (6?)
    %   - Take filter response for each direction
    %       - Find local maxima using threshold from Otsu's algorithm
    % 4. Create description vectors of the form Fk = ((xk,yk), Lk, Bk)
    %   - (xk, yk) is the location of the feature
    %   - Lk is the possible distance to the building's center
    %       - apply Otsu to the magnitude of the Gabor filter response
    %       - Connect group threshold pixels
    %       - Calc edge length
    %   - Bk is direction of feature
    %       - Calc using orientation of Gabor filter which generated
    %         feature at (xk, yk).
    % 5. Do stuff with the description vectors. Need to read paper more to
    %    figure out this part.
    
    % 1. Greyscale
    origIm = imread(inImFile);
    [n, m, z] = size(origIm);
    if (z == 3)
        gIm = rgb2gray(origIm);
    else
        gIm = origIm;
    end
    
    % 2. 5x5 Median filter. Takes median of pixels in 5x5 grid around
    %    center pixel and sets center pixel to that value.
    gIm = medfilt2(gIm, [5 5]);
    
    % 3. Gabor filtering
    % Make separate m file for this function.
    % myGabor(image, direction)
    % I think that central frequency and scale parameter should be
    % hardcoded in like they were in the paper. They may have to be
    % adjusted for our image set.