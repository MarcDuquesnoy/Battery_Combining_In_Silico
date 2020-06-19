function Im = sampleSpheresV2_opti(dims,res,N,rmin,rmax,verbosity )
% main function which is to be called for adding multiple spheres in a cube
% dims is assumed to be a row vector of size 1-by-ndim
% For demo take dims = [ 2 2 2 ] and n = 50

% preallocate
alpha = 1 ;
beta = 0.7 ;
distrib = [1 1] ;
% ndim = numel(dims);
% L = round(1.5*V / ((4*pi*((rmax+rmin)/2)^3)/3)) ;
% centers = zeros( n, ndim );
% rads = zeros( L, 1 );
ii = 1;
if rmin == 0
    A = load('Distribution_diameter_emi_nmc111.dat') ;
    A(A>9) = [] ;
    A = A ./ 2 ;
    B = 0.75:0.25:round(max(A));
    [~,I] = min(abs(bsxfun(@minus,A',B')));
    Anew = B(I);
    unik_R = unique(Anew) ;
    last = 0 ;
    for i = 1 : length(unik_R)
        distrib(i,:) = [ unik_R(i) (last + (sum(Anew == unik_R(i))/length(Anew)))] ;
        last = distrib(i,2);
    end
end
[centers, rads ] = sampleSpheres(dims,round((1+res/3)*N),rmin,rmax,res,distrib,verbosity,beta);
Im = SliceV5(centers,rads,round(1/res),dims) ;
n = length(find(Im==1)) ;
ii = size(centers,1) + 1; % accept and move on

while n < N
    [centers(ii,:), rads(ii) ] = randomSphere2(dims,rmin,rmax,alpha,distrib );
    if nonOver2( centers(1:ii,:), rads(1:ii),beta )
        temp_im = SliceV5(centers(ii,:),rads(ii),round(1/res),dims) ;
        Im = Im + temp_im ;
        Im(Im > 1) = 1 ;
        n = length(find(Im==1)) ;
        ii = ii + 1; % accept and move on
        if verbosity == 1
            100*n/N
        end
    end
end
Im(Im > 1) = 1 ;

centers = centers(~all(centers == 0, 2),:);
rads = rads(~all(rads == 0, 2),:);
end