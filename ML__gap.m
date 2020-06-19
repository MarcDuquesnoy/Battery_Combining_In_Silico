function[tortuosity_electrolyte,tortuosity_solid,Percentage_CC_AM,Percentage_CC_CBD,Percentage_Sep_electrolyte,IM] = ML__gap(porosity,N,gap,compo,rmin_am,rmax_am,dimension,res,divide,opt2,filename)
% for i = 1 : length(compo)
%     xname{i} = [num2str(compo(i,1)),'/',num2str(compo(i,2))] ; 
% end

ratio_mass = (compo(:,1)*0.95) ./ (compo(:,2)*4.65) ; 
new_porosity = []; 
Ncompo = size(compo,1) ; 
COMPO = [] ;
for i = 1 : Ncompo
    COMPO = [COMPO ; repmat(compo(i,:),length(porosity),1)] ; 
end
COMPO = repmat(COMPO,length(gap),1) ;
GAP = [] ; 
for i = 1 : length(gap)
    GAP = [GAP; repmat(gap(i),Ncompo*length(porosity),1)];
end
for k = 1 : length(gap)
    for i = 1 : Ncompo
        temp1 = 0.843501332857.*compo(i,1)/100 - 0.723464511643 * porosity./100 -  0.001324143727*dimension(1,3) ...
                - 0.003060811370 *gap(k) + 0.000005836202  * gap(k)^2 + 0.007198782820 * porosity./100.*gap(k) ; 
        new_porosity = [new_porosity ; temp1.*100] ; 
    end
end
dimension = repmat(dimension,length(new_porosity),1) ;  

POROSITY = repmat(porosity,Ncompo*length(gap),1) ;  

dimension(:,3) = (1-(POROSITY - new_porosity)./100) .* dimension(1,3) ; 
solid_volume = 100 - new_porosity ; 
compo = []; 
Ratio_mass = [] ; 
for i = 1 : length(ratio_mass)
    Ratio_mass = [Ratio_mass ; repmat(ratio_mass(i,:),length(porosity),1)] ; 
end
ratio_mass = repmat(Ratio_mass,length(gap),1) ; 
for i = 1 : length(new_porosity)
    compo = [ 100*compo ; solid_volume(i)-solid_volume(i) ./ (ratio_mass+1) solid_volume(i)./ (ratio_mass+1) new_porosity(i)*ones(size(ratio_mass)) ]./100; 
end
compo = [ solid_volume-solid_volume ./ (ratio_mass+1) solid_volume./ (ratio_mass+1) new_porosity.*ones(size(ratio_mass)) ]./100; 

[tortuosity_electrolyte,tortuosity_am,tortuosity_solid,Percentage_CC_AM,Percentage_CC_CBD,Percentage_Sep_electrolyte,active_surface,IM] = Study_Structure_2(N,compo,rmin_am,rmax_am,dimension,res,divide,opt2) ;
Matrix2write = [] ; 
for i = 1 : size(compo,1)
    Matrix2write = [Matrix2write ;repmat(GAP(i),N,1,1) repmat(COMPO(i,:),N,1,1) repmat(POROSITY(i,:),N,1,1) repmat(dimension(i,:),N,1,1) repmat(res,N,1,1) ...
                      tortuosity_electrolyte(i,:)' tortuosity_am(i,:)' tortuosity_solid(i,:)' Percentage_CC_AM(i,:)' Percentage_CC_CBD(i,:)' Percentage_Sep_electrolyte(i,:)' repmat(new_porosity(i,:),N,1,1) active_surface(i,:)']; 
end

fp = fopen(filename,'wt');
fprintf(fp,'# Created for ERC/ARTISTIC Project (https://www.u-picardie.fr/erc-artistic)\n');
fprintf(fp,'# Gap\tAM\tCBD\tporous\tx\ty\tz\tres\ttliq\ttam\ttsol\tCC/AM\tCC/CBD\tEl/Sep\toutput_porosity\tActive Surface\n'); 
dlmwrite(filename,Matrix2write,'delimiter','\t','precision',3,'-append')
fclose(fp) ; 
end
