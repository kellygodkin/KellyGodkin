%% Shape Model of the Wrist 2
% Selection of the reference Mesh and using CPD on the meshes. 

% by: Kelly Godkin
% Updated: 24-03-25

close all;
clear all;
clc;
addpath(genpath("C:\Users\kelly\GitHub\SOL_Coding_Repo"));  
addpath(genpath('C:\Projects\Max_wrist_movement'));  
addpath(genpath("C:\Users\kelly\OneDrive\Desktop\GitHub\SOL_Coding_Repo"));  %add sol coding repo to file path
addpath(genpath('C:\Users\kelly\OneDrive\Desktop\GitHub\Matlab'));


colour = jet(15); % preset matlab colour schemes lines is colour blind friendly

%% Load Data

load(append('C:\Users\kelly\GitHub\SOL_Coding_Repo\Wrist Code\bone_structs\bonestruct_SSM.mat'),'bonestruct');

bone_registered = 11;       %change as needed
files = dir('C:\Projects\Max_wrist_movement\SSM_testing\carpal_lax_db\E*');
subject = {files(1:end).name}'; % removing par 1 as they do not have a full mc1
directory_neutral = fullfile('C:\Projects\Max_wrist_movement\SSM_testing\carpal_lax_db',subject);
outdir = 'C:\Projects\Max_wrist_movement\SSM_testing';
hand = 'R';      %change per trial for all
bone_rotated = 8;   % to check helical axis angle
% boneindex = [7, 8, 9, 10, 12, 13, 14, 15]; % skip MC1
bonestruct.ref = [1,1,2,9,9,9,9,9,6,2,5,4,10,10,10];
bones = {'sca';'lun';'trq';'pis';'tpd';'tpm';'cap';'ham';'mc1';'mc2';'mc3';'mc4';'mc5'};
%'rad';'uln';
%% rigid coherent point drift alignment
% this also scales the bones (opt.scale = 1)
% this step is one of the longest, i always save after this. i save as '-v7.3' because the bonestruct can become very large, and if matlab saves in another version it can fail


for b = 3:15     % 1:15 all bones in the wrist
    ref_pc.(bonecode(b)).cpdR = pointCloud(bonestruct.(bonecode(b))(bonestruct.ref(b)).icpR.pts);
    for s = 1:length(subject)

        % settings
        beta = 2; lambda = 3; maxIter = 150; tole = 1e-4;
        opt.max_it = maxIter; opt.tol = tole; opt.corresp = 1; opt.beta = beta; opt.lambda = lambda; opt.method= 'rigid';
        opt.viz = 0; opt.scale = 1; opt.normalize = 0;
        [bonestruct.(bonecode(b))(s).cpdR, ~] = cpd_register(ref_pc.(bonecode(b)).cpdR.Location, bonestruct.(bonecode(b))(s).icpR.pts,opt); % move participant bones to reference bone position
        bonestruct.(bonecode(b))(s).cpdR.cnt = bonestruct.(bonecode(b))(s).icpR.cnt;
        %scaled cpdR
        bonestruct.(bonecode(b))(s).cpdR.pts = bonestruct.(bonecode(b))(s).cpdR.Y;

    end
end

patch_bonetype(bonestruct, bones, 13, 'cpdR') % visualize % change 13 to 15 when using all bones
% x is the reference pts
save(append('C:\Users\kelly\GitHub\SOL_Coding_Repo\Wrist Code\bone_structs\bonestruct_cpdR.mat'),'bonestruct');
%% export rigid cpd bone to downsample and use for non-rigid coherent point drift reference bone
% downsample reference bone and upsample other bones


%% Non-Rigid - CUDA

% X = bonestruct.sca(3).global.pts
% Y = bonestruct.sca(4).global.pts
% [T, C] = cpd_cuda(X, Y)     %, omega, beta, lambda, maxIter, tol)
