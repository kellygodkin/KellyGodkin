%% Make directories
%{ 
    to make file directoris first section creates Iv and transform
    directories
    By Kelly Godkin
    last edited: May 27, 2025
%} 
clear all
clc


preprocessing_dir =   'P:\Data\2025-04-09 Carpometacarpal Pilot\preprocessing';  % preprocessing directory 
filepath_base =  'P:\Data\2025-04-09 Carpometacarpal Pilot';       % base for final data
participants = 1 ;     % set as number of participants
prefix = {'CMC'};       % set as preferred prefix for file dir
positions = [02,03,04,05,06,07,08,09,10,15];



for s = 1:participants
    if s < 10
        subjects(s,1) = append(prefix,'00',num2str(s));
    elseif s < 100
        subjects(s,1) = append(prefix,'0',num2str(s));
    else
        subjects(s,1) = append(prefix,num2str(s));
    end
end


%% Make final data directories

for s = 1: length(subjects)
    % subject folder
    
    maindir = fullfile(filepath_base, subjects{s});
    mkdir(filepath_base, subjects{s});
    for p = positions
        if p == 15
            mkdir(maindir,['S' num2str(p) 'R'])
            mkdir(fullfile(maindir,['S' num2str(p) 'R']),'IV.files')
        elseif p <10
            mkdir(maindir,['S0' num2str(p) 'R'])
        else
            mkdir(maindir,['S' num2str(p) 'R'])
        end
    end
end


%% Create Preprocessing work folders

for s = 1: length(subjects)
    % subject folder
    maindir2 = fullfile(preprocessing_dir, subjects{s});
    mkdir(preprocessing_dir, subjects{s});
    mkdir(maindir2,'Models')
    mkdir(fullfile(maindir2,'Models'),'IV')
    mkdir(fullfile(maindir2,'Models'),'stl')
    mkdir(fullfile(maindir2,'Models'),'Segmentation')
    mkdir(fullfile(maindir2,'Models'),'Visualizations')
    % mkdir(fullfile(maindir{s},'Models','Visualizations')
    mkdir(maindir2,'Animation')
    mkdir(fullfile(maindir2,'Animation'),'cap')
    mkdir(fullfile(maindir2,'Animation'),'rad')
    mkdir(fullfile(maindir2,'Animation'),'tpm')
    mkdir(maindir2,'transformation')
    mkdir(fullfile(maindir2,'transformation'),'cap')
    mkdir(fullfile(maindir2,'transformation'),'rad')
    mkdir(fullfile(maindir2,'transformation'),'tpm')
    mkdir(fullfile(maindir2,'transformation'),'original')
    mkdir(fullfile(maindir2,'transformation','cap'),'Autoscoper')
    mkdir(fullfile(maindir2,'transformation','rad'),'Autoscoper')
    mkdir(fullfile(maindir2,'transformation','tpm'),'Autoscoper')
end

