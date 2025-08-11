%% Shape Model of the Wrist 1
% loads in the data, aligns the bones using ACS and then use icp to iterate
% to closer alignment. (code 6)
% by: Kelly Godkin
% Updated: 21-03-25

close all;
clear all;
clc;

addpath(genpath('C:\Users\kelly\GitHub'));  
filepath_base = 'P:\Data\2025-04-09 Carpometacarpal Pilot';

%% Variables
bone_registered = 11;
hand = 'R';
load(fullfile(filepath_base,'preprocessing\structures\bonestruct_refpar.mat'),"bonestruct");
positions = {'S15R','S02R','S03R','S04R','S05R','S06R'};
files = dir(fullfile(filepath_base,'CMC*'));
subject = {files(1:end).name}';
p1 = nchoosek(positions,2);
colour = jet(31);
outdir = fullfile(filepath_base,'preprocessing','SSM');
bones = {'rad';'uln';
    'sca';'lun';'trq';'pis';
    'tpd';'tpm';'cap';'ham';
    'mc1';'mc2';'mc3';'mc4';'mc5';
    'pp1';'dp1';'ts1';'ts2';
    'pp2';'mp2';'dp2';
    'pp3';'mp3';'dp3';
    'pp4';'mp4';'dp4';
    'pp5';'mp5';'dp5'};


%% Inertial alignment
% all bones should already be aligned inertially if not look up paiges
% code/statisticalShapeModel
for s = 1:length(subject)
    for b = 1:numel(fields(bonestruct))

        % For inertial set up of icp for alignment
        bonestruct.(bonecode_hand(b))(length(subject)+1).inertial.pts = bonestruct.(bonecode_hand(b))(length(subject)+1).global.pts;
        bonestruct.(bonecode_hand(b))(length(subject)+1).inertial.cnt = bonestruct.(bonecode_hand(b))(length(subject)+1).global.cnt(:,1:3)+1;
        
        bonestruct.(bonecode_hand(b))(s).inertial.cnt = bonestruct.(bonecode_hand(b))(s).global.cnt(:,1:3)+1;
        bonestruct.(bonecode_hand(b))(s).inertial.pts = bonestruct.(bonecode_hand(b))(s).global.pts;
        % bonestruct.(bonecode_hand(b))(s).inertial.pc = pointCloud(bonestruct.(bonecode_hand(b))(s).inertial.pts);

        q = bonestruct.(bonecode_hand(b))(s).inertial.pts';
        pnts = bonestruct.(bonecode_hand(b))(length(subject)+1).inertial.pts';
        [TR, TT, ER, t] = icp(pnts(1:3,:),q(1:3,:),20);
 
        bonestruct.(bonecode_hand(b))(s).icpR.pts = RT_transform(q',TR,TT,1);
        bonestruct.(bonecode_hand(b))(s).icpR.cnt = bonestruct.(bonecode_hand(b))(s).inertial.cnt;

        figure(b)
        % subplot(1,2,2)
        title([(bonecode_hand(b)) ': icpR']);

        patch('vertices',bonestruct.(bonecode_hand(b))(s).icpR.pts,'faces',bonestruct.(bonecode_hand(b))(s).icpR.cnt,'faceColor',colour(s,1:3),'faceAlpha',0.8,'edgeAlpha',0.2);
        plot_coordinate_system(zeros(3,1),eye(3),50);
        axis equal

        patch2iv(bonestruct.(bonecode_hand(b))(s).icpR.pts,bonestruct.(bonecode_hand(b))(s).icpR.cnt,fullfile(outdir,'icpR',[bonecode_hand(b) '_' subject{s} '_icpR.iv']));
        
    end
end
        

%% Rigid coherent point drift
%{
    Need to downsample bones before running rigid CPD by 50% or to ~5000
    nodes
        It works well on original bones too, but might include duplicates 
        and therefore, it is beneficial if reference bone has less points 
        than the to be registered bones.
%}
for b = 1: numel(fields(bonestruct))
    
    bonestruct.(bonecode_hand(b))(length(subject)+1).inertial.pc = pointCloud(bonestruct.(bonecode_hand(b))(length(subject)+1).inertial.pts);
    for s =  1:length(subject)

        % settings
        beta = 2; lambda = 3; maxIter = 150; tole = 1e-4;
        opt.max_it = maxIter; opt.tol = tole; opt.corresp = 1; opt.beta = beta; opt.lambda = lambda; opt.method= 'rigid';
        opt.viz = 0; opt.scale = 1; opt.normalize = 0;
       [bonestruct.(bonecode_hand(b))(s).cpdR,~] = cpd_register(bonestruct.(bonecode_hand(b))(length(subject)+1).inertial.pc.Location,bonestruct.(bonecode_hand(b))(s).icpR.pts,opt);

        bonestruct.(bonecode_hand(b))(s).cpdR.cnt = bonestruct.(bonecode_hand(b))(s).icpR.cnt;
        bonestruct.(bonecode_hand(b))(s).cpdR.pts = bonestruct.(bonecode_hand(b))(s).cpdR.Y;
    end
end

patch_bonetype_hand(bonestruct, bones, numel(fields(bonestruct)), 'cpdR') % visualize 
% x is the reference pts
save(fullfile(filepath_base,'preprocessing\structures\bonestruct_cpdr.mat'),"bonestruct");


%% Next step is to create and increase the meshes for the the bones and run a non - rigid CPD (CUDA)
% export rigid cpd bone to downsample and use for non-rigid coherent point drift reference bone
% this tehcnically does not need to happen (e.g. Anja did not do this), but I do. I go through why I do this in my thesis chapter. 

% briefly, i dont want there to be duplicates of points to be selected in the point correspondence, especially on participant bones where there are unique features, 
% so i downsample the reference bone so this is less likely to happen
