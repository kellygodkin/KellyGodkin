%% BONE STRUCT
% 
% Change Bone Structure Format to work with Paige's Code
% 
% by: Kelly Godkin
% Updated: 27-03-25

close all;
clear all;
clc;
addpath(genpath("C:\Users\kelly\GitHub\SOL_Coding_Repo"));  
addpath(genpath('C:\Projects\Max_wrist_movement'));  
addpath(genpath("C:\Users\kelly\OneDrive\Desktop\GitHub\SOL_Coding_Repo"));  %add sol coding repo to file path
addpath(genpath('C:\Users\kelly\OneDrive\Desktop\GitHub\Matlab'));

%% Load old bone struct

load(append('C:\Users\kelly\GitHub\SOL_Coding_Repo\Wrist Code\bone_structs\bone_SSM.mat'),'bone');
files = dir('C:\Projects\Max_wrist_movement\SSM_testing\carpal_lax_db\E*');
subject = {files(1:end).name}';% skipping 1 as no full mc2=1

%%



for p = 1:length(subject)
    s = p; % change p to s when all par are being used
    for b = 3:15 % change to 1:15 when using rad and ulna
        bonestruct.(bonecode(b))(p).folder = fullfile(files(s).folder,subject(s),'S15R','IV.files');
        bonestruct.(bonecode(b))(p).name = append(bonecode(b),'15R.iv');
        bonestruct.(bonecode(b))(p).ID = subject(s);
        bonestruct.(bonecode(b))(p).global.pts = bone.(subject{s}).icp.(bonecode(b)).pts;
        bonestruct.(bonecode(b))(p).global.cnt = bone.(subject{s}).icp.(bonecode(b)).cnt;
        bonestruct.(bonecode(b))(p).inertialACS = bone.(subject{s}).S15R.(bonecode(b)).Inertia;
        bonestruct.(bonecode(b))(p).icpR.pts = bone.(subject{s}).icp.(bonecode(b)).pts;
        bonestruct.(bonecode(b))(p).icpR.cnt = bone.(subject{s}).icp.(bonecode(b)).cnt;
        % % 

    end
end
save(append('C:\Users\kelly\GitHub\SOL_Coding_Repo\Wrist Code\bone_structs\bonestruct_SSM.mat'),'bonestruct');

   
