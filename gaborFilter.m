function G = gaborFilter(dir, n, m)
    % Creates a Gabor filter for a given direction and matrix size.
    f = 0.65;
    sigG = 2.5;
    G = zeros([n m]);
    for x=1:n
        for y=1:m
            U = x*cos(dir)+y*sin(dir);
            V = -x*cos(dir)+y*cos(dir);
            G(x,y) = 1/(2*pi*sigG^2)*exp(-(U^2+V^2)/(2*sigG^2))*exp(1i*2*pi*f*U);
        end
    end
    
