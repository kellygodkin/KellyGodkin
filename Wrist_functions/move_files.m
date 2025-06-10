% Clear environment
clc; clear;

% Define source and destination folders
sourceFolder = 'P:\Data\2025-04-09 Carpometacarpal Pilot\preprocessing\CMC001\Models\IV\original';
destinationFolder = 'P:\Data\2025-04-09 Carpometacarpal Pilot\CMC001\S15R\IV.files';

% Create destination folder if it doesn't exist
% if ~exist(destinationFolder, 'dir')
%     mkdir(destinationFolder);
% end

% Get list of files in the source folder (adjust extension as needed)
fileList = dir(fullfile(sourceFolder, '*.iv')); % Change *.txt to your file type

% Loop through files and copy with new names
for k = 1:length(fileList)
    oldFileName = fileList(k).name;
    
    oldFullPath = fullfile(sourceFolder, oldFileName);
    
    % Define new file name (you can customize the pattern here)
    newFileName = sprintf(append(oldFileName(8:10) ,'15R.iv'),k); % e.g., renamed_file_001.txt
    newFullPath = fullfile(destinationFolder, newFileName);

    % Copy and rename the file
    copyfile(oldFullPath, newFullPath);
    fprintf('Copied %s to %s\n', oldFileName, newFileName);
end
