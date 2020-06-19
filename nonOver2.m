function not_ovlp = nonOver2( centers, rads,beta ) % to make sure spheres do not overlap

if numel( rads ) == 1
    not_ovlp = true;
    return; % nothing to check for a single or the first sphere
end
center_dist = sqrt(sum((centers(1:end-1,:)-centers(end,:)).^2,2)) ; 
% center_dist = sqrt(sum(bsxfun(@minus,centers(1:end-1,:),centers(end,:)).^2,2));
radsum = rads(end) + rads(1:end-1);
not_ovlp = all(center_dist >= radsum*beta);
return;
end