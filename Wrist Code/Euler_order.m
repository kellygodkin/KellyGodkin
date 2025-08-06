%% Euler Rotation
% Order ZYX
% as defined in A Thumb Carpometacarpal Joint Coordinate System Based on
% % Articular Surface Geometry - Eni Halilaj1, Michael J. Rainbow2, Christopher Got3, Douglas C. Moore3, and Joseph J.  Crisco1,3
% syms beta alpha theta
% 
% % Rotate about Z axis
% CS1_z = [cos(alpha) -sin(alpha) 0; sin(alpha) cos(alpha) 0; 0 0 1];
% 
% % Rotate about Y axis
% CS2_y = [cos(beta) 0 sin(beta); 0 1 0; -sin(beta) 0 cos(beta)];
% 
% % Rotate about X axis
% CS3_x = [1 0 0; 0 cos(theta) -sin(theta); 0 sin(theta) cos(theta)];
% 
% 
% %Combined Rotation
% Rotation_combined = CS1_z*CS2_y*CS3_x;
% Euler = [Rotation_combined]

eul(Matrix,"ZYX")