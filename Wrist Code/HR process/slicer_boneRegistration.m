%% Slicer Wrist registration to bone registered
% code 3


close all; clear all; clc;

addpath(genpath('C:\Users\kelly\GitHub'));  
filepath_base = 'P:\Data\2025-04-09 Carpometacarpal Pilot';

%% Variables
bone_registered = 7;
hand = 'R';
load(fullfile(filepath_base,'preprocessing\structures\bonestruct_S2WV.mat'),"bonestruct");
positions = {'S15R','S02R','S03R','S04R','S05R','S06R'};
files = dir(fullfile(filepath_base,'CMC*'));
subject = {files(1:end).name}';
p1 = nchoosek(positions,2);
colour = lines(31);

%%

for s = 1: length(subject)
    for b = 1:numel(fields(bonestruct))
        for p = 1:length(positions)-1 % can change to positions to only do in relation to S15R
            pos_name = append(p1{p,1},p1{p,2});
            tempMatrix1 = bonestruct.(bonecode_hand(bone_registered))(s).transforms.(p1{p,1})^-1*bonestruct.(bonecode_hand(b))(s).transforms.(p1{p,1});
            tempMatrix2 = bonestruct.(bonecode_hand(bone_registered))(s).transforms.(p1{p,2})^-1*bonestruct.(bonecode_hand(b))(s).transforms.(p1{p,2});
            % tempMatrix3 = tempMatrix2*tempMatrix1^-1;
            % transformationMatrix = 
            bonestruct.(bonecode_hand(b))(s).rad_reg.(pos_name) = tempMatrix2;
            tra_new(p,:) = reshape(tempMatrix2,1,16);
        end
        filename2 = append(subject{s},'_',bonecode_hand(b),'_R.tra');
        dlmwrite(fullfile(filepath_base,'preprocessing',subject{s},'transforms',bonecode_hand(bone_registered),'Autoscoper',filename2),tra_new);
       
    end
end



%% Visualizing

for s = 1:length(subject)
    for p = 1:length(positions)-1
        ivstring = createInventorHeader();
        for b = 1:numel(fields(bonestruct))
            ivFilePath = fullfile(bonestruct.(bonecode_hand(b))(s).IVfolder);
            ivFile = fullfile(ivFilePath,append(bonecode_hand(b),'15R.iv'));
            pos_name = append(p1{p,1},p1{p,2});
            ivstring = [ivstring createInventorLink(ivFile,bonestruct.(bonecode_hand(b))(s).rad_reg.(pos_name)(1:3,1:3), bonestruct.(bonecode_hand(b))(s).rad_reg.(pos_name)(1:3,4)', colour(b,:), 0.5)];
        
        end
        fid = fopen(fullfile(filepath_base,'preprocessing',subject{s},'Models\Visualizations\positions','registered',[pos_name '.iv']),"w");
        fprintf(fid,ivstring);
        fclose(fid);
    end
end
save(fullfile(filepath_base,'preprocessing\structures\bonestruct_bR.mat'),"bonestruct");