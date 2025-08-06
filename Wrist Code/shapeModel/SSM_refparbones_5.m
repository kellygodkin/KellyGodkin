%% Shape Model References 
% Select Reference Bones
% Code 5
 
% by: Kelly Godkin
% Updated:  Jun 13th 25
close all;
clear all;
clc;

filepath_base = 'P:\Data\2025-04-09 Carpometacarpal Pilot';
load(fullfile(filepath_base,'preprocessing\structures\bonestruct_CMCCS.mat'),"bonestruct");
files = dir(fullfile(filepath_base,'CMC*'));subject = {files(1:end).name}';

% Change which participant for each bone
rad = {'CMC001'};
uln = 'CMC001';
sca = 'CMC001';
lun = 'CMC001';
trq = 'CMC001';
pis = 'CMC001';
tpd = 'CMC001';
tpm = 'CMC001';
cap = 'CMC001';
ham = 'CMC001';
mc1 = 'CMC001';
mc2 = 'CMC001';
mc3 = 'CMC001';
mc4 = 'CMC001';
mc5 = 'CMC001';
pp1 = 'CMC001';
pp2 = 'CMC001';
pp3 = 'CMC001';
pp4 = 'CMC001';
pp5 = 'CMC001';
mp1 = 'CMC001';
mp2 = 'CMC001';
mp3 = 'CMC001';
mp4 = 'CMC001';
mp5 = 'CMC001';
dp1 = 'CMC001';
dp2 = 'CMC001';
dp3 = 'CMC001';
dp4 = 'CMC001';
dp5 = 'CMC001';
ts1 = 'CMC001';
ts2 = 'CMC001';

ref_par = [rad;uln;sca;lun;trq;pis;tpd;tpm;cap;ham;mc1;mc2;mc3;mc4;mc5;pp1;pp2;pp3;pp4;pp5;mp1;mp2;mp3;mp4;mp5;dp1;dp2;dp3;dp4;dp5;ts1;ts2];

for b = 1:numel(fields(bonestruct))
    bonestruct.(bonecode_hand(b))(length(subject)+1).reference_par = ref_par(b);
end

for b = 1:numel(fields(bonestruct))
    for s = 1:length(subject)
        if bonestruct.(bonecode_hand(b))(length(subject)+1).reference_par{1} == bonestruct.(bonecode_hand(b))(s).ID{1}
            bonestruct.(bonecode_hand(b))(length(subject)+1).IVfolder = bonestruct.(bonecode_hand(b))(s).IVfolder;
            bonestruct.(bonecode_hand(b))(length(subject)+1).name = bonestruct.(bonecode_hand(b))(s).name;
            bonestruct.(bonecode_hand(b))(length(subject)+1).ID = bonestruct.(bonecode_hand(b))(s).ID;
            bonestruct.(bonecode_hand(b))(length(subject)+1).global = bonestruct.(bonecode_hand(b))(s).global;
            bonestruct.(bonecode_hand(b))(length(subject)+1).volume = bonestruct.(bonecode_hand(b))(s).volume;
            bonestruct.(bonecode_hand(b))(length(subject)+1).CoM_ev123 = bonestruct.(bonecode_hand(b))(s).CoM_ev123;
            bonestruct.(bonecode_hand(b))(length(subject)+1).csys = bonestruct.(bonecode_hand(b))(s).csys;
            bonestruct.(bonecode_hand(b))(length(subject)+1).transforms = bonestruct.(bonecode_hand(b))(s).transforms;
            bonestruct.(bonecode_hand(b))(length(subject)+1).csys_fixed = bonestruct.(bonecode_hand(b))(s).csys_fixed;
            bonestruct.(bonecode_hand(b))(length(subject)+1).rad_reg = bonestruct.(bonecode_hand(b))(s).rad_reg;
        end
    end
end

save(fullfile(filepath_base,'preprocessing\structures\bonestruct_refpar.mat'),"bonestruct");

%% Copy reference IVs to 


sourceFolder = bonestruct.(bonecode_hand(b))(length(subject)+1).IVfolder;

destinationFolder = 'P:\Data\2025-04-09 Carpometacarpal Pilot\preprocessing\reference\Models\IV';

% Create destination folder if it doesn't exist
if ~exist(destinationFolder, 'dir')
    mkdir(destinationFolder);
end

for b = 1:numel(fields(bonestruct))

    oldFileName =  bonestruct.(bonecode_hand(b))(length(subject)+1).name{:};
   

    newFileName = sprintf(append(oldFileName(8:10) ,'15R.iv'),b); % e.g., renamed_file_001.txt
    oldFullPath = fullfile(sourceFolder, newFileName);
    newFullPath = fullfile(destinationFolder, newFileName);

    copyfile(oldFullPath, newFullPath);
    fprintf('Copied %s to %s\n', oldFileName, newFileName);
end
eul()