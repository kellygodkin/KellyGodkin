%% Slicer to Wrist Vis formating
%{ 
    By: Kelly Godkin
    Last updated: 24-05-2025
    Code takes 3D to 3D transforms from slicer, imports them and changes the
    format to work with preious code for the wrist. (code 1)
%}

close all; clear all; clc;

addpath(genpath('C:\Users\kelly\GitHub'));  
filepath_base = 'P:\Data\2025-04-09 Carpometacarpal Pilot';


%% Load Files
% Modify subjects to all subjects and change positions to include
% all positions

positions = {'S15R','S02R','S03R','S04R','S05R','S06R'}; %'S15R','S02R','S03R','S04R','S05R','S06R'
files = dir(fullfile(filepath_base,'CMC*'));
subject = {files(1:end).name}';

for s = 1:length(subject)
    for b = 1:31
        bone = bonecode_hand(b);
        filename = append(subject{s},'_',bonecode_hand(b),'-abs-RAS.tra');
        filepath = fullfile(filepath_base,'preprocessing',subject{s},'transforms\original',filename);
        tra = dlmread(filepath);
        
        bonestruct.(bonecode_hand(b))(s).IVfolder = fullfile(filepath_base,subject{s},'S15R\IV.files');
        bonestruct.(bonecode_hand(b))(s).name = append(subject(s),'_',bonecode_hand(b),'_R.iv');
        bonestruct.(bonecode_hand(b))(s).ID = subject(s);
        temp_file = fullfile(filepath_base,'preprocessing',subject{s},'Models\IV\original',append(subject{s},'_',bonecode_hand(b),'_R.iv'));
        [pts,cnt] = read_vrml_fast(temp_file);
        bonestruct.(bonecode_hand(b))(s).global.pts = pts;
        bonestruct.(bonecode_hand(b))(s).global.cnt = cnt;
        [Centroid,SurfaceArea,Volume,CoM_ev123,CoM_eigenvectors,I1,I2,I_CoM,I_origin,patches] = mass_properties(temp_file);
        bonestruct.(bonecode_hand(b))(s).volume = Volume;
        bonestruct.(bonecode_hand(b))(s).CoM_ev123 = CoM_ev123;
        bonestruct.(bonecode_hand(b))(s).csys = RT_to_fX4(CoM_eigenvectors, Centroid);
                    
        for p = 1:length(positions)
            T = correctSAM3DT(tra(p,1:16));
            bonestruct.(bonecode_hand(b))(s).transforms.(positions{p}) = T; 
            tra_new(p,:) = reshape(T,1,16);
        end
        
        filename2 = append(subject{s},'_',bonecode_hand(b),'_R.tra');
        dlmwrite(fullfile(filepath_base,'preprocessing',subject{s},'transforms','Autoscoper',filename2),tra_new);
        % save(fullfile(filepath_base,subject{s},'transforms','Autoscoper',filename2),'tra_new')
    end
end

%% RUN rad ACS
% This is the number of slices to consider for the diaphysis for all 10 subjects
% use mimics and go from scan 0 to the top scan of the radius 
% take the slice height and divide by slice thickness to to get slice
% number
slh_rad = 28; % controls the centroid 
% rad_styloid_dir = ;
bonestruct = radACS(bonestruct,slh_rad,2);
slh_uln = 30;
bonestruct = ulnACS(bonestruct,slh_uln);
save(fullfile(filepath_base,'preprocessing\structures\bonestruct.mat'),"bonestruct");

%% Load edited bone struct

load(fullfile(filepath_base,'preprocessing\structures\bonestruct_new.mat'),"bonestruct");
% % bonestruct.(bonecode_hand(1))(1).csys_fixed = bonestruct.rad(1).transforms.S15R;
% bonestruct.(bonecode_hand(2))(1).csys_fixed = bonestruct.uln(1).transforms.S15R;

colour = [0.7,0.7,0.7;  %rad
        0.7,0.7,0.7;    %uln
        0.7,0.7,0.7;    %sca
        0.7,0.7,0.7;    %lun
        0.7,0.7,0.7;    %trq
        0.7,0.7,0.7;    %pis
        0.0670, 0.4430, 0.7450; %tpd
        0.8200, 0.0160, 0.5450; %tpm
        0.8670, 0.3290, 0;      %cap
        0.929, 0.694, 0.1250;   %ham
        0.7,0.7,0.7;    %mc1
        0.4660,0.6740,0.1880;    %mc2
        0.4660,0.6740,0.1880;    %mc3
        0.4660,0.6740,0.1880;    %mc4
        0.4660,0.6740,0.1880;
        0.7,0.7,0.7;    %mc1
        0.7,0.7,0.7;    %mc2
        0.7,0.7,0.7;    %mc3
        0.7,0.7,0.7;    %mc4
        0.7,0.7,0.7;    %mc2
        0.7,0.7,0.7;    %mc3
        0.7,0.7,0.7;    %mc4
        0.7,0.7,0.7; %mc5
        0.7,0.7,0.7;    %mc1
        0.7,0.7,0.7;    %mc2
        0.7,0.7,0.7;    %mc3
        0.7,0.7,0.7;    %mc4        
        0.7,0.7,0.7;    %mc1
        0.7,0.7,0.7;    %mc2
        0.7,0.7,0.7;    %mc3
        0.7,0.7,0.7;    %mc4
        0.7,0.7,0.7; %mc5
        0.7,0.7,0.7;    %mc1
        0.7,0.7,0.7;    %mc2
        0.7,0.7,0.7;    %mc3
        0.7,0.7,0.7;    %mc4
        0.7,0.7,0.7;    %mc2
        0.7,0.7,0.7;    %mc3
        0.7,0.7,0.7;    %mc4
        0.7,0.7,0.7; %mc5
        0.7,0.7,0.7;    %mc1
        0.7,0.7,0.7;    %mc2
        0.7,0.7,0.7;    %mc3
        0.7,0.7,0.7;    %mc4
        0.7,0.7,0.7];   %mc5


%% Visualizing

for s = 1:length(subject)
    for p = 1:length(positions)
        ivstring = createInventorHeader();
        for b = 1:numel(fields(bonestruct))
            % bonestruct.(bonecode_hand(b))(s).csys_fixed = bonestruct.(bonecode_hand(b))(s).csys;
            filename = append(bonecode_hand(b),'15R.iv');
            filepath = fullfile('P:\Data\2025-04-09 Carpometacarpal Pilot\CMC001\S15R\IV.files',filename);
            
            ivstring = [ivstring createInventorLink(filepath, bonestruct.(bonecode_hand(b))(s).transforms.(positions{p})(1:3,1:3), bonestruct.(bonecode_hand(b))(s).transforms.(positions{p})(1:3,4)', colour(b,:))];
            % ivstring = [ivstring createInventorLink(filepath, eye(3,3), [0 0 0], [0.7,0.7,0.7], 0.5)];
           
            if p == 1
                % when plotting arrows make sure centroid and vectors are both columns or both rows ***

                ivstring = [ivstring createInventorArrow(bonestruct.(bonecode_hand(b))(s).csys_fixed(1:3,4), bonestruct.(bonecode_hand(b))(s).csys_fixed(1:3,1), 20, 0.5, [1, 0, 0], 0)];
                ivstring = [ivstring createInventorArrow(bonestruct.(bonecode_hand(b))(s).csys_fixed(1:3,4), bonestruct.(bonecode_hand(b))(s).csys_fixed(1:3,2), 20, 0.5, [0, 1, 0], 0)];
                ivstring = [ivstring createInventorArrow(bonestruct.(bonecode_hand(b))(s).csys_fixed(1:3,4), bonestruct.(bonecode_hand(b))(s).csys_fixed(1:3,3), 20, 0.5, [0, 0, 1], 0)];
            else
                temp2 = bonestruct.(bonecode_hand(b))(s).transforms.(positions{p})*bonestruct.(bonecode_hand(b))(s).csys_fixed;
                Centroid2 = temp2(1:3,4);
                CoM_eigenvectors2 = temp2(1:3,1:3);
                ivstring = [ivstring createInventorArrow(Centroid2, CoM_eigenvectors2(:,1), 20, 0.5, [1, 0, 0], 0)];
                ivstring = [ivstring createInventorArrow(Centroid2, CoM_eigenvectors2(:,2), 20, 0.5, [0, 1, 0], 0)];
                ivstring = [ivstring createInventorArrow(Centroid2, CoM_eigenvectors2(:,3), 20, 0.5, [0, 0, 1], 0)];
            end
        end
        fid = fopen(fullfile(filepath_base,'preprocessing',subject{s},'Models\Visualizations\positions',append(positions{p},'.iv')),"w");
        fprintf(fid,ivstring);
        fclose(fid);
    end

end

save(fullfile(filepath_base,'preprocessing\structures\bonestruct_S2WV.mat'),"bonestruct");

% %% Creating Rad Anatomy Coordinate system
% for s = 1:numel(fields(bonestruct.rad))
%     [null] = AnatomicCoordSys(fullfile(filepath_base,subject{s}),stackfile,DRUJflag)
% end
% 
% %% Bone registration
% 
% bonestruct = fix_bones('tpm',bonestruct,'S15R','R');
