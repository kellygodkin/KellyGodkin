%Moving bones from one position to another

close all; clear all;
addpath(genpath("C:\Users\kelly\OneDrive\Desktop\GitHub\SOL_Coding_Repo"));  %add sol coding repo to file path
addpath(genpath("C:\Users\kelly\OneDrive\Desktop\GitHub\Matlab\icp"));

%% Variable Creation

directory_general = 'C:\Projects\Max_wrist_movement';
directory_neutral = 'P:\GordieHardDrive\carpal_lax_db\E00003\S15R\IV.files';

pos2 = "P:\GordieHardDrive\carpal_lax_db\E00003\S02R\Motion15R02R.dat";
pos3 = "P:\GordieHardDrive\carpal_lax_db\E00003\S03R\Motion15R03R.dat";
pos4 = "P:\GordieHardDrive\carpal_lax_db\E00003\S04R\Motion15R04R.dat";
pos5 = "P:\GordieHardDrive\carpal_lax_db\E00003\S05R\Motion15R05R.dat";
pos6 = "P:\GordieHardDrive\carpal_lax_db\E00003\S06R\Motion15R06R.dat";
pos7 = "P:\GordieHardDrive\carpal_lax_db\E00003\S07R\Motion15R07R.dat";
pos8 = "P:\GordieHardDrive\carpal_lax_db\E00003\S08R\Motion15R08R.dat";
pos9 = "P:\GordieHardDrive\carpal_lax_db\E00003\S09R\Motion15R09R.dat";
pos10 = "P:\GordieHardDrive\carpal_lax_db\E00003\S10R\Motion15R10R.dat";
pos11 = "P:\GordieHardDrive\carpal_lax_db\E00003\S11R\Motion15R11R.dat";

directories = [pos2,pos3,pos4,pos5,pos6,pos7,pos8,pos9,pos10,pos11];
len_direc = length(directories);


participant = 'WS007_';
file_version = '_edit_001.iv';       %change per trial for all
p = 4; % position being used
hand = 'R';
p1 = 'neutral'; %moving from position 1 to pos 2
positions = [2,3,4,5,6,7,8,9,10,11];


%% Load Data

% load(directory_general,'bone'); %change first part for different people
%% Load Data

%load('P:\GordieHardDrive\carpal_lax_db\E00001\S15R\IV.files','bone'); %change first part for different people
for b = 1:15
    [R T mag] = getInertialInfo("P:\GordieHardDrive\carpal_lax_db\E00003\S15R\inertia15R.dat",b);
    bone.neutral.(bonecode(b)).Inertia = RT_to_fX4(R,T);
end

for p = 1:len_direc
    x = p+1;
    pos_temp = directories(1,p);
    
    for b = 1:15
        matrix_temp = dlmread(pos_temp);
        RT = matrix_temp(b*4-3:b*4,1:3);
        bone.(position(x)).(bonecode(b)).transform = RT_to_fX4(RT(1:3,1:3),RT(4,1:3));
    end
end

%% Moving Bones into Position

ivstring = createInventorHeader();
for p = 8
    colour = jet(15); % preset matlab colour schemes
    for b = 1:15

        filename = append(bonecode(b),'15',hand,'.iv');
        ivstring = [ivstring createInventorLink(fullfile(directory_neutral, filename), (bone.(position(p)).(bonecode(b)).transform(1:3,1:3)), (bone.(position(p)).(bonecode(b)).transform(1:3,4))', colour(p,:), 0.5)]; % cyan
        % ivstring = [ivstring createInventorLink(fullfile(directory_neutral, filename), eye(3,3), [0 0 0], [0.7 0.7 0.7], 0.5)]; %shows relative to original position grey
        
        temp_matrix = bone.(position(p)).(bonecode(b)).transform*bone.neutral.(bonecode(b)).Inertia;
    
        % cyan coordinate systems 
        % ivstring = [ivstring createInventorArrow(temp_matrix(1:3,4)', temp_matrix(1:3,1)', 20, 0.5, [1 0 0], 0)];
        % ivstring = [ivstring createInventorArrow(temp_matrix(1:3,4)', temp_matrix(1:3,2)', 20, 0.5, [0 1 0], 0)];
        % ivstring = [ivstring createInventorArrow(temp_matrix(1:3,4)', temp_matrix(1:3,3)', 20, 0.5, [0 0 1], 0)];
        % 
        % % neutral (grey)coordinate systems
        % ivstring = [ivstring createInventorArrow(bone.neutral.(bonecode(b)).Inertia(1:3,4)', bone.neutral.(bonecode(b)).Inertia(1:3,1)', 20, 0.5, [1 0 0], 0)];
        % ivstring = [ivstring createInventorArrow(bone.neutral.(bonecode(b)).Inertia(1:3,4)', bone.neutral.(bonecode(b)).Inertia(1:3,2)', 20, 0.5, [0 1 0], 0)];
        % ivstring = [ivstring createInventorArrow(bone.neutral.(bonecode(b)).Inertia(1:3,4)', bone.neutral.(bonecode(b)).Inertia(1:3,3)', 20, 0.5, [0 0 1], 0)];
        
    end
end

fid = fopen(fullfile(directory_general,"wrist_both.iv"),'w');   %where data is being saved
fprintf(fid,ivstring);
fclose(fid);

%% Registration to Neutral

ivstring = createInventorHeader();
bone_registered = 13;                   % bone being registered (radius normally)

for p = positions   %number of positions
    colour = jet(15); % preset matlab colour schemes
    registration_matrix = bone.(position(p)).(bonecode(bone_registered)).transform;     % position being registered
    for b = 1:15
        
        filename = append(bonecode(b),'15',hand,'.iv');
    
        temp2_matrix = ((registration_matrix)^-1)*bone.(position(p)).(bonecode(b)).transform;

        % cyan coordinate systems 
        ivstring = [ivstring createInventorLink(fullfile(directory_neutral, filename), temp2_matrix(1:3,1:3), temp2_matrix(1:3,4)', colour(p,:), 0.5)]; %registered position (cyan)

        temp_matrix = temp2_matrix*bone.neutral.(bonecode(b)).Inertia;
        % ivstring = [ivstring createInventorArrow(temp_matrix(1:3,4)', temp_matrix(1:3,1)', 20, 0.5, [1 0 0], 0)];
        % ivstring = [ivstring createInventorArrow(temp_matrix(1:3,4)', temp_matrix(1:3,2)', 20, 0.5, [0 1 0], 0)];
        % ivstring = [ivstring createInventorArrow(temp_matrix(1:3,4)', temp_matrix(1:3,3)', 20, 0.5, [0 0 1], 0)];
        % 
        % neutral (grey)coordinate systems
        ivstring = [ivstring createInventorLink(fullfile(directory_neutral,filename), eye(3,3), [0 0 0], [0.7 0.7 0.7], 0.5)]; % original position (grey)

        % ivstring = [ivstring createInventorArrow(bone.neutral.(bonecode(b)).Inertia(1:3,4)', bone.neutral.(bonecode(b)).Inertia(1:3,1)', 20, 0.5, [1 0 0], 0)];
        % ivstring = [ivstring createInventorArrow(bone.neutral.(bonecode(b)).Inertia(1:3,4)', bone.neutral.(bonecode(b)).Inertia(1:3,2)', 20, 0.5, [0 1 0], 0)];
        % ivstring = [ivstring createInventorArrow(bone.neutral.(bonecode(b)).Inertia(1:3,4)', bone.neutral.(bonecode(b)).Inertia(1:3,3)', 20, 0.5, [0 0 1], 0)];
    
    end
end

fid = fopen(fullfile(directory_general,"registered_wrist.iv"),'w');     %where data is being saved
fprintf(fid,ivstring);
fclose(fid);

