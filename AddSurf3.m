function IM = AddSurf3(IM,N,Id,proba_Id,proba_AM,method,Id_AM,varargin)
tic
if unique(IM)==0
    error('The image is empty !! ')
    return
end
if nargin ==6
    Id_AM = 1 ; 
end
proba_Id = 1 - proba_Id ; 
proba_AM = 1 - proba_AM ; 
indPore = find(IM==0) ;
dim = size(IM) ;
NindPore = length(indPore) ;
i = 0 ;
pourcent = round((0.05:0.05:1)*N);
pourcentage = 5:5:100 ;
compteur = 1 ;
while i < N   
    if i > pourcent(compteur)
        message = [num2str(pourcentage(compteur)),' % ...'] ;
        disp(message)
        compteur = compteur + 1 ;
    end
    somme = 0 ;
    while somme==0
        temp = randi(NindPore); % index indPore
        ind = indPore(temp) ; % index IMAGE
        if IM(ind) == 0
            neighbors = findNeighboursSEI(ind,dim,26) ; % index IMAGE
            neighbors = neighbors(:,2) ;
            Id_neighbors = IM(neighbors);
            somme = sum(Id_neighbors) ;
        end
        if somme ~= 0
            if ismember(Id,Id_neighbors)==0
                somme = rand()< proba_Id ;
            elseif ismember(Id_AM,Id_neighbors)==0
                somme = rand()< proba_AM ;
            end
        end
    end
    if sum(method == 'pixel')==5
        N_void = 0 ; 
    elseif sum(method == 'voxel')==5
        Neighbors_void = find(IM(neighbors)==0) ; % index neighbors
        N_void = length(Neighbors_void);
        ind = [ind ; neighbors(Neighbors_void)] ;
    end
    IM(ind) = Id ;
    i = i + N_void + 1 ;
end