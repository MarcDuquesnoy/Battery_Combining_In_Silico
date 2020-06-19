function [ center,radius,Shift_Minus_X,Shift_Minus_Y,Shift_Minus_Z]= Periodic_Condition_XYZ(center,radius,sizeBox)
minX = min(center(:,1)-radius) ; 
if minX <0
    minX = 0 ;
end
minY = min(center(:,2)-radius) ; 
if minY <0
    minY = 0 ;
end
minZ = 0 ; 
a1X = sizeBox(1)-(center(:,1)+radius) ; % X+
a2X = (center(:,1)-radius) ; % X-
rowX1 = find(a1X<0); % X+
rowX2 = find(a2X<0); % X-
[Shift_Minus_X,~] = max(sizeBox(1)-center(rowX1,1)) ;
if isempty(Shift_Minus_X) == 1
    Shift_Minus_X = 0 ;
end

a1Y = sizeBox(2)-(center(:,2)+radius) ; % Y+
a2Y = (center(:,2)-radius) ; % Y-
rowY1 = find(a1Y<0); % Y+
rowY2 = find(a2Y<0); % Y-
[Shift_Minus_Y,~] = max(sizeBox(2)-center(rowY1,2)) ;
if isempty(Shift_Minus_Y) == 1
    Shift_Minus_Y = 0 ;
end
a1Z = sizeBox(3)-(center(:,3)+radius) ;
a2Z = (center(:,3)-radius) ; 
rowZ1 = find(a1Z<0); % X+
rowZ2 = find(a2Z<0); % X-
[Shift_Minus_Z,~] = max(sizeBox(3)-center(rowZ1,3)) ;
if isempty(Shift_Minus_Z) == 1
    Shift_Minus_Z = 0 ;
end

%% Refresh Zlim/center/radius
sizeBox(1) = sizeBox(1) +  Shift_Minus_X ;
center(:,1) = center(:,1) + Shift_Minus_X ;
sizeBox(2) = sizeBox(2) +  Shift_Minus_Y ;
center(:,2) = center(:,2) + Shift_Minus_Y ;
sizeBox(3) = sizeBox(3) +  Shift_Minus_Z ;
center(:,3) = center(:,3) + Shift_Minus_Z ;
new_radius = radius([rowX1 ; rowX2 ; rowY1 ; rowY2 ; rowZ1 ; rowZ2]) ;
center_X1 = [Shift_Minus_X- (sizeBox(1)-center(rowX1,1)) center(rowX1,2:3)] ; 
center_X2 = [ sizeBox(1)+ center(rowX2,1)-Shift_Minus_X center(rowX2,2:3)] ; 
center_Y1 = [center(rowY1,1) Shift_Minus_Y-(sizeBox(2)-center(rowY1,2)) center(rowY1,3)] ; 
center_Y2 = [center(rowY2,1)  sizeBox(2)+ center(rowY2,2)-Shift_Minus_Y center(rowY2,3)] ; 
center_Z1 = [center(rowZ1,1:2) Shift_Minus_Z-(sizeBox(3)-center(rowZ1,3)) ] ; 
center_Z2 = [center(rowZ2,1:2)  sizeBox(3)+ center(rowZ2,3)-Shift_Minus_Z ] ; 
new_center = [center_X1 ; center_X2 ; center_Y1 ; center_Y2 ; center_Z1 ; center_Z2] ; 
center = [center ; new_center ] ; 
radius = [radius ; new_radius ] ;
end