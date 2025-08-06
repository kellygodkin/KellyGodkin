function D = sa_CMC_distance(mkr1, mkr2)
% DISTANCE - calculate distance between 2 ptm.

D = sqrt(sum(((mkr1-mkr2).^2),2));
%--------------------------------------------------------------------------