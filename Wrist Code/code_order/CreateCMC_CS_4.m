%% Create CMC Coordinate systems
%{ 
    code 4
    Uses the main_sa_interativeCurvatureCS function to take the surface of the
    tpm and the mc1 to create a coordinate system of the joint.
%}

clear;
clc;
close all;

%% Add paths
addpath(genpath("C:\Users\kelly\GitHub\SOL_Coding_Repo\Wrist Code\PolyfitnTools"));
addpath(genpath('C:\Users\kelly\GitHub'));
filepath_base = 'P:\Data\2025-04-09 Carpometacarpal Pilot';

%% load Bonestruct
load(fullfile(filepath_base,'preprocessing\structures\bonestruct_bR.mat'),"bonestruct");
files = dir(fullfile(filepath_base,'CMC*'));
subject = {files(1:end).name}';
colour = jet(31);

%% Variables
bones = [8, 11]; % The bones you want to get a surface coordinate system 


%% Run CS per subject

for s = 1:length(subject)
    ivstring = createInventorHeader();
    for b = bones
        facetIVfname = [subject{s} '_' bonecode_hand(b) '_surface.iv'];
        facetIVpath = fullfile(filepath_base, 'preprocessing',subject{s},'Models\IV\surface',facetIVfname);
        boneIVfname = [subject{s} '_' bonecode_hand(b) '_R.iv'];
        boneIVpath = fullfile(filepath_base, 'preprocessing',subject{s},'Models\IV\original',boneIVfname);
        inertiaFile = dlmread(fullfile(filepath_base,subject{s},'S15R','inertia15R.dat'));
        inertR = inertiaFile(b*5-4:b*5,1:3);
        inert = inertR;
        inert(3:5,2) = inert(3:5,2) * -1;
        inert(3:5,3) = inert(3:5,3) * -1;

        boneCS_opt = inert;
        writeIVfile_flag = 0; %create open inventor file to visualize bone, facet and cs ***viewed in Wrist Visualizer****
        verbose = 0; %supress progress iterations and plots

        acs = main_sa_interativeCurvatureCS(facetIVpath,boneIVpath,writeIVfile_flag, boneCS_opt, verbose);  
        bonestruct.(bonecode_hand(b))(s).acs = acs;

        ivstring = [ivstring createInventorLink(boneIVpath, eye(3,3), [0 0 0], [0.7,0.7,0.7], 0.5)];
        ivstring = [ivstring createInventorArrow(acs(1:3,4), acs(1:3,1), 20, 0.5, [1, 0, 0], 0)];
        ivstring = [ivstring createInventorArrow(acs(1:3,4), acs(1:3,2), 20, .5, [0, 1, 0], 0)];
        ivstring = [ivstring createInventorArrow(acs(1:3,4), acs(1:3,3), 20, .5, [0, 0, 1], 0)];

        % 
        % acs_new = bonestruct.(bonecode_hand(b))(s).transforms.S03R*bonestruct.(bonecode_hand(b))(s).acs;           % How to translate the coordinate systems
        % 
        % ivstring = [ivstring createInventorLink(boneIVpath, bonestruct.(bonecode_hand(b))(s).transforms.S03R(1:3,1:3), bonestruct.(bonecode_hand(b))(s).transforms.S03R(1:3,4), [0.7,0.7,0.7], 0.5)];
        % 
        % ivstring = [ivstring createInventorArrow(acs_new(1:3,4), acs_new(1:3,1), 20, 0.5, [1, 0, 0], 0)];
        % ivstring = [ivstring createInventorArrow(acs_new(1:3,4), acs_new(1:3,2), 20, .5, [0, 1, 0], 0)];
        % ivstring = [ivstring createInventorArrow(acs_new(1:3,4), acs_new(1:3,3), 20, .5, [0, 0, 1], 0)];

               
    end

    filepath = fullfile(filepath_base,'preprocessing',subject{s},'Models\Visualizations\CMC_CS');

    fid = fopen(fullfile(filepath,'CMC_CS.iv'),"w");
    fprintf(fid,ivstring);
    fclose(fid);
end

save(fullfile(filepath_base,'preprocessing\structures\bonestruct_CMCCS.mat'),"bonestruct");