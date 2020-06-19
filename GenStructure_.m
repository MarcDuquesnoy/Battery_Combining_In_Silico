function [IM,IM_am]= GenStructure(comp,rmin_am,rmax_am,dim,res,divide,opt1,opt2,opt3,opt4,opt5)
Ntot = dim(1) * dim(2) * dim(3)* (res^-3); 
Nam  = Ntot * comp(1);
% disp('Generating AM coordinates & Slices ...')
IM = sampleSpheresV2_opti(dim,res,Nam,rmin_am,rmax_am,1);
IM_am = IM ; 
dim = size(IM) ;
N = dim(1) * dim(2) * dim(3) ;
N_dom = length(comp) - 2 ;
for j = 1 : divide
    for i = 1 : N_dom
        N_bis = comp(1+i) * N ;
        name_opt = ['opt',num2str(i)] ;
        opt = eval(name_opt) ;
        IM = AddSurf3(IM,round(N_bis/divide),opt.Id,opt.probaId,opt.probaAM,opt.method,opt.IdAM) ;
    end
end
