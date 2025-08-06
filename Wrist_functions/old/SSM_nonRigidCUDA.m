%% Shape Model of the Wrist 1
% loads the rigid CPD and icp and runs non- rigid CPD using CUDA
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
load(fullfile(filepath_base,'preprocessing\structures\bonestruct_cpdr.mat'),"bonestruct");
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

%% Import decimated refernce bone

for b = 1:numel(fields(bonestruct))

    bonestruct.(bonecode_hand(b))(length(subject)+1).name = append(bonecode_hand(b),'15R.iv');
    bonestruct.(bonecode_hand(b))(length(subject)+1).IVfolder = 'P:\Data\2025-04-09 Carpometacarpal Pilot\preprocessing\reference\Models\geomagic_upsampled';
    [bonestruct.(bonecode_hand(b))(length(subject)+1).cpdNR1.pts,bonestruct.(bonecode_hand(b))(length(subject)+1).cpdNR1.cnt] = read_vrml_fast(fullfile(bonestruct.(bonecode_hand(b))(length(subject)+1).IVfolder,bonestruct.(bonecode_hand(b))(length(subject)+1).name));
    bonestruct.(bonecode_hand(b))(length(subject)+1).cpdNR1.cnt = bonestruct.(bonecode_hand(b))(length(subject)+1).cpd_nr.cnt(:,1:3)+1;
end

%% first non-rigid correspondence (to participant reference bone)
% i use the cpd_cuda function here. it can also be completed with the cpd-nonrigid settings, but it takes muchhhhh longer.

for i = 1:numel(fields(bonestruct))
    b = (bonecode_hand(i));
    for j = participant_range
        [bonestruct.(b)(j).cpdNR1.deformed, bonestruct.(b)(j).cpdNR1.C] = cpd_cuda(bonestruct.(b)(j).cpdR.pts, bonestruct.(b)(length(subject)+1).cpdNR1.pts, 0.1, 2, 3, 150, 1e-5);
        bonestruct.(b)(j).cpdNR1.pts = bonestruct.(b)(j).cpdR.pts(bonestruct.(b)(j).cpdNR1.C,:);
        bonestruct.(b)(j).cpdNR1.cnt = bonestruct.(b)(length(subject)+1).cpdNR1.cnt;
    end
end

patch_bonetype_hand(bonestruct, bones, numel(fields(bonestruct)), 'cpd_NR1') % visualize 
       