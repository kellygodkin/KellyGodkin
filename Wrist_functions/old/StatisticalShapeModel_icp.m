%% Shape Model of the Wrist 1
% Alignement of the bones
% loads in the data, aligns the bones using ACS and then use icp to iterate
% to closer alignment. 
% by: Kelly Godkin
% Updated: 24-04-25

close all;
clear all;
clc;
addpath(genpath("C:\Users\kelly\GitHub\SOL_Coding_Repo"));  
addpath(genpath('C:\Projects\Max_wrist_movement'));  
addpath(genpath("C:\Users\kelly\OneDrive\Desktop\GitHub\SOL_Coding_Repo"));  %add sol coding repo to file path
addpath(genpath('C:\Users\kelly\OneDrive\Desktop\GitHub\Matlab'));


colour = lines(15); % preset matlab colour schemes


%% Load in Data
% Change file paths as needed
bone_registered = 11;       %change as needed
files = dir('C:\Projects\Max_wrist_movement\SSM_testing\carpal_lax_db\E*');
subject = {files(1:end).name}'; % removing par 1 as they do not have a full mc1
directory_neutral = fullfile('C:\Projects\Max_wrist_movement\SSM_testing\carpal_lax_db',subject);
outdir = 'C:\Projects\Max_wrist_movement\SSM_testing';
hand = 'R';      %change per trial for all
% load(append('C:\Users\kelly\GitHub\SOL_Coding_Repo\Wrist Code\bone_structs\bonestruct_SSM.mat'),'bonestruct');





%% loading the matricies 
% load(append('C:\Users\kelly\GitHub\SOL_Coding_Repo\Wrist Code\bone_structs\bone.mat'),'bone');
% load(append('C:\Users\kelly\GitHub\SOL_Coding_Repo\Wrist Code\bone_structs\bonetemp.mat'),'bonetemp');
% % should be changed to possibly be different par (pick each bone ref)4
% load(append('C:\Users\kelly\GitHub\SOL_Coding_Repo\Wrist Code\bone_structs\directory_ref.mat'),'directory_ref')
% load(append('C:\Users\kelly\GitHub\SOL_Coding_Repo\Wrist Code\bone_structs\ref_par.mat'),'ref_par');

%% Align Ref bones

for b = 3:15 %decide what bones analyse

    filename = append(bonecode(b),'15',hand,'.iv');
    boneFile = fullfile(directory_ref{b},'S15R','IV.files',filename);

    [pts,cnt] = read_vrml_fast(boneFile);
    cnt = cnt(:,1:3) +1;

    bone.(ref_par{b}).aligned.(bonecode(b)).cnt = cnt;

    dat = dlmread(fullfile(directory_ref{b},'S15R','inertia15R.dat'));
    m = b;
    R = dat(m*5-2:m*5,1:3);
    t = (dat(m*5-4,1:3))';
    bone.(ref_par{b}).aligned.(bonecode(b)).pts  = RT_transform(pts,R,t,0);
    bone.(ref_par{b}).aligned.(bonecode(b)).InertialACS = RT_to_fX4(R,t);
end


%% Align bones 
% Might be able to negate this if inital positions have the coordinate
% systems aligned otherwise all positions will need to be run through to
% have the coordinate systems aligned 

for s = 1:length(subject)  
    
    for b = 3:15
        bone.(subject{s}).S15R.(bonecode(b)).Inertia(1:3,1:3) = bonetemp.subject{s}.(bonecode(b)).R(1:3,1:3) ;
        
        filename = append(bonecode(b),'15',hand,'.iv');
        boneFile = fullfile(directory_neutral,'S15R','IV.files',filename);
    
        [pts,cnt] = read_vrml_fast((boneFile{s}));
        cnt = cnt(:,1:3) +1;
        
        bone.(subject{s}).aligned.(bonecode(b)).cnt = cnt;
    
        dat = dlmread(fullfile(directory_neutral{s},'S15R','inertia15R.dat'));
        m = b;
        R = bone.(subject{s}).S15R.(bonecode(b)).Inertia(1:3,1:3);
        % t = bone.(subject{s}).S15R.(bonecode(b)).Inertia(4,1:3);
        % R = dat(m*5-2:m*5,1:3);
        t = (dat(m*5-4,1:3))';
        pts_aligned = RT_transform(pts,R,t,0);
        bone.(subject{s}).aligned.(bonecode(b)).pts = pts_aligned;
        
           
        figure(b)
        subplot(1,2,1)
        title([(bonecode(b)) ': aligned']);
        patch('vertices',pts_aligned,'faces',cnt,'faceColor',colour(s,1:3),'faceAlpha',0.8,'edgeAlpha',0.2);
        plot_coordinate_system(zeros(3,1),eye(3),50);
        axis equal

        patch2iv(pts_aligned,cnt,fullfile(outdir,'aligned',[bonecode(b) '_' subject{s} '_aligned.iv']));
        % [Centroid,SurfaceArea,Volume,CoM_ev123,CoM_eigenvectors,I1,I2,I_CoM,I_origin,patches] = mass_properties(boneFile{s});
        % bone.(subject{s}).aligned.(bonecode(b)).Inertia = RT_to_fX4(CoM_eigenvectors,Centroid);
        % [bone.(subject{s}).aligned.(bonecode(b)).InertialAC, bone.(subject{s}).aligned.(bonecode(b)).pts] = rotateInertialBones2(bone.(ref_par{b}).aligned.(bonecode(b)), bone.(subject{s}).aligned.(bonecode(b)), string(s)); 
        
    end
end



%% OLD CODE - DO NOT UNCOMMENT BUT HERE IN CASE PAIGE'S WAY DOESNT WORK---Aligning Bones
% Note all bones need to be from the same side (right/left) otherwise data
% will be mirrored and alignment wont work
% 

% for i = 1:15 %decide what bones analyse

    % filename = append(bonecode(i),'15',hand,'.iv');
    % boneFile = fullfile(directory_neutral,'S15R','IV.files',filename);
    % 
    % [pts,cnt] = read_vrml_fast((boneFile{ref_par}));
    % cnt = cnt(:,1:3) +1;
    % 
    % bone.(subject{s}).aligned.(bonecode(i)).cnt = cnt;
    % 
    % dat = dlmread(fullfile(directory_ref{i},'S15R','inertia15R.dat'));
    % m = i;
    % R = dat(m*5-2:m*5,1:3);
    % t = (dat(m*5-4,1:3))';
    % bone.(subject{ref_par}).aligned.(bonecode(b)).pts  = RT_transform(pts,R,t,0);
    % bone.(subject{s}).aligned.(bonecode(i)).pts = pts_aligned;
    % bone.(subject{s}).aligned.(bonecode(i)).InertialACS = RT_to_fX4(R,t)


% 
%     for s = 1:length(subject)
% 
% 
%         [bone.(subject{s}).aligned.(bonecode(i)).InertialAC, bone.(subject{s}).aligned.(bonecode(i)).pts] = rotateInertialBones2(bone.(subject{ref_par}).aligned.(bonecode(b)), bone.(subject{s}).aligned.(bonecode(b)), string(s)); 
%         % this rotateInertialBones function is one I wrote to manually rotate flip and rotate the bones so they are all in alignment.
%         % aligning to inertial axes doesnt always mean they are aligned in the same direction. 
%         % the function can take time to run, and once aligned click 'no rotation' to end it for that participant.
%         bone.(subject{s}).aligned.(bonecode(i)).cnt = bonestruct.(b)(j).global.cnt;
%     end
% end
% 
% patch_bonetype(bonestruct, bones, 2, 'inertial') % i visualise at the end of each step.
% 


%% ICP For alignment


for s = 1:length(subject)   %change range for positions
    for b = 3:15
              
        % [Centroid,SurfaceArea,Volume,CoM_ev123,CoM_eigenvectors,I1,I2,I_CoM,I_origin,patches] = mass_properties(boneFile{s})
        q = bone.(subject{s}).aligned.(bonecode(b)).pts(:,1:3)';             %point cloud of 1st image
        % q = q';
        
        pnts = bone.(ref_par{b}).aligned.(bonecode(b)).pts(:,1:3)';          %point cloud of 2nd image
        % pnts = pnts';

        %number of iterations is 3rd input

        [TR, TT, ER, t] = icp(pnts(1:3,:),q(1:3,:),20);
        bone.(subject{s}).icp.(bonecode(b)).pts = RT_transform(q',TR,TT,1);
        bone.(subject{s}).icp.(bonecode(b)).cnt = bone.(subject{s}).aligned.(bonecode(b)).cnt;
        %make rad transform 4x4
        figure(b)
        subplot(1,2,2)
        title([(bonecode(b)) ': icp']);
        patch('vertices',bone.(subject{s}).icp.(bonecode(b)).pts,'faces',bone.(subject{s}).icp.(bonecode(b)).cnt,'faceColor',colour(s,1:3),'faceAlpha',0.8,'edgeAlpha',0.2);
        plot_coordinate_system(zeros(3,1),eye(3),50);
        axis equal

        patch2iv(bone.(subject{s}).icp.(bonecode(b)).pts,bone.(subject{s}).icp.(bonecode(b)).cnt,fullfile(outdir,'icp',[bonecode(b) '_' subject{s} '_icp.iv']));
        

        
    end
end



%% Save new data struct

save(append('C:\Users\kelly\GitHub\SOL_Coding_Repo\Wrist Code\bone_structs\bone_SSM.mat'),'bone')