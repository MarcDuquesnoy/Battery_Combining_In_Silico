function ratio = Contact_pixel(im,id1,id2)
% Determine the ratio between number pixel 1 in contact with 2 divided by
% number of pixel 1 
    list1 = find(im == id1) ; 
    N = length(list1) ; 
    NeighboursInd = findNeighboursMat26(list1',size(im)) ; 
    unik = unique(NeighboursInd(:,2));
    ind1 = find(im(unik) == id2) ;
    N1 = length(ind1) ; 
    ratio = N1 * 100 / N ; 
end
