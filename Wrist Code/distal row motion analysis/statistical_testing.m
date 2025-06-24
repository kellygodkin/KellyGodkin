%% Statistical Testing

close all; clear all;
addpath(genpath("C:\Users\kelly\OneDrive\Desktop\GitHub\SOL_Coding_Repo"));  %add sol coding repo to file path
addpath(genpath('C:\Projects\Max_wrist_movement'));  %add sol coding repo to file path


%% Variables
bone_registered = 11;
files = dir('P:\GordieHardDrive\carpal_lax_db\E*');
subject = {files(:).name}';

directory_neutral = fullfile('P:\GordieHardDrive\carpal_lax_db',subject);
hand = 'R';      %change per trial for all
bone_rotated = 8;   % to check helical axis ang;le
boneindex = [7, 8, 9, 10, 12, 13, 14, 15]; % skip MC1
for b = 1:length(boneindex)
        bonename(1,b) = {bonecode(boneindex(b))};
end
for s = 1:length(directory_neutral)
    info = getSubjectFilePath(directory_neutral{s},hand);
end
    
directory_general = append('C:\Projects\Max_wrist_movement\',bonecode(bone_registered));
    
p1 = nchoosek(info.series(2:end),2); %moving from position 1 to pos 2
p2 = nchoosek(info.series,2);


%% Load Data

load(directory_general,'bone'); %change first part for different people
load(directory_general,'all_phi');  
load(directory_general,'all_bones');  

