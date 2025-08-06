%% Shape Model of the Wrist 3 non - rigid CPD (CUDA)
% Ensure that the reference is downsampled and the other bones are
% upsampled
%  (code 8)
% by: Kelly Godkin
% Updated:jul 4th 25
%% Set-up 
% need to mondify paths and variables as needed
close all;
clear all;
clc;

addpath(genpath('C:\Users\skelo\Documents\GitHub'));  
filepath_base = 'P:\Data\2025-04-09 Carpometacarpal Pilot';

%% Variables
bone_registered = 11;
hand = 'R';
load(fullfile(filepath_base,'preprocessing\structures\bonestruct_cpdr.mat'),"bonestruct");
positions = {'S15R','S02R','S03R','S04R','S05R','S06R'};
files = dir(fullfile(filepath_base,'E*'));
subject = {files(1:end).name}';
p1 = nchoosek(positions,2);
colour = lines(31);
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
%% import decimated reference bone

for b = 1: numel(fields(bonestruct))
    s = length(subject)+1;
    bonestruct.(bonecode_hand(b))(s).IVfolder = 'P:/Data/2025-04-09 Carpometacarpal Pilot/preprocessing/reference/Models/geomagic_upsampled';
    bonestruct.(bonecode_hand(b))(s).name = append(bonecode_hand(b),'15R.iv');
    [bonestruct.(bonecode_hand(b))(s).cpdR.pts, bonestruct.(bonecode_hand(b))(s).cpdR.cnt] = read_vrml_fast(fullfile(bonestruct.(bonecode_hand(b))(s).IVfolder,bonestruct.(bonecode_hand(b))(s).name));
    bonestruct.(bonecode_hand(b))(s).cpdR.cnt = bonestruct.(bonecode_hand(b))(s).cpdR.cnt(:,1:3)+1;
     
end

%% first non-rigid correspondence (to participant reference bone)
% i use the cpd_cuda function here. it can also be completed with the cpd-nonrigid settings, but it takes muchhhhh longer.

for b = 1:numel(fields(bonestruct))
    for s = 1:length(subject)
        [bonestruct.(bonecode_hand(b))(s).cpdNR1.deformed,bonestruct.(bonecode_hand(b))(s).cpdNR1.C] = cpd_cuda(bonestruct.(bonecode_hand(b))(s).cpdR.pts,bonestruct.(bonecode_hand(b))(length(subject)+1).cpdR.pts, 0.1, 2, 3, 150, 1e-5);
        bonestruct.(bonecode_hand(b))(s).cpdNR1.pts = bonestruct.(bonecode_hand(b))(s).cpdR.pts(bonestruct.(bonecode_hand(b))(s).cpdNR1.C,:);
        bonestruct.(bonecode_hand(b))(s).cpdNR1.cnt = bonestruct.(bonecode_hand(b))(length(subject)+1).cpdR.cnt;

    end
end


patch_bonetype_hand(bonestruct, bones, numel(fields(bonestruct)), 'cpdR') % visualize 

%% unscale bones using the cpd rigid scaling factor
% unscaling here because procrustes is the next step which will scale the bones. can test if the bones are unscaled by looking at the surface area/volume of these bones vs global bones

for b = 1:numel(fields(bonestruct))

    for s = 1:length(subject)+1
        bonestruct.(bonecode_hand(b))(s).cpdNR1unscaled.pts = bonestruct.(bonecode_hand(b))(s).cpdNR1.pts/bonestruct.(bonecode_hand(b))(s).cpdR.s;
        bonestruct.(bonecode_hand(b))(s).cpdNR1unscaled.cnt = bonestruct.(bonecode_hand(b))(s).cpdNR1.cnt;
    end
end

%% procrustes: alignment and scaling

for b = 1:numel(fields(bonestruct))
    for s = 1:length(subject)
        [~, bonestruct.(bonecode_hand(b))(s).procrustes.pts, bonestruct.(bonecode_hand(b))(s).procrustes.T] = procrustes(bonestruct.(bonecode_hand(b))(length(subject)+1).cpdNR1unscaled.pts,bonestruct.(bonecode_hand(b))(s).cpdNR1unscaled.pts);
        bonestruct.(bonecode_hand(b))(s).procrustes.cnt = bonestruct.(bonecode_hand(b))(s).cpdNR1.cnt;
    end
end

%% find mean bone from procrustes aligned bones

for b = 1:numel(fields(bonestruct))
    m = 'mean_' + bonecode_hand(b);
    total = zeros(size(bonestruct.(bonecode_hand(b))(length(subject)+1).procrustes.pts));
    for s = 1:length(subject)
        total = total + bonestruct.(bonecode_hand(b))(s).procrustes.pts;
    end
    mean_bones.(m).pts = total/numel(fields(bonestruct));
    mean_bones.(m).cnt = bonestruct.(bonecode_hand(b))(length(subject)+1).procrustes.cnt;
end

figure;
for b = 1:numel(fields(bonestruct))
    m = 'mean_' + bonecode_hand(b);
    subplot(6,6,i);axis equal;
    patch('faces', mean_bones.(m).cnt, 'vertices', mean_bones.(m).pts, 'FaceColor', colour(b,:), 'FaceAlpha', .5, 'EdgeAlpha', 0.8);
end
uiwait(msgbox('this is the mean bones'));
close all

%% scale and align cpdR bones
% for the second non-rigid coherent point drift, we want the original number of bone points, not the decimated version from cpdNR1
