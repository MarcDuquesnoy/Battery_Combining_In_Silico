%% MAIN SCRIPT 
% To operate, please launch the App TauFactor first. 
% Download here: https://fr.mathworks.com/matlabcentral/fileexchange/57956-taufactor

%% Parameters for the CBD generation algorithm
clear opt1 
opt1.Id = 2 ;  % Id of the CBD which will be added to the spherical active material particles. 
opt1.probaId = 0.5 ; % Number between 0 and 1. The closer it is to 1, the more cluster-like the CBD will be.  
opt1.probaAM = 0.5 ; % Number between 0 and 1. The closer it is to 1, the more film-like the CBD will be.
opt1.method = 'pixel' ; % Either 'pixel' or 'voxel', set if CBD is to be added pixel per pixel or voxel per voxel. 
opt1.IdAM = 1 ; % Specify the Id of the spherical active material particles. 

%% Parameters for the Electrode generation algorithm

gap = [1 ; 11] ;   % Specify the gap values (um) we want to screen.
compo = [94 6 ; 95 5 ] ; % Specify the composition (AM CBD weight ratio) we want to screen.
porosity = [46 ; 49] ; % Specify the porosity values we want to screen.
rmin_am = 0 ; % Minimum radius (um) for the sperical active material particles. If rmin_am = 0 an experimental distribution is loaded. 
rmax_am = 4 ; % Maximum radius (um) for the sperical active material particles.
dimension = [50 50 100] ; % Dimension of the generated electrode (um). 
res = 1 ; % Resolution of the image (i.e. um/pixel). We used 1 in the study. 
N = 1 ; % Number of repetitions for each set of parameters (gap,composition,porosity). 
filename = 'Output_data_example.txt' ; % Name of the text file in which the output data will be stored. 

[tortuosity_electrolyte,tortuosity_solid,Percentage_CC_solid,Percentage_Sep_electrolyte] = ML__gap(porosity,N,gap,compo,rmin_am,rmax_am,dimension,res,1,opt1,filename); 
