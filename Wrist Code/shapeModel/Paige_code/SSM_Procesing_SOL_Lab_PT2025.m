%% Statistical Shape Modelling, Hindfoot Bones

%% load bone file
% this contains all the .iv files of the bones. setup as
% bones.XXX.global.pts and bones.XXX.global.cnt
load('bones.mat')
% load(append('C:\Users\kelly\GitHub\SOL_Coding_Repo\Wrist Code\bone_structs\bone.mat'),'bone');
addpath(genpath("C:\Users\kelly\GitHub\SOL_Coding_Repo"));  
bones = {'cal';'tal'};
% bones = {'rad'};
participant_range = 1:5; %how many participants/rows I had. I was changing this constantly, hence this variable. If constant, could use for j = 1:length(bones.XXX)

bonestruct.ref = 1; %define the refernece bone. saving in the bonestruct so you can find later. want it to qualitatively look like the 'mean' bone, do not want super unique bony shapes

%visualisation function I made to visualise bones at each step
patch_bonetype(bonestruct, bones, 2, 'global')

%% align intertially

for i = 1:length(bones) %decide what bones analyse
    b = bones{i};
    [centroid,~,~,~,inertialACS, ~,~,~,~,~] = mass_properties(bonestruct.(b)(bonestruct.ref).global.pts, bonestruct.(b)(bonestruct.ref).global.cnt);
    bonestruct.(b)(bonestruct.ref).inertialACS = [inertialACS centroid';[0 0 0 1]];
    bonestruct.(b)(bonestruct.ref).inertial.pts = transformPoints(bonestruct.(b)(bonestruct.ref).inertialACS, bonestruct.(b)(bonestruct.ref).global.pts, -1);
    bonestruct.(b)(bonestruct.ref).inertial.cnt = bonestruct.(b)(bonestruct.ref).global.cnt;
    for j = participant_range
        [bonestruct.(b)(j).inertialACS, bonestruct.(b)(j).inertial.pts] = rotateInertialBones2(bonestruct.(b)(bonestruct.ref).inertial, bonestruct.(b)(j).global, string(j)); 
        % this rotateInertialBones function is one I wrote to manually rotate flip and rotate the bones so they are all in alignment.
        % aligning to inertial axes doesnt always mean they are aligned in the same direction. 
        % the function can take time to run, and once aligned click 'no rotation' to end it for that participant.
        bonestruct.(b)(j).inertial.cnt = bonestruct.(b)(j).global.cnt;
    end
end

patch_bonetype(bonestruct, bones, 2, 'inertial') % i visualise at the end of each step.

%% inertial closest point alignment

for i = 1:length(bones)
    b = bones{i};
    ref_pc.(b).icpR = pointCloud(bonestruct.(b)(bonestruct.ref).inertial.pts);
    for j = participant_range
        bonestruct.(b)(j).inertial.pc = pointCloud(bonestruct.(b)(j).inertial.pts);
        [bonestruct.(b)(j).icpR.T, bonestruct.(b)(j).icpR.pc, ~] = pcregistericp(bonestruct.(b)(j).inertial.pc, ref_pc.(b).icpR);
        bonestruct.(b)(j).icpR.pts = bonestruct.(b)(j).icpR.pc.Location;
        bonestruct.(b)(j).icpR.cnt = bonestruct.(b)(j).inertial.cnt;
    end
end

patch_bonetype(bonestruct, bones, 2, 'icpR')

%% rigid coherent point drift alignment
% this also scales the bones (opt.scale = 1)
% this step is one of the longest, i always save after this. i save as '-v7.3' because the bonestruct can become ve(ry large, and if matlab saves in another version it can fail

for i = 1:length(bones)
    b = bones{i};
    ref_pc.(b).cpdR = pointCloud(bonestruct.(b)(bonestruct.ref).icpR.pts);
    for j = participant_range
        b
        j
        % settings
        beta = 2; lambda = 3; maxIter = 150; tole = 1e-4;
        opt.max_it = maxIter; opt.tol = tole; opt.corresp = 1; opt.beta = beta; opt.lambda = lambda; opt.method= 'rigid';
        opt.viz = 0; opt.scale = 1; opt.normalize = 0;
        [bonestruct.(b)(j).cpdR, ~] = cpd_register(ref_pc.(b).cpdR.Location, bonestruct.(b)(j).icpR.pts,opt); % move participant bones to reference bone position
        bonestruct.(b)(j).cpdR.cnt = bonestruct.(b)(j).icpR.cnt;
        %scaled cpdR
        bonestruct.(b)(j).cpdR.pts = bonestruct.(b)(j).cpdR.Y;
    end
end

patch_bonetype(bonestruct, bones, 2, 'cpdR')

%% export rigid cpd bone to downsample and use for non-rigid coherent point drift reference bone
% this tehcnically does not need to happen (e.g. Anja did not do this), but I do. I go through why I do this in my thesis chapter. 

% briefly, i dont want there to be duplicates of points to be selected in the point correspondence, especially on participant bones where there are unique features, 
% so i downsample the reference bone so this is less likely to happen

for i = 1:length(bones)
    b = bones{i};
    patch2iv(bonestruct.(b)(bonestruct.ref).cpdR.pts, bonestruct.(b)(bonestruct.ref).cpdR.cnt, [b + '_participant13ReferenceBone.iv']);
end

%% import decimated reference bone

for i = 1:length(bones)
    b = bones{i};
    uiwait(msgbox('Please select the decimated ' + string(b) + ' cpdR reference bone'))
    [ref_fn,ref_Dir] = uigetfile('*' + b + '*.iv', 'Select the folder for the cpdR reference bone',  'C:\');
    [bonestruct.(b)(bonestruct.ref).cpd_ref.pts, bonestruct.(b)(bonestruct.ref).cpd_ref.cnt] = read_vrml_fast([ref_Dir, ref_fn]);
    bonestruct.(b)(bonestruct.ref).cpd_ref.cnt = bonestruct.(b)(bonestruct.ref).cpd_ref.cnt(:,1:3)+1;
end

%% first non-rigid correspondence (to participant reference bone)
% i use the cpd_cuda function here. it can also be completed with the cpd-nonrigid settings, but it takes muchhhhh longer.

for i = 1:length(bones)
    b = bones{i};
    for j = participant_range
        [bonestruct.(b)(j).cpdNR1.deformed, bonestruct.(b)(j).cpdNR1.C] = cpd_cuda(bonestruct.(b)(j).cpdR.pts, bonestruct.(b)(bonestruct.ref).cpd_ref.pts, 0.1, 2, 3, 150, 1e-5);
        bonestruct.(b)(j).cpdNR1.pts = bonestruct.(b)(j).cpdR.pts(bonestruct.(b)(j).cpdNR1.C,:);
        bonestruct.(b)(j).cpdNR1.cnt = bonestruct.(b)(bonestruct.ref).cpd_ref.cnt;
    end
end

patch_bonetype(bonestruct, bones, 2, 'cpdNR1')

%% unscale bones using the cpd rigid scaling factor
% unscaling here because procrustes is the next step which will scale the bones. can test if the bones are unscaled by looking at the surface area/volume of these bones vs global bones

for i = 1:length(bones)
    b = bones{i};
    for j = participant_range
        bonestruct.(b)(j).cpdNR1unscaled.pts = bonestruct.(b)(j).cpdNR1.pts / bonestruct.(b)(j).cpdR.s;
        bonestruct.(b)(j).cpdNR1unscaled.cnt = bonestruct.(b)(bonestruct.ref).cpdNR1.cnt;
    end
end

%% procrustes: alignment and scaling

for i = 1:length(bones)
    b = bones{i};
    for j = 1:participant_range
        [~, bonestruct.(b)(j).procrustes.pts, bonestruct.(b)(j).procrustes.T] = procrustes(bonestruct.(b)(bonestruct.ref).cpdNR1unscaled.pts, bonestruct.(b)(j).cpdNR1unscaled.pts);
        bonestruct.(b)(j).procrustes.cnt = bonestruct.(b)(j).cpdNR1.cnt;
    end
end

patch_bonetype(bonestruct, bones, 2, 'procrustes')

%% find mean bone from procrustes aligned bones

for i = 1:length(bones)
    b = bones{i};
    m = 'mean_' + b;
    total = zeros(size(bonestruct.(b)(1).procrustes.pts));
    for j = 1:length(bonestruct.(b))
        total = total + bonestruct.(b)(j).procrustes.pts;
    end
    bonestruct.mean_bones.(m).pts = total/length(bonestruct.(b));
    bonestruct.mean_bones.(m).cnt = bonestruct.(b)(bonestruct.ref).procrustes.cnt;
end

figure;
for i = 1:length(bones)
    b = bones{i};
    m = 'mean_' + b;
    subplot(1,3,i);axis equal;
    patch('faces', bonestruct.mean_bones.(m).cnt, 'vertices', bonestruct.mean_bones.(m).pts, 'FaceColor', [rand rand rand], 'FaceAlpha', .5, 'EdgeAlpha', 0.8);
end
uiwait(msgbox('this is the mean bones'));
close all

%% scale and align cpdR bones
% for the second non-rigid coherent point drift, we want the original number of bone points, not the decimated version from cpdNR1

for i = 1:length(bones)
    b = bones{i};
    for j = participant_range
        clear temp; clear temp1;
        temp = bonestruct.(b)(j).cpdR.pts / bonestruct.(b)(j).cpdR.s;
        temp1 = bonestruct.(b)(j).procrustes.T.b * temp * bonestruct.(b)(j).procrustes.T.T + repmat(bonestruct.(b)(j).procrustes.T.c(1,:), length(bonestruct.(b)(j).cpdR.pts), 1);
        bonestruct.(b)(j).procrustesR.pts = temp1;
        bonestruct.(b)(j).procrustesR.cnt = bonestruct.(b)(j).cpdR.cnt;
    end
end

patch_bonetype(bonestruct, bones, 2, 'procrustesR')

%% second non-rigid coherent point drift (to mean bone)

for i = 1:length(bones)
    b = bones{i};
    m = 'mean_' + b;
    for j = participant_range
        [bonestruct.(b)(j).cpdNR2.deformed, bonestruct.(b)(j).cpdNR2.C] = cpd_cuda(bonestruct.(b)(j).procrustesR.pts, bonestruct.mean_bones.(m).pts, 0.1, 2, 3, 150, 1e-5);
        bonestruct.(b)(j).cpdNR2.pts = bonestruct.(b)(j).procrustesR.pts(bonestruct.(b)(j).cpdNR2.C,:);
        bonestruct.(b)(j).cpdNR2.cnt = bonestruct.mean_bones.(m).cnt;
    end
end

patch_bonetype(bonestruct, bones, 3, 'cpdNR2')

% bones are now corresponding, and scaled! To unscale, use the procrustes scaling factor


% Paige Treherne (2025) ______________________________________________________________________________




