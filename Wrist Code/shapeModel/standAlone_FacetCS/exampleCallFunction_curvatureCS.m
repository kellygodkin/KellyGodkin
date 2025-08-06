%example_call_main_sa_iterativeCurvatureCS
clear
clc
close all
%@Amy Morton
% 3/20/2018
% addpath(genpath("C:\Users\kelly\GitHub\SOL_Coding_Repo\Wrist Code\standAlone_FacetCS"));
addpath(genpath("C:\Users\kelly\GitHub\SOL_Coding_Repo\Wrist Code\PolyfitnTools"));
% addpath(genpath("C:\Users\kelly\OneDrive\Desktop\GitHub\SOL_Coding_Repo"));
addpath(genpath('C:\Users\kelly\GitHub'));
% addpath(genpath('C:\Users\Kelly\Documents\MATLAB\Github'));



%include full path if current directory is not where this file lives...
facetIVpath='P:\Data\2025-04-09 Carpometacarpal Pilot\preprocessing\CMC001\Models\IV\surface\CMC001_tpm_surface.iv';
facetIVpath = fullfile('P:\Data\2025-04-09 Carpometacarpal Pilot\preprocessing\',subject{s},'Models\IV\surface',[subject{s} '_' bonecode_hand(b) '_surface.iv']);
boneIVpath='C:\Users\kelly\GitHub\ShapeModels\Wrist\MATLAB\standAlone_FacetCS\testData\tpm15R.iv';

inertiaFile=dlmread("C:\Users\kelly\GitHub\ShapeModels\Wrist\MATLAB\standAlone_FacetCS\testData\inertia15R.dat");
inertR = inertiaFile(8*5-4:8*5,1:3); % index TPM

%create transform to move pts space that approximates x vd and y ru z
%proxdist (otherwise you'll hit a high rms fit and need pca)
%"surface fitting space"
inert = inertR;
inert(3:5,2) = inert(3:5,2) * -1;
inert(3:5,3) = inert(3:5,3) * -1;

filepath = 'C:\Users\kelly\Desktop';
boneCS_opt = inert;


writeIVfile_flag = 0; %create open inventor file to visualize bone, facet and cs ***viewed in Wrist Visualizer****
verbose = 0; %supress progress iterations and plots

acs = main_sa_interativeCurvatureCS(facetIVpath,boneIVpath,writeIVfile_flag, boneCS_opt, verbose);

ivstring = createInventorHeader();

ivstring = [ivstring createInventorLink(boneIVpath, eye(3,3), [0 0 0], [0.7,0.7,0.7], 0.5)];
ivstring = [ivstring createInventorArrow(acs(1:3,4), acs(1:3,1), 20, 0.5, [1, 0, 0], 0)];
ivstring = [ivstring createInventorArrow(acs(1:3,4), acs(1:3,2), 20, .5, [0, 1, 0], 0)];
ivstring = [ivstring createInventorArrow(acs(1:3,4), acs(1:3,3), 20, .5, [0, 0, 1], 0)];
           
           
fid = fopen(fullfile(filepath,'SSM_tpm_test.iv'),"w");
fprintf(fid,ivstring);
fclose(fid);