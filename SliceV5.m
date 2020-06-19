function [IMAGE, IMAGE_am , IMAGE_cbd] = SliceV5(center,radius,scale,sizeBox) 
if length(unique(radius)) == 1
    center_CBD = [] ; 
    radius_CBD = [] ;
    center_AM = center ;
    radius_AM = radius ;
else
    size_cbd = min(radius);
    row = find(radius== size_cbd) ;
    center_CBD = center(row,:) ;
    radius_CBD = radius(row) ;
    center_AM = center ;
    radius_AM = radius ;
    center_AM(row,:) = [] ;
    radius_AM(row,:) = [] ;
end
size_AM = length(radius_AM) ;

% [center_AM,radius_AM,Shift_Minus_X,Shift_Minus_Y]= Periodic_Condition_WIP_XY(center_AM,radius_AM,sizeBox) ; 
% IMAGE_am = Slice_WIP(center_AM,radius_AM,scale,sizeBox,Shift_Minus_X,Shift_Minus_Y) ; 
[center_AM1,radius_AM1,Shift_Minus_X1,Shift_Minus_Y1,Shift_Minus_Z1]= Periodic_Condition_XYZ(center_AM,radius_AM,sizeBox) ; 
[center_AM,radius_AM,Shift_Minus_X,Shift_Minus_Y,Shift_Minus_Z]= Periodic_Condition_XYZ(center_AM1(size_AM+1:end,:),radius_AM1(size_AM+1:end),sizeBox) ; 
center_AM = [center_AM1 + [Shift_Minus_X Shift_Minus_Y Shift_Minus_Z ]; center_AM] ; 
radius_AM = [radius_AM1 ; radius_AM] ; 
Shift_Minus_X = Shift_Minus_X1 + Shift_Minus_X ;
Shift_Minus_Y = Shift_Minus_Y1 + Shift_Minus_Y ;
Shift_Minus_Z = Shift_Minus_Z1 + Shift_Minus_Z ;
IMAGE_am  = Slice_V3(center_AM,radius_AM,scale,sizeBox,Shift_Minus_X,Shift_Minus_Y,Shift_Minus_Z) ; 
if isempty(center_CBD) == 0
[center_CBD,radius_CBD,Shift_Minus_X,Shift_Minus_Y,Shift_Minus_Z]= Periodic_Condition_XYZ(center_CBD,radius_CBD,sizeBox) ; 
IMAGE_cbd = Slice_V3(center_CBD,radius_CBD,scale,sizeBox,Shift_Minus_X,Shift_Minus_Y,Shift_Minus_Z) ; 
else 
    IMAGE_cbd = zeros(size(IMAGE_am)) ;
end
% [center_CBD,radius_CBD]= Periodic_Condition_WIP_XY(center_CBD,radius_CBD,sizeBox) ; 
% IMAGE_cbd = Slice_WIP(center_CBD,radius_CBD,scale,sizeBox) ;
% IMAGE_am = IMAGE_am(:,floor(scale*Shift_Minus_X1)+1:ceil(scale*(sizeBox(1)-Shift_Plus_X1)),:) ;

% [center_CBD,radius_CBD,Shift_Plus_X2,Shift_Minus_X2,sizeBox]= Periodic_Condition_WIP(center_CBD,radius_CBD,sizeBox) ; 
% IMAGE_cbd = Slice_WIP(center_CBD,radius_CBD,scale,sizeBox) ; 
% IMAGE_cbd = IMAGE_cbd(:,floor(scale*Shift_Minus_X2)+1:ceil(scale*(sizeBox(1)-Shift_Plus_X2)),:) ;
% 
% [r1,c1,n1] = size(IMAGE_cbd) ;
% [r2,c2,n2] = size(IMAGE_am) ;
% r = min(r1,r2) ; % In case the dimensions of AM and CBD only mismatch
% c = min(c1,c2) ; % In case the dimensions of AM and CBD only mismatch
% n = min(n1,n2) ; % In case the dimensions of AM and CBD only mismatch
% IMAGE = zeros(r,c,n) ; 
% IMAGE = 2*IMAGE_cbd(1:r,1:c,1:n) ; 
% IMAGE = IMAGE + IMAGE_am(1:r,1:c,1:n) ;

IMAGE = IMAGE_am + 2 * IMAGE_cbd ; 
IMAGE(IMAGE>2)=1;
end