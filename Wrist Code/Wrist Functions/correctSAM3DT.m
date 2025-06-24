function T = correctSAM3DT(tra)
% transforms SAM3D to wrist format
% Ensure that the T transforms still need to be flipped (*-1)** 
rows = length(tra(:,1));
for r = rows
    T = (reshape(tra(r,1:16),4,4))';
    T(3,1) = -T(3,1);
    T(3,2) = -T(3,2);
    T(1,3) = -T(1,3);
    T(2,3) = -T(2,3);
    T(1,4) = -T(1,4);
    T(2,4) = -T(2,4); 
        
end
