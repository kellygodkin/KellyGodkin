%% Saving Structure
%{ 
Saving bone structure and Ivs in dat file format (code 2)
by: Kelly Godkin
Last edited: may 27 2025
%}

clear all; close all; clc;
filepath_base = 'P:\Data\2025-04-09 Carpometacarpal Pilot';
addpath(genpath('C:\Users\kelly\GitHub'));

load('P:\Data\2025-04-09 Carpometacarpal Pilot\preprocessing\structures\bonestruct_S2WV.mat',"bonestruct");     % Filepath where the bonestructure is saved
% load(fullfile(filepath,'bonestruct.mat','bonestruct'));
dbdir =   'P:\Data\2025-04-09 Carpometacarpal Pilot' ;     % database directory
positions = [15,02,03,04,05,06];   %06,07,08,09,10,11,12,13,14
positions2 = {'S15R','S02R','S03R','S04R','S05R','S06R'};
files = dir(fullfile(filepath_base,'CMC*'));
subject = {files(1:end).name}';
%%
for s = 1%:numel(fields(bonestruct.rad))
    x = 0;
    for p = positions
        x = x+1;
        for b = 1:numel(fields(bonestruct))
            inertia15R(b*5-2: b*5, 1:3) = bonestruct.(bonecode_hand(b))(s).transforms.S15R(1:3,1:3);
            inertia15R(b*5-4, 1:3) =  bonestruct.(bonecode_hand(b))(s).transforms.S15R(1:3,4)';
            inertia15R(b*5-3, 1:3) = bonestruct.(bonecode_hand(b))(s).CoM_ev123;
            volume15R = bonestruct.(bonecode_hand(b))(s).volume;
            ACS_rad = bonestruct.rad(s).csys_fixed;
            ACS_uln = bonestruct.uln(s).csys_fixed;

            poseTdata(b*4-3: b*4-1, 1:3) = bonestruct.(bonecode_hand(b))(s).transforms.(positions2{x})(1:3,1:3);
            poseTdata(b*4, 1:3) = bonestruct.(bonecode_hand(b))(s).transforms.(positions2{x})(1:3,4)';
            if p == 15
    
                dlmwrite(fullfile(dbdir, subject{s}, ['S' num2str(p) 'R'], 'inertia15R.dat'),inertia15R,'delimiter',' ','roffset',1)
                dlmwrite(fullfile(dbdir, subject{s}, ['S' num2str(p) 'R'], 'volume15R.dat'),volume15R,'delimiter',' ','roffset',1)
                dlmwrite(fullfile(dbdir, subject{s}, ['S' num2str(p) 'R'], 'AnatCoordSys.dat'),ACS_rad,'delimiter',' ','roffset',1)
                dlmwrite(fullfile(dbdir, subject{s}, ['S' num2str(p) 'R'], 'AnatCoordSys_uln.dat'),ACS_uln,'delimiter',' ','roffset',1)
            elseif p < 10
                dlmwrite(fullfile(dbdir, subject{s}, ['S0' num2str(p) 'R'], ['Motion15R0' num2str(p) 'R.dat']),poseTdata,'delimiter',' ','roffset',1);
            else
                dlmwrite(fullfile(dbdir, subject{s}, ['S' num2str(p) 'R'], ['Motion15R' num2str(p) 'R.dat']),poseTdata,'delimiter',' ','roffset',1);
            end
        end
    end
end

%% Saving IV files -- does not work use move_files
% p = 1;
% for s = 1:length(subject)
%     for b = 1:numel(fields(bonestruct))
%         ivstring = createInventorHeader();
% 
%         filename = append(subject{s},'_',bonecode_hand(b),'_R.iv');
%         filepath = fullfile(filepath_base,'preprocessing',subject{s},'Models\IV\original',filename);
% 
%         ivstring = [ivstring createInventorLink(filepath, eye(3,3), [0 0 0])];
% 
%         % ivstring = [ivstring createInventorArrow(bonestruct.(bonecode_hand(b))(s).csys_fixed(1:3,4), bonestruct.(bonecode_hand(b))(s).csys_fixed(1:3,1), 20, 0.5, [1, 0, 0], 0)];
%         % ivstring = [ivstring createInventorArrow(bonestruct.(bonecode_hand(b))(s).csys_fixed(1:3,4), bonestruct.(bonecode_hand(b))(s).csys_fixed(1:3,2), 20, 0.5, [0, 1, 0], 0)];
%         % ivstring = [ivstring createInventorArrow(bonestruct.(bonecode_hand(b))(s).csys_fixed(1:3,4), bonestruct.(bonecode_hand(b))(s).csys_fixed(1:3,3), 20, 0.5, [0, 0, 1], 0)];
% 
%         filename = append(bonecode_hand(b),'15R.iv');
%         fid = fopen(fullfile('P:\Data\2025-04-09 Carpometacarpal Pilot\CMC001\S15R\IV.files',filename),"w");
%         fprintf(fid,ivstring);
%         fclose(fid);
% 
% 
%     end
% end