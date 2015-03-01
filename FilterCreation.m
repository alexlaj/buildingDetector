function [filter] = FilterCreation(filterSize)
%This function creates a matrix of filters for each orrienation.
%I was unsure how large of a filter to use so I though we could 
%experiment based on our zoom level of the image.

%f and sigma value taken from paper
f = 0.65;
sigmaG = 1.5;

%creating a commonly used variable to reduce calculation time
sigmaG2 = 1/(2*1.5^2);

%initlizing the gabour filter array
filter = cell(6);
n = filterSize;
m = n;

%first loop is for each orrientation of the filter
for i = 1:6
    theta = ((i-1)/6)*pi;
    subFilter = zeros(m,n);
    
    %created cos and sin values to reduce calculations
    cos1 = cos(theta);
    sin1 = sin(theta);
    
    %These loops create the filter for each orrientation using the equation
    %given in the paper.
    for x =1:m
        for y =1:n
            U = [(x)*cos1,(y)*sin1];
            V = [-(x)*sin1,(y)*cos1];
            subFilter(x,y) = (sigmaG2/pi)*exp(-((U.^2)*(V.^2)/sigmaG2))*exp(1i*2*pi*f*U);
        end
    end
    filter(i) = subFilter;

end

% Show magnitudes of Gabor filters:
figure('NumberTitle','Off','Name','Magnitudes of Gabor filters');
for i = 1:6      
    subplot(6);        
    imshow(abs(filter{i}),[]);
end

% Show real parts of Gabor filters:
figure('NumberTitle','Off','Name','Real parts of Gabor filters');
for i = 1:u
    subplot(u);        
    imshow(real(filter{i}),[]);   
end

