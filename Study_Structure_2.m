function [tortuosity_electrolyte,tortuosity_AM,tortuosity_solid,Percentage_CC_AM,Percentage_CC_CBD,Percentage_Sep_electrolyte,active_surface,IM] = Study_Structure_2(N,compo,rmin_am,rmax_am,dimension,res,divide,opt1)
% sigma_eff = sigma_bulk * proosity / tortuosity^2 ?
% Ref R.B. MacMullin, G.A. Muccini: 'Characteristics of porous beds and structures', AIChE J.', 1956, 2, (3), 393–403.21.
% D. Djian, F. Alloin, S. Martinet, H. Lignier, J.Y. Sanchez: 'Lithium-ion batteries with high charge rate capacity: Influence of the porous separator', J. Power Sources', 2007, 172, (1), 416–421.22.
% M.J. Martínez, S. Shimpalee, J.W. Van Zee: 'Measurement of MacMullin Numbers for PEMFC Gas-Diffusion Media', J. Electrochem. Soc.', 2009, 156, (1), B80.23.
% J. Landesfeind, J. Hattendorff, A. Ehrl, W.A. Wall, H.A. Gasteiger: 'Tortuosity Determination of Battery Electrodes and Separators by Impedance Spectroscopy', J. Electrochem. Soc.', 2016, 163, (7), A1373.

FindTau = 1 ;
FindMetrics = 0 ;
RVAmode = 0 ;
PhaDir1 = [ 0 0 1 ; 0 0 0 ; 0 0 0  ] ;
PhaDir2 = [ 0 0 0 ; 0 0 0 ; 0 0 1  ] ;
PhaDir3 = [ 0 0 0 ; 0 0 1 ; 0 0 0  ] ;
tortuosity_solid = [] ;
tortuosity_electrolyte = [] ;

VoxDims = [ 1 1 1] ;
for j = 1 : size(compo,1)
    tortuosity_el = 0 * ones(N,1) ;
    tortuosity_sol = 0 * ones(N,1) ;
    pourcentage = j*100/size(compo,1) ; 
    disp([num2str(pourcentage),' % ...'])
    for i = 1 : N
        im = GenStructure_(compo(j,:),rmin_am,rmax_am,dimension(j,:),res,divide,opt1) ;
        Results = TauFactor('InLine',FindTau,FindMetrics,RVAmode,im,PhaDir1,VoxDims);
        a =  fieldnames(Results) ;
        b = Results.(a{1}) ;
        if isstruct(b) == 1
            tortuosity_el(i) = Results.Tau_B3.Tau ;
        end
        Results = TauFactor('InLine',FindTau,FindMetrics,RVAmode,im,PhaDir3,VoxDims);
        a =  fieldnames(Results) ;
        b = Results.(a{1}) ;
        if isstruct(b) == 1
            tortuosity_am(i) = Results.Tau_G3.Tau ;
        end
        CC_AM(i) = 100*sum(sum(im(:,:,1)==1)) / (size(im,1) * size(im,2) ) ;
        CC_CBD(i) = 100*sum(sum(im(:,:,1)==2)) / (size(im,1) * size(im,2) ) ;
        IM = im ;
        im(im==2) = 1 ;
        Results = TauFactor('InLine',FindTau,FindMetrics,RVAmode,im,PhaDir2,VoxDims);
        a =  fieldnames(Results) ;
        b = Results.(a{1}) ;
        if isstruct(b) == 1
            tortuosity_sol(i) = Results.Tau_W3.Tau ;
        end
        
        Sep_electrolyte(i) = 100*sum(sum(im(:,:,end)==0)) / (size(im,1) * size(im,2) ) ;
        activ_surface(i) = Contact_pixel(im,1,0) ; 
    end
    tortuosity_electrolyte(j,:) = tortuosity_el;
    tortuosity_AM(j,:) = tortuosity_am;
    tortuosity_solid(j,:) = tortuosity_sol;
    Percentage_CC_AM(j,:) = CC_AM ;
    Percentage_CC_CBD(j,:) = CC_CBD ;
    Percentage_Sep_electrolyte(j,:) = Sep_electrolyte ;
    active_surface(j,:) = activ_surface ; 
end
end
