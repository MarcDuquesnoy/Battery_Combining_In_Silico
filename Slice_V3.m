function IMAGE = Slice_V3(center,radius,scale,sizeBox,Shift_Minus_X,Shift_Minus_Y,Shift_Minus_Z) 
alpha = 15 ; 
Shift = alpha * scale ; 
sizeBox = sizeBox + 2*alpha ; 
center = center + alpha ; 
Zlim = [center(:,3)- radius center(:,3) + radius] ; 
minZ  = 0 ; 
maxZ = sizeBox(3);
maxY = sizeBox(2) ;
maxX = sizeBox(1); 

intX = maxX ; 
intY = maxY ; 

imageSizeX = floor(scale * intX) ;
imageSizeY = floor(scale * intY) ;
imageSizeZ = floor(scale * (maxZ-minZ)); 
[columnsInImage,rowsInImage ] = meshgrid(1:imageSizeX, 1:imageSizeY);

IMAGE = zeros(imageSizeY,imageSizeX,imageSizeZ ) ; 

Zcut = minZ : (maxZ-minZ)/(imageSizeZ-1) : maxZ ; 

for i = 1 : length(Zcut)
    Indx = find(Zlim(:,1)<Zcut(i) & Zlim(:,2)> Zcut(i)) ;
    deltaZ = abs(Zcut(i)-center(:,3));
    Radius = floor(sqrt((radius(Indx).^2 - (deltaZ(Indx).^2)))*scale);
    Center = floor(center(Indx,:)*scale) ;
    for k = 1 : length(Indx)  
        circlePixels = (rowsInImage - Center(k,2)).^2 + (columnsInImage - Center(k,1)).^2 <= Radius(k).^2;
        IMAGE(:,:,i) = IMAGE(:,:,i) + circlePixels;
    end
end
IMAGE = IMAGE( round(scale*Shift_Minus_Y)+Shift+1 : end-Shift+round(scale*Shift_Minus_Y), ...
               round(scale*Shift_Minus_X)+Shift+1 : end-Shift+round(scale*Shift_Minus_X), ...
               round(scale*Shift_Minus_Z)+Shift+1 : end-Shift+round(scale*Shift_Minus_Z) ) ; 
IMAGE(IMAGE>1)=1;
end