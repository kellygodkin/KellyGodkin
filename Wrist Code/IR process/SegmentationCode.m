% creating 3d images and adding all coordinate systems 
close all; clear all;
addpath(genpath("C:\Users\kelly\OneDrive\Desktop\GitHub\SOL_Coding_Repo"));  
addpath(genpath("C:\Users\kelly\OneDrive\Desktop\GitHub\Matlab\icp"));

%% Variable Creation
directory_neutral = 'C:\Projects\Max_wrist_movement\15R';
directory_pos4 = 'C:\Projects\Max_wrist_movement\4R';
directory_pos5 = 'C:\Projects\Max_wrist_movement\5R';
directory_pos6 = 'C:\Projects\Max_wrist_movement\6R';
directory_pos7 = 'C:\Projects\Max_wrist_movement\7R';
directory_pos8 = 'C:\Projects\Max_wrist_movement\8R';
directory_pos10 = 'C:\Projects\Max_wrist_movement\10R';
directory_general = 'C:\Projects\Max_wrist_movement';


participant = 'WS007_';
file_version = '_edit_001.iv';       %change per trial for all
p = 4; % position being used
hand = 'R';
p1 = 'neutral'; %moving from position 1 to pos 2
positions = [4,5,6,7,8,10];
positions_icp = [4,5,6,7,10];



%% Segmentaion of Neutral
ivstring = createInventorHeader();

for b = 1:15
    filename = append(participant,bonecode(b),file_version);
    ivstring = [ivstring createInventorLink(fullfile(directory_neutral,filename), eye(3,3), [0,0,0], [0.7,0.7,0.7], 0.5)];
    [Centroid,SurfaceArea,Volume,CoM_ev123,CoM_eigenvectors,I1,I2,I_CoM,I_origin,patches] = mass_properties(fullfile(directory_neutral,filename));
    
    switch b %columns are eigenvectors
        case 1
            CoM_eigenvectors = [-CoM_eigenvectors(:,2), -CoM_eigenvectors(:,3), CoM_eigenvectors(:,1)];
        case 2
            CoM_eigenvectors = [CoM_eigenvectors(:,1), -CoM_eigenvectors(:,3), CoM_eigenvectors(:,2)];
        case 3
            CoM_eigenvectors = [-CoM_eigenvectors(:,3), -CoM_eigenvectors(:,2), -CoM_eigenvectors(:,1)];
        case 4
            CoM_eigenvectors = [CoM_eigenvectors(:,3), -CoM_eigenvectors(:,1), -CoM_eigenvectors(:,2)];
        case 5
            CoM_eigenvectors = [-CoM_eigenvectors(:,1), CoM_eigenvectors(:,2), -CoM_eigenvectors(:,3)];
        case 6
            CoM_eigenvectors = [-CoM_eigenvectors(:,2), CoM_eigenvectors(:,1), CoM_eigenvectors(:,3)];
        case 7
            CoM_eigenvectors = [-CoM_eigenvectors(:,3), -CoM_eigenvectors(:,1), CoM_eigenvectors(:,2)];
        case 8
            CoM_eigenvectors = [CoM_eigenvectors(:,3), -CoM_eigenvectors(:,1), -CoM_eigenvectors(:,2)];
        case 9
            CoM_eigenvectors = [CoM_eigenvectors(:,1), -CoM_eigenvectors(:,2), -CoM_eigenvectors(:,3)];
        case 10
            CoM_eigenvectors = [CoM_eigenvectors(:,1), -CoM_eigenvectors(:,2), -CoM_eigenvectors(:,3)];
        case 11
            CoM_eigenvectors = [CoM_eigenvectors(:,1), -CoM_eigenvectors(:,2), -CoM_eigenvectors(:,3)];
        case 12
            CoM_eigenvectors = [CoM_eigenvectors(:,1), CoM_eigenvectors(:,2), CoM_eigenvectors(:,3)];
        case 13
            CoM_eigenvectors = [CoM_eigenvectors(:,1), -CoM_eigenvectors(:,2), -CoM_eigenvectors(:,3)];
        case 14
            CoM_eigenvectors = [CoM_eigenvectors(:,1), -CoM_eigenvectors(:,2), -CoM_eigenvectors(:,3)];
        case 15
            CoM_eigenvectors = [CoM_eigenvectors(:,1), -CoM_eigenvectors(:,3), CoM_eigenvectors(:,2)];
    end

    ivstring = [ivstring createInventorArrow(Centroid, CoM_eigenvectors(:,1)', 20, 0.5, [1, 0, 0], 0)];
    ivstring = [ivstring createInventorArrow(Centroid, CoM_eigenvectors(:,2)', 20, 0.5, [0, 1, 0], 0)];
    ivstring = [ivstring createInventorArrow(Centroid, CoM_eigenvectors(:,3)', 20, 0.5, [0, 0, 1], 0)];

    bone.neutral.(bonecode(b)).centroid = Centroid;
    bone.neutral.(bonecode(b)).vectors = CoM_eigenvectors;
    bone.neutral.(bonecode(b)).Inertia = RT_to_fX4(CoM_eigenvectors, Centroid);

end

fid = fopen(fullfile(directory_neutral, 'Neutral.iv'),"w");     %where data is being saved
fprintf(fid,ivstring);
fclose(fid);

% save('C:\Projects\Wrist_Segmentaion\WS007_neutral.mat','bone');
 

%% Segmenting Position 4
ivstring = createInventorHeader();
p = 4;       %position
directory_temp = append(directory_general,'\',position(position(p)),hand);
for b = 1:15
    filename = append(participant,bonecode(b),file_version);
    ivstring = [ivstring createInventorLink(fullfile(directory_temp,filename), eye(3,3), [0,0,0], [0.7,0.7,0.7], 0.5)];
    [Centroid,SurfaceArea,Volume,CoM_ev123,CoM_eigenvectors,I1,I2,I_CoM,I_origin,patches] = mass_properties(fullfile(directory_temp,filename));
    
    switch b %columns are eigenvectors
        case 1
            CoM_eigenvectors = [CoM_eigenvectors(:,1), CoM_eigenvectors(:,3), -CoM_eigenvectors(:,2)];
        case 2
            CoM_eigenvectors = [CoM_eigenvectors(:,1), -CoM_eigenvectors(:,3), CoM_eigenvectors(:,2)];
        case 3
            CoM_eigenvectors = [CoM_eigenvectors(:,3), -CoM_eigenvectors(:,2), CoM_eigenvectors(:,1)];
        case 4
            CoM_eigenvectors = [CoM_eigenvectors(:,3), CoM_eigenvectors(:,1), CoM_eigenvectors(:,2)];
        case 5
            CoM_eigenvectors = [CoM_eigenvectors(:,1), -CoM_eigenvectors(:,2), -CoM_eigenvectors(:,3)];
        case 6
            CoM_eigenvectors = [CoM_eigenvectors(:,2), CoM_eigenvectors(:,1), -CoM_eigenvectors(:,3)];
        case 7
            CoM_eigenvectors = [-CoM_eigenvectors(:,3), -CoM_eigenvectors(:,1), CoM_eigenvectors(:,2)];
        case 8
            CoM_eigenvectors = [CoM_eigenvectors(:,3), -CoM_eigenvectors(:,1), -CoM_eigenvectors(:,2)];
        case 9
            CoM_eigenvectors = [CoM_eigenvectors(:,1), -CoM_eigenvectors(:,2), -CoM_eigenvectors(:,3)];
        case 10
            CoM_eigenvectors = [CoM_eigenvectors(:,1), -CoM_eigenvectors(:,2), -CoM_eigenvectors(:,3)];
        case 11
            CoM_eigenvectors = [CoM_eigenvectors(:,1), CoM_eigenvectors(:,3), -CoM_eigenvectors(:,2)];
        case 12
            CoM_eigenvectors = [CoM_eigenvectors(:,1), -CoM_eigenvectors(:,2), -CoM_eigenvectors(:,3)];
        case 13
            CoM_eigenvectors = [CoM_eigenvectors(:,1), CoM_eigenvectors(:,2), CoM_eigenvectors(:,3)];
        case 14
            CoM_eigenvectors = [CoM_eigenvectors(:,1), CoM_eigenvectors(:,2), CoM_eigenvectors(:,3)];
        case 15
            CoM_eigenvectors = [CoM_eigenvectors(:,1), CoM_eigenvectors(:,3), -CoM_eigenvectors(:,2)];
    end

    ivstring = [ivstring createInventorArrow(Centroid, CoM_eigenvectors(:,1)', 20, 0.5, [1, 0, 0], 0)];
    ivstring = [ivstring createInventorArrow(Centroid, CoM_eigenvectors(:,2)', 20, 0.5, [0, 1, 0], 0)];
    ivstring = [ivstring createInventorArrow(Centroid, CoM_eigenvectors(:,3)', 20, 0.5, [0, 0, 1], 0)];

    bone.(position(p)).(bonecode(b)).centroid = Centroid;
    bone.(position(p)).(bonecode(b)).vectors = CoM_eigenvectors;
    bone.(position(p)).(bonecode(b)).Inertia = RT_to_fX4(CoM_eigenvectors, Centroid);

end
name = append(position(p),'.iv');
fid = fopen(fullfile(directory_temp, name),"w");       %where data is being saved
fprintf(fid,ivstring);
fclose(fid);

%% Segmenting Position 5
ivstring = createInventorHeader();
p = 5;       %position
directory_temp = append(directory_general,'\',position(position(p)),hand);
for b = 1:15
    filename = append(participant,bonecode(b),file_version);
    ivstring = [ivstring createInventorLink(fullfile(directory_temp,filename), eye(3,3), [0,0,0], [0.7,0.7,0.7], 0.5)];
    [Centroid,SurfaceArea,Volume,CoM_ev123,CoM_eigenvectors,I1,I2,I_CoM,I_origin,patches] = mass_properties(fullfile(directory_temp,filename));
    
    switch b %columns are eigenvectors
        case 1
            CoM_eigenvectors = [CoM_eigenvectors(:,1), CoM_eigenvectors(:,3), -CoM_eigenvectors(:,2)];
        case 2
            CoM_eigenvectors = [CoM_eigenvectors(:,1), -CoM_eigenvectors(:,3), CoM_eigenvectors(:,2)];
        case 3
            CoM_eigenvectors = [CoM_eigenvectors(:,3), -CoM_eigenvectors(:,2), CoM_eigenvectors(:,1)];
        case 4
            CoM_eigenvectors = [-CoM_eigenvectors(:,3), CoM_eigenvectors(:,1), -CoM_eigenvectors(:,2)];
        case 5
            CoM_eigenvectors = [CoM_eigenvectors(:,1), CoM_eigenvectors(:,3), -CoM_eigenvectors(:,2)];
        case 6
            CoM_eigenvectors = [CoM_eigenvectors(:,2), -CoM_eigenvectors(:,1), CoM_eigenvectors(:,3)];
        case 7
            CoM_eigenvectors = [-CoM_eigenvectors(:,3), CoM_eigenvectors(:,1), -CoM_eigenvectors(:,2)];
        case 8
            CoM_eigenvectors = [CoM_eigenvectors(:,3), -CoM_eigenvectors(:,1), -CoM_eigenvectors(:,2)];
        case 9
            CoM_eigenvectors = [CoM_eigenvectors(:,1), -CoM_eigenvectors(:,2), -CoM_eigenvectors(:,3)];
        case 10
            CoM_eigenvectors = [CoM_eigenvectors(:,1), -CoM_eigenvectors(:,2), -CoM_eigenvectors(:,3)];
        case 11
            CoM_eigenvectors = [CoM_eigenvectors(:,1), CoM_eigenvectors(:,3), -CoM_eigenvectors(:,2)];
        case 12
            CoM_eigenvectors = [CoM_eigenvectors(:,1), -CoM_eigenvectors(:,2), -CoM_eigenvectors(:,3)];
        case 13
            CoM_eigenvectors = [CoM_eigenvectors(:,1), -CoM_eigenvectors(:,2), -CoM_eigenvectors(:,3)];
        case 14
            CoM_eigenvectors = [CoM_eigenvectors(:,1), -CoM_eigenvectors(:,2), -CoM_eigenvectors(:,3)];
        case 15
            CoM_eigenvectors = [-CoM_eigenvectors(:,1), -CoM_eigenvectors(:,3), -CoM_eigenvectors(:,2)];
    end

    ivstring = [ivstring createInventorArrow(Centroid, CoM_eigenvectors(:,1)', 20, 0.5, [1, 0, 0], 0)];
    ivstring = [ivstring createInventorArrow(Centroid, CoM_eigenvectors(:,2)', 20, 0.5, [0, 1, 0], 0)];
    ivstring = [ivstring createInventorArrow(Centroid, CoM_eigenvectors(:,3)', 20, 0.5, [0, 0, 1], 0)];

    bone.(position(p)).(bonecode(b)).centroid = Centroid;
    bone.(position(p)).(bonecode(b)).vectors = CoM_eigenvectors;
    bone.(position(p)).(bonecode(b)).Inertia = RT_to_fX4(CoM_eigenvectors, Centroid);

end
name = append(position(p),'.iv');
fid = fopen(fullfile(directory_temp, name),"w");       %where data is being saved
fprintf(fid,ivstring);
fclose(fid);


%% Position 6

ivstring = createInventorHeader();
p = 6;       %position
directory_temp = append(directory_general,'\',position(position(p)),hand);
for b = 1:15
    filename = append(participant,bonecode(b),file_version);
    ivstring = [ivstring createInventorLink(fullfile(directory_temp,filename), eye(3,3), [0,0,0], [0.7,0.7,0.7], 0.5)];
    [Centroid,SurfaceArea,Volume,CoM_ev123,CoM_eigenvectors,I1,I2,I_CoM,I_origin,patches] = mass_properties(fullfile(directory_temp,filename));
    
    switch b %columns are eigenvectors
        case 1
            CoM_eigenvectors = [CoM_eigenvectors(:,1), -CoM_eigenvectors(:,3), CoM_eigenvectors(:,2)];
        case 2
            CoM_eigenvectors = [CoM_eigenvectors(:,1), -CoM_eigenvectors(:,2), -CoM_eigenvectors(:,3)];
        case 3
            CoM_eigenvectors = [-CoM_eigenvectors(:,3), CoM_eigenvectors(:,2), CoM_eigenvectors(:,1)];
        case 4
            CoM_eigenvectors = [-CoM_eigenvectors(:,3), -CoM_eigenvectors(:,1), CoM_eigenvectors(:,2)];
        case 5
            CoM_eigenvectors = [-CoM_eigenvectors(:,1), -CoM_eigenvectors(:,2), CoM_eigenvectors(:,3)];
        case 6
            CoM_eigenvectors = [-CoM_eigenvectors(:,2), -CoM_eigenvectors(:,1), -CoM_eigenvectors(:,3)];
        case 7
            CoM_eigenvectors = [-CoM_eigenvectors(:,3), -CoM_eigenvectors(:,1), CoM_eigenvectors(:,2)];
        case 8
            CoM_eigenvectors = [CoM_eigenvectors(:,3), -CoM_eigenvectors(:,1), -CoM_eigenvectors(:,2)];
        case 9
            CoM_eigenvectors = [-CoM_eigenvectors(:,1), CoM_eigenvectors(:,2), -CoM_eigenvectors(:,3)];
        case 10
            CoM_eigenvectors = [CoM_eigenvectors(:,1), CoM_eigenvectors(:,2), CoM_eigenvectors(:,3)];
        case 11
            CoM_eigenvectors = [-CoM_eigenvectors(:,1), CoM_eigenvectors(:,3), CoM_eigenvectors(:,2)];
        case 12
            CoM_eigenvectors = [-CoM_eigenvectors(:,1), CoM_eigenvectors(:,2), -CoM_eigenvectors(:,3)];
        case 13
            CoM_eigenvectors = [-CoM_eigenvectors(:,1), CoM_eigenvectors(:,2), -CoM_eigenvectors(:,3)];
        case 14
            CoM_eigenvectors = [CoM_eigenvectors(:,1), CoM_eigenvectors(:,2), CoM_eigenvectors(:,3)];
        case 15
            CoM_eigenvectors = [-CoM_eigenvectors(:,1),- CoM_eigenvectors(:,3), -CoM_eigenvectors(:,2)];
    end

    ivstring = [ivstring createInventorArrow(Centroid, CoM_eigenvectors(:,1)', 20, 0.5, [1, 0, 0], 0)];
    ivstring = [ivstring createInventorArrow(Centroid, CoM_eigenvectors(:,2)', 20, 0.5, [0, 1, 0], 0)];
    ivstring = [ivstring createInventorArrow(Centroid, CoM_eigenvectors(:,3)', 20, 0.5, [0, 0, 1], 0)];

    bone.(position(p)).(bonecode(b)).centroid = Centroid;
    bone.(position(p)).(bonecode(b)).vectors = CoM_eigenvectors;
    bone.(position(p)).(bonecode(b)).Inertia = RT_to_fX4(CoM_eigenvectors, Centroid);

end
name = append(position(p),'.iv');
fid = fopen(fullfile(directory_temp, name),"w");       %where data is being saved
fprintf(fid,ivstring);
fclose(fid);


%% Position 7

ivstring = createInventorHeader();
p = 7;       %position
directory_temp = append(directory_general,'\',position(position(p)),hand);
for b = 1:15
    filename = append(participant,bonecode(b),file_version);
    ivstring = [ivstring createInventorLink(fullfile(directory_temp,filename), eye(3,3), [0,0,0], [0.7,0.7,0.7], 0.5)];
    [Centroid,SurfaceArea,Volume,CoM_ev123,CoM_eigenvectors,I1,I2,I_CoM,I_origin,patches] = mass_properties(fullfile(directory_temp,filename));
    
    switch b %columns are eigenvectors
        case 1
            CoM_eigenvectors = [-CoM_eigenvectors(:,2), CoM_eigenvectors(:,3), -CoM_eigenvectors(:,1)];
        case 2
            CoM_eigenvectors = [CoM_eigenvectors(:,1), -CoM_eigenvectors(:,3), CoM_eigenvectors(:,2)];
        case 3
            CoM_eigenvectors = [-CoM_eigenvectors(:,3), CoM_eigenvectors(:,2), CoM_eigenvectors(:,1)];
        case 4
            CoM_eigenvectors = [CoM_eigenvectors(:,3), -CoM_eigenvectors(:,1), -CoM_eigenvectors(:,2)];
        case 5
            CoM_eigenvectors = [CoM_eigenvectors(:,1),  -CoM_eigenvectors(:,2), -CoM_eigenvectors(:,3)];
        case 6
            CoM_eigenvectors = [-CoM_eigenvectors(:,2), CoM_eigenvectors(:,1), CoM_eigenvectors(:,3)];
        case 7
            CoM_eigenvectors = [-CoM_eigenvectors(:,3), CoM_eigenvectors(:,1), -CoM_eigenvectors(:,2)];
        case 8
            CoM_eigenvectors = [CoM_eigenvectors(:,3), -CoM_eigenvectors(:,1), -CoM_eigenvectors(:,2)];
        case 9
            CoM_eigenvectors = [-CoM_eigenvectors(:,1), CoM_eigenvectors(:,2), -CoM_eigenvectors(:,3)];
        case 10
            CoM_eigenvectors = [CoM_eigenvectors(:,1), -CoM_eigenvectors(:,2), -CoM_eigenvectors(:,3)];
        case 11
            CoM_eigenvectors = [-CoM_eigenvectors(:,1), CoM_eigenvectors(:,3), CoM_eigenvectors(:,2)];
        case 12
            CoM_eigenvectors = [-CoM_eigenvectors(:,1), -CoM_eigenvectors(:,2), CoM_eigenvectors(:,3)];
        case 13
            CoM_eigenvectors = [-CoM_eigenvectors(:,1), -CoM_eigenvectors(:,2), CoM_eigenvectors(:,3)];
        case 14
            CoM_eigenvectors = [-CoM_eigenvectors(:,1), -CoM_eigenvectors(:,2), CoM_eigenvectors(:,3)];
        case 15
            CoM_eigenvectors = [CoM_eigenvectors(:,1), CoM_eigenvectors(:,3), -CoM_eigenvectors(:,2)];
    end

    ivstring = [ivstring createInventorArrow(Centroid, CoM_eigenvectors(:,1)', 20, 0.5, [1, 0, 0], 0)];
    ivstring = [ivstring createInventorArrow(Centroid, CoM_eigenvectors(:,2)', 20, 0.5, [0, 1, 0], 0)];
    ivstring = [ivstring createInventorArrow(Centroid, CoM_eigenvectors(:,3)', 20, 0.5, [0, 0, 1], 0)];

    bone.(position(p)).(bonecode(b)).centroid = Centroid;
    bone.(position(p)).(bonecode(b)).vectors = CoM_eigenvectors;
    bone.(position(p)).(bonecode(b)).Inertia = RT_to_fX4(CoM_eigenvectors, Centroid);

end
name = append(position(p),'.iv');
fid = fopen(fullfile(directory_temp, name),"w");       %where data is being saved
fprintf(fid,ivstring);
fclose(fid);
% save('C:\Projects\Wrist_Segmentaion\WS007_bone.mat','bone');

%% Segmenting Position 8
ivstring = createInventorHeader();
p = 8;       %position
directory_temp = append(directory_general,'\',position(position(p)),hand);
for b = 1:15
    filename = append(participant,bonecode(b),file_version);
    ivstring = [ivstring createInventorLink(fullfile(directory_temp,filename), eye(3,3), [0,0,0], [0.7,0.7,0.7], 0.5)];
    [Centroid,SurfaceArea,Volume,CoM_ev123,CoM_eigenvectors,I1,I2,I_CoM,I_origin,patches] = mass_properties(fullfile(directory_temp,filename));
    
    switch b %columns are eigenvectors
        case 1
            CoM_eigenvectors = [CoM_eigenvectors(:,1), -CoM_eigenvectors(:,3), CoM_eigenvectors(:,2)];
        case 2
            CoM_eigenvectors = [CoM_eigenvectors(:,1), -CoM_eigenvectors(:,3), CoM_eigenvectors(:,2)];
        case 3
            CoM_eigenvectors = [CoM_eigenvectors(:,3), -CoM_eigenvectors(:,2), CoM_eigenvectors(:,1)];
        case 4
            CoM_eigenvectors = [CoM_eigenvectors(:,3), CoM_eigenvectors(:,1), CoM_eigenvectors(:,2)];
        case 5
            CoM_eigenvectors = [CoM_eigenvectors(:,1), -CoM_eigenvectors(:,2) , -CoM_eigenvectors(:,3)];
        case 6
            CoM_eigenvectors = [-CoM_eigenvectors(:,2), CoM_eigenvectors(:,1), CoM_eigenvectors(:,3)];
        case 7
            CoM_eigenvectors = [-CoM_eigenvectors(:,3), CoM_eigenvectors(:,1), -CoM_eigenvectors(:,2)];
        case 8
            CoM_eigenvectors = [-CoM_eigenvectors(:,3), CoM_eigenvectors(:,1), -CoM_eigenvectors(:,2)];
        case 9
            CoM_eigenvectors = [-CoM_eigenvectors(:,1), -CoM_eigenvectors(:,2), CoM_eigenvectors(:,3)];
        case 10
            CoM_eigenvectors = [CoM_eigenvectors(:,1), CoM_eigenvectors(:,2), CoM_eigenvectors(:,3)];
        case 11
            CoM_eigenvectors = [-CoM_eigenvectors(:,1), CoM_eigenvectors(:,3), CoM_eigenvectors(:,2)];
        case 12
            CoM_eigenvectors = [CoM_eigenvectors(:,1), -CoM_eigenvectors(:,2), -CoM_eigenvectors(:,3)];
        case 13
            CoM_eigenvectors = [CoM_eigenvectors(:,1), -CoM_eigenvectors(:,2), -CoM_eigenvectors(:,3)];
        case 14
            CoM_eigenvectors = [CoM_eigenvectors(:,1), -CoM_eigenvectors(:,2), -CoM_eigenvectors(:,3)];
        case 15
            CoM_eigenvectors = [CoM_eigenvectors(:,1), -CoM_eigenvectors(:,3), CoM_eigenvectors(:,2)];
    end

    ivstring = [ivstring createInventorArrow(Centroid, CoM_eigenvectors(:,1)', 20, 0.5, [1, 0, 0], 0)];
    ivstring = [ivstring createInventorArrow(Centroid, CoM_eigenvectors(:,2)', 20, 0.5, [0, 1, 0], 0)];
    ivstring = [ivstring createInventorArrow(Centroid, CoM_eigenvectors(:,3)', 20, 0.5, [0, 0, 1], 0)];

    bone.(position(p)).(bonecode(b)).centroid = Centroid;
    bone.(position(p)).(bonecode(b)).vectors = CoM_eigenvectors;
    bone.(position(p)).(bonecode(b)).Inertia = RT_to_fX4(CoM_eigenvectors, Centroid);

end
name = append(position(p),'.iv');
fid = fopen(fullfile(directory_temp, name),"w");       %where data is being saved
fprintf(fid,ivstring);
fclose(fid);


%% Segmenting Position 10
ivstring = createInventorHeader();
p = 10;       %position
directory_temp = append(directory_general,'\',position(position(p)),hand);
for b = 1:15
    filename = append(participant,bonecode(b),file_version);
    ivstring = [ivstring createInventorLink(fullfile(directory_temp,filename), eye(3,3), [0,0,0], [0.7,0.7,0.7], 0.5)];
    [Centroid,SurfaceArea,Volume,CoM_ev123,CoM_eigenvectors,I1,I2,I_CoM,I_origin,patches] = mass_properties(fullfile(directory_temp,filename));
    
    switch b %columns are eigenvectors
        case 1
            CoM_eigenvectors = [CoM_eigenvectors(:,1), CoM_eigenvectors(:,3), -CoM_eigenvectors(:,2)];
        case 2
            CoM_eigenvectors = [CoM_eigenvectors(:,1), -CoM_eigenvectors(:,3), CoM_eigenvectors(:,2)];
        case 3
            CoM_eigenvectors = [-CoM_eigenvectors(:,3), -CoM_eigenvectors(:,2), -CoM_eigenvectors(:,1)];
        case 4
            CoM_eigenvectors = [CoM_eigenvectors(:,3), -CoM_eigenvectors(:,1), -CoM_eigenvectors(:,2)];
        case 5
            CoM_eigenvectors = [-CoM_eigenvectors(:,1), -CoM_eigenvectors(:,2), CoM_eigenvectors(:,3)];
        case 6
            CoM_eigenvectors = [-CoM_eigenvectors(:,2), CoM_eigenvectors(:,1), CoM_eigenvectors(:,3)];
        case 7
            CoM_eigenvectors = [CoM_eigenvectors(:,3), -CoM_eigenvectors(:,1), -CoM_eigenvectors(:,2)];
        case 8
            CoM_eigenvectors = [CoM_eigenvectors(:,3), -CoM_eigenvectors(:,1), -CoM_eigenvectors(:,2)];
        case 9
            CoM_eigenvectors = [CoM_eigenvectors(:,1), -CoM_eigenvectors(:,2), -CoM_eigenvectors(:,3)];
        case 10
            CoM_eigenvectors = [-CoM_eigenvectors(:,1), -CoM_eigenvectors(:,2), CoM_eigenvectors(:,3)];
        case 11
            CoM_eigenvectors = [CoM_eigenvectors(:,1), CoM_eigenvectors(:,3), -CoM_eigenvectors(:,2)];
        case 12
            CoM_eigenvectors = [CoM_eigenvectors(:,1),- CoM_eigenvectors(:,2), -CoM_eigenvectors(:,3)];
        case 13
            CoM_eigenvectors = [CoM_eigenvectors(:,1), -CoM_eigenvectors(:,2), -CoM_eigenvectors(:,3)];
        case 14
            CoM_eigenvectors = [CoM_eigenvectors(:,1), -CoM_eigenvectors(:,2), -CoM_eigenvectors(:,3)];
        case 15
            CoM_eigenvectors = [CoM_eigenvectors(:,1), CoM_eigenvectors(:,3), -CoM_eigenvectors(:,2)];
    end

    ivstring = [ivstring createInventorArrow(Centroid, CoM_eigenvectors(:,1)', 20, 0.5, [1, 0, 0], 0)];
    ivstring = [ivstring createInventorArrow(Centroid, CoM_eigenvectors(:,2)', 20, 0.5, [0, 1, 0], 0)];
    ivstring = [ivstring createInventorArrow(Centroid, CoM_eigenvectors(:,3)', 20, 0.5, [0, 0, 1], 0)];

    bone.(position(p)).(bonecode(b)).centroid = Centroid;
    bone.(position(p)).(bonecode(b)).vectors = CoM_eigenvectors;
    bone.(position(p)).(bonecode(b)).Inertia = RT_to_fX4(CoM_eigenvectors, Centroid);

end
name = append(position(p),'.iv');
fid = fopen(fullfile(directory_temp, name),"w");       %where data is being saved
fprintf(fid,ivstring);
fclose(fid);



%% Transformation Matrix
for p = positions       %change range for positions
    for b = 1:15
        bone.(position(p)).(bonecode(b)).transform = bone.(position(p)).(bonecode(b)).Inertia*bone.neutral.(bonecode(b)).Inertia^-1;
    end
end


%% ICP If needed
for p = positions       %change range for positions
    
    filename = append(participant,bonecode(1),file_version);
    
    
    [pts cnt] = read_vrml_fast(append(directory_general,'\',position(position(p)),hand,'\',filename));  %position 1
    q = pts(:,1:3);         %point cloud of 1st image
    q = q'
    [pts cnt] = read_vrml_fast(fullfile(directory_neutral,filename)); %neutral
    pnts = pts(:,1:3);         %point cloud of 2nd image
    pnts = pnts';
    
    %number of iterations is 3rd input
    
    [TR, TT, ER, t] = icp(q(1:3,:),pnts(1:3,:),20);
    
    
    %make rad transform 4x4
    bone.(position(p)).rad.transform = RT_to_fX4(TR,TT);

end


%% Saving

save(directory_general,'bone');    %where data is being saved


save()