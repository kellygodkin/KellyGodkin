function [subjectInfo] = getSubjectFilePath(subjectBasePath, side)
%function designed to return the file paths for subjects. (Only really
%working for phaseII subjects and later right now)

%lets get the basic information
[parrent subject] = fileparts(fileparts(fullfile(subjectBasePath,'junk')));
if (length(subject)~=6 || regexpi(subject,'CMC\d{3}')~=1)
    error('Wrist:BadSubject', 'Invalid subject number: "%s"',subject);
end;

subjectInfo.parrentDirectory = parrent;
subjectInfo.subject = subject;

%now lets search for neutral series
subjectInfo.neutralSeries = sprintf('S15%s',side);
subjectInfo.neutralSeriesPath = fullfile(subjectBasePath,sprintf('S15%s',side));
hasNeutral = exist(subjectInfo.neutralSeriesPath,'dir')==7;
if (~hasNeutral)
    error('Wrist:NoNeutralFound', 'Unable to find neutral series folder (looked for: %s)',subjectInfo.neutralSeriesPath);
end;

radStack = sprintf('rad15%s.stack',side);
radIV = sprintf('rad15%s.iv',side);
if (exist(fullfile(subjectInfo.neutralSeriesPath,radStack),'file')==2),
    subjectInfo.stackPath = subjectInfo.neutralSeriesPath;
elseif (exist(fullfile(subjectInfo.neutralSeriesPath,'Stack.files',radStack),'file')==2),
    subjectInfo.stackPath = fullfile(subjectInfo.neutralSeriesPath,'Stack.files');
else
    warning('Wrist:NoStack','Unable to find stack file directory for neutral series');
end;
if (exist(fullfile(subjectInfo.neutralSeriesPath,radIV),'file')==2),
    subjectInfo.ivPath = subjectInfo.neutralSeriesPath;
elseif (exist(fullfile(subjectInfo.neutralSeriesPath,'IV.files',radIV),'file')==2),
    subjectInfo.ivPath = fullfile(subjectInfo.neutralSeriesPath,'IV.files');
else
    warning('Wrist:NoIV','Unable to find IV file directory for neutral series');
end;

subjectInfo.acsFile = fullfile(subjectInfo.neutralSeriesPath,'AnatCoordSys.dat');

inertiaFname = sprintf('inertia15%s.dat',side);
volumeFname = sprintf('volume15%s.dat',side);
if (exist(fullfile(subjectInfo.neutralSeriesPath,'IV_inert_vol',inertiaFname),'file')==2),
    subjectInfo.inertiaFile = fullfile(subjectInfo.neutralSeriesPath,'IV_inert_vol',inertiaFname);
    subjectInfo.volumeFile = fullfile(subjectInfo.neutralSeriesPath,'IV_inert_vol',volumeFname);
elseif (exist(fullfile(subjectInfo.neutralSeriesPath,inertiaFname),'file')==2),
    subjectInfo.inertiaFile = fullfile(subjectInfo.neutralSeriesPath,inertiaFname);
    subjectInfo.volumeFile = fullfile(subjectInfo.neutralSeriesPath,volumeFname);
else
    warning('Wrist:NoInertia','Unable to find inertia file for neutral series');
end;
    
%now lets try and find all series
folders = dir(fullfile(subjectBasePath,sprintf('S*%s',side)));
series = cell(1,length(folders));
series{1} = subjectInfo.neutralSeries; %put the neutral series in first :)
seriesCount = 1;
for i=1:length(folders)
    if (length(regexpi(folders(i).name,sprintf('S\\d\\d%s',side)))==1 && ~strcmp(folders(i).name(2:3),'15'))
        seriesCount = seriesCount+1;
        series{seriesCount} = folders(i).name;
    end;
end;
series(seriesCount+1:end) = []; %delete extra space that was pre-allocated.
subjectInfo.series = series;

%now lets try and fine the motion files
motion = cell(1,length(series));
motion{1} = ''; %set motion file for neutral posture as empty string.
for i=2:length(series), %skip the neutral 15 series, we know it has no motion file
    mFile = fullfile(subjectBasePath,series{i},sprintf('motion15%s%s.dat',side,series{i}(2:4)));
    if (exist(mFile,'file')==2)
        motion{i} = mFile;
    else
        motion{i} = '';
        warning('Wrist:MissingMotionFile','Unable to find motion file for series: %s',series{i});
    end;    
end;
subjectInfo.motionFiles = motion;