function [ c, r ] = randomSphere2( dims,rmin,rmax,alpha,distrib)
% creating one sphere at random inside [0..dims(1)]x[0..dims(2)]x...
% In general cube dimension would be 10mm*10mm*10mm
% radius and center coordinates are sampled from a uniform distribution
% over the relevant domain.
%
% output: c - center of sphere (vector cx, cy,... )
%         r - radius of sphere (scalar)
if rmin == 0
    r = distrib(find(distrib(:,2)>rand(),1),1) ; 
else
    r = rmin + ( rmax - rmin) .* rand(1);% radius varies between 0.15mm - 0.55mm
end
    c = bsxfun(@times,(dims - alpha*r) , rand(1,3)) + r; % to make sure sphere is placed inside the cube

end