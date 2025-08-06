function [avgHAM,num] = sa_calcAvgMotion(kinemat,checkNums)
% Usage:   [avgHAM, num] = calcAvgMotion(kinemat, checkNums)
%
% Inputs:   kinemat -   a) a kinemat structure, pre-loaded
%                       b) a kinemat file name, not yet loaded
%                       c) a list of HAMs
%
%		    checkNums(optional) - array of numbers corresponding to kinemat
%		    rows to check  (ie checkNums = 2:5, only use kinemat(2:5))
%
% Outputs:   avgHAM - the Average HAM
%            num - The number of subjects and series that went INTO that average HAM
%

count = 0;
if isa(kinemat, 'double') % If input is a list of HAMs, process it
    for ii = 1:size(kinemat,1)
        count = count + 1;
        myHAM = kinemat(count,:);
        if myHAM(1) < 3   
            disp('Skipped.  Angle too small.');
        else
            % Convert quaternion to a numeric vector immediately
            q = sa_quaternion(kinemat(count,2:4), kinemat(count,1) * pi/180);
            allQuat( count, : ) = compactQuaternion(q);  % Store directly as numeric array

            if (ii ~= 1)
                gg = abs(dot(allQuat(count, :), allQuat(1, :)));
            end
            allHAM(count,:) = myHAM;
        end
    end
    avgHAM = avgCalc(allQuat, allHAM, count);
else
    if isa(kinemat, 'char') % See if it's a file name
        kinemat = load(kinemat);
    end
    if ~exist('checkNums','var')
        checkNums = 1:size(kinemat,2);
    end
    for boneCount = 1:size(kinemat(1).selBone,1)
        count = 0;
        for subjCount = checkNums
            for serCount = 1:size(kinemat(subjCount).RTdata,1)
                count = count + 1;
                myHAM = kinemat(subjCount).RTdata{serCount,3}(boneCount,:);
                if myHAM(1) < 1
                    count = count -1;
                    disp('Skipped.  Angle too small.');
                else
                    % Convert quaternion to numeric vector immediately
                    q = sa_quaternion(myHAM(2:4), myHAM(1) * pi/180);
                    allQuat(count, :) = compact(q);  % Store as numeric array
                    allHAM(count,:) = myHAM;
                    
                    if (count ~= 1)
                        gg = abs(dot(allQuat(count, :), allQuat(1, :)));
                    end
                end
            end
        end
        avgHAM = avgCalc(allQuat, allHAM, count);
        num = size(allQuat,1);
    end
end

end  % End of sa_calcAvgMotion function

%% Function to compute average motion
function [avgHAM] = avgCalc(allQuat, allHAM, count)
if count == 1
    warning('Only averaging one position');
end

% Ensure allQuat is a numeric matrix
quatMatrix = allQuat; % No need for cell2mat, allQuat is now numeric

% Compute quaternion sum
sumQuat = sum(quatMatrix, 1);
avgQuat = sumQuat / norm(sumQuat);

% Convert quaternion to axis-angle representation
avgPhi = 2 * acos(avgQuat(1)) * 180/pi;
avgN = avgQuat(2:4);
avgN = avgN / norm(avgN);

% Compute average translation
avgT = sum(allHAM(:,5),1) / count;
avgQLoc = sum(allHAM(:,6:8),1) / count;

avgHAM = [avgPhi, avgN, avgT, avgQLoc];

end  % End of avgCalc function
