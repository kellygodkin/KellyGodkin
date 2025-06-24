function [R T mag] = getInertialInfo(filename,boneIndex)


% filename = 'F:\LocalCopies\RelPinned\l\E03274\S15L\inertia15L.dat';
% boneIndex=2;

fid = fopen(filename);



if (boneIndex>15)
    return;
end;

%skip junk
for i=1:(boneIndex-1)*5,
    fgetl(fid);
end;


T = fscanf(fid, '%f%f%f\n', [1 3])';
mag = fscanf(fid, '%f%f%f\n', [1 3])';
R = fscanf(fid, '%f%f%f\n', [3 3])';

fclose(fid);