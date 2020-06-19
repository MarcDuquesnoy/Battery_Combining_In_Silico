function [centers, rads] = sampleSpheres( dims,V,rmin,rmax,res,distrib,verbosity,beta,varargin)
% main function which is to be called for adding multiple spheres in a cube
% dims is assumed to be a row vector of size 1-by-ndim
% For demo take dims = [ 2 2 2 ] and n = 50

% preallocate
if nargin == 7
    beta = 0.8 ; 
end
v = 0 ; 
ndim = numel(dims);
n = round(1.5*V / ((4*pi*((rmax+rmin)/2)^3)/3)) ;
centers = zeros( n, ndim );
rads = zeros( n, 1 );
ii = 1;
while v < V
    [centers(ii,:), rads(ii) ] = randomSphere2( dims,rmin,rmax,1,distrib );
    if nonOver2( centers(1:ii,:), rads(1:ii),beta )
        v = v + (4*pi*rads(ii)^3)*(round(1/res)^3)/(3) ;
        ii = ii + 1; % accept and move on
        if verbosity == 1
            100*v/V
        end
     end
end
centers = centers(~all(centers == 0, 2),:);
rads = rads(~all(rads == 0, 2),:);
end