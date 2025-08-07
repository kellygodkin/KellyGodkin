%% Fix Coordinate Systems
% edit coordinate systems to align correctly with the csys
% need to modify the changes per participant (code 1a)
load(fullfile(filepath_base,'preprocessing\structures\bonestruct.mat'),"bonestruct");

% Skip rad and uln as they have specific coordinate systems

% for par 1:
s = 1;
% sca
b = 3;
X = bonestruct.(bonecode_hand(b))(s).csys(1:3,1);
Y = bonestruct.(bonecode_hand(b))(s).csys(1:3,2);
Z = bonestruct.(bonecode_hand(b))(s).csys(1:3,3);
T = bonestruct.(bonecode_hand(b))(s).csys(1:3,4);
x = X;
y = -Y;
z = -Z;
bonestruct.(bonecode_hand(b))(s).csys_fixed = [x(1:3),y(1:3),z(1:3),T;0,0,0,1];

% lun
b = 4;
X = bonestruct.(bonecode_hand(b))(s).csys(1:3,1);
Y = bonestruct.(bonecode_hand(b))(s).csys(1:3,2);
Z = bonestruct.(bonecode_hand(b))(s).csys(1:3,3);
T = bonestruct.(bonecode_hand(b))(s).csys(1:3,4);
x = -X;
y = Y;
z = -Z;
bonestruct.(bonecode_hand(b))(s).csys_fixed = [x(1:3),y(1:3),z(1:3),T;0,0,0,1];

% trq
b = 5;
X = bonestruct.(bonecode_hand(b))(s).csys(1:3,1);
Y = bonestruct.(bonecode_hand(b))(s).csys(1:3,2);
Z = bonestruct.(bonecode_hand(b))(s).csys(1:3,3);
T = bonestruct.(bonecode_hand(b))(s).csys(1:3,4);
x = X;
y = Y;
z = Z;
bonestruct.(bonecode_hand(b))(s).csys_fixed = [x(1:3),y(1:3),z(1:3),T;0,0,0,1];

% pis
b = 6;
X = bonestruct.(bonecode_hand(b))(s).csys(1:3,1);
Y = bonestruct.(bonecode_hand(b))(s).csys(1:3,2);
Z = bonestruct.(bonecode_hand(b))(s).csys(1:3,3);
T = bonestruct.(bonecode_hand(b))(s).csys(1:3,4);
x = X;
y = -Z;
z = Y;
bonestruct.(bonecode_hand(b))(s).csys_fixed = [x(1:3),y(1:3),z(1:3),T;0,0,0,1];


% tpd
b = 7;
X = bonestruct.(bonecode_hand(b))(s).csys(1:3,1);
Y = bonestruct.(bonecode_hand(b))(s).csys(1:3,2);
Z = bonestruct.(bonecode_hand(b))(s).csys(1:3,3);
T = bonestruct.(bonecode_hand(b))(s).csys(1:3,4);
x = X;
y = Y;
z = Z;
bonestruct.(bonecode_hand(b))(s).csys_fixed = [x(1:3),y(1:3),z(1:3),T;0,0,0,1];

% tpm
b = 8;
X = bonestruct.(bonecode_hand(b))(s).csys(1:3,1);
Y = bonestruct.(bonecode_hand(b))(s).csys(1:3,2);
Z = bonestruct.(bonecode_hand(b))(s).csys(1:3,3);
T = bonestruct.(bonecode_hand(b))(s).csys(1:3,4);
x = -X;
y = Y;
z = -Z;
bonestruct.(bonecode_hand(b))(s).csys_fixed = [x(1:3),y(1:3),z(1:3),T;0,0,0,1];

% cap
b = 9;
X = bonestruct.(bonecode_hand(b))(s).csys(1:3,1);
Y = bonestruct.(bonecode_hand(b))(s).csys(1:3,2);
Z = bonestruct.(bonecode_hand(b))(s).csys(1:3,3);
T = bonestruct.(bonecode_hand(b))(s).csys(1:3,4);
x = X;
y = -Y;
z = -Z;
bonestruct.(bonecode_hand(b))(s).csys_fixed = [x(1:3),y(1:3),z(1:3),T;0,0,0,1];

% ham
b = 10;
X = bonestruct.(bonecode_hand(b))(s).csys(1:3,1);
Y = bonestruct.(bonecode_hand(b))(s).csys(1:3,2);
Z = bonestruct.(bonecode_hand(b))(s).csys(1:3,3);
T = bonestruct.(bonecode_hand(b))(s).csys(1:3,4);
x = -X;
y = -Y;
z = Z;
bonestruct.(bonecode_hand(b))(s).csys_fixed = [x(1:3),y(1:3),z(1:3),T;0,0,0,1];

% mc1
b = 11;
X = bonestruct.(bonecode_hand(b))(s).csys(1:3,1);
Y = bonestruct.(bonecode_hand(b))(s).csys(1:3,2);
Z = bonestruct.(bonecode_hand(b))(s).csys(1:3,3);
T = bonestruct.(bonecode_hand(b))(s).csys(1:3,4);
x = X;
y = -Z;
z = Y;
bonestruct.(bonecode_hand(b))(s).csys_fixed = [x(1:3),y(1:3),z(1:3),T;0,0,0,1];

% mc2
b = 12;
X = bonestruct.(bonecode_hand(b))(s).csys(1:3,1);
Y = bonestruct.(bonecode_hand(b))(s).csys(1:3,2);
Z = bonestruct.(bonecode_hand(b))(s).csys(1:3,3);
T = bonestruct.(bonecode_hand(b))(s).csys(1:3,4);
x = X;
y = Y;
z = Z;
bonestruct.(bonecode_hand(b))(s).csys_fixed = [x(1:3),y(1:3),z(1:3),T;0,0,0,1];

% mc3
b = 13;
X = bonestruct.(bonecode_hand(b))(s).csys(1:3,1);
Y = bonestruct.(bonecode_hand(b))(s).csys(1:3,2);
Z = bonestruct.(bonecode_hand(b))(s).csys(1:3,3);
T = bonestruct.(bonecode_hand(b))(s).csys(1:3,4);
x = X;
y = Y;
z = Z;
bonestruct.(bonecode_hand(b))(s).csys_fixed = [x(1:3),y(1:3),z(1:3),T;0,0,0,1];

% mc4
b = 14;
X = bonestruct.(bonecode_hand(b))(s).csys(1:3,1);
Y = bonestruct.(bonecode_hand(b))(s).csys(1:3,2);
Z = bonestruct.(bonecode_hand(b))(s).csys(1:3,3);
T = bonestruct.(bonecode_hand(b))(s).csys(1:3,4);
x = X;
y = -Y;
z = -Z;
bonestruct.(bonecode_hand(b))(s).csys_fixed = [x(1:3),y(1:3),z(1:3),T;0,0,0,1];

% mc5
b = 15;
X = bonestruct.(bonecode_hand(b))(s).csys(1:3,1);
Y = bonestruct.(bonecode_hand(b))(s).csys(1:3,2);
Z = bonestruct.(bonecode_hand(b))(s).csys(1:3,3);
T = bonestruct.(bonecode_hand(b))(s).csys(1:3,4);
x = X;
y = Z;
z = -Y;
bonestruct.(bonecode_hand(b))(s).csys_fixed = [x(1:3),y(1:3),z(1:3),T;0,0,0,1];

% ts1
b = 18;
X = bonestruct.(bonecode_hand(b))(s).csys(1:3,1);
Y = bonestruct.(bonecode_hand(b))(s).csys(1:3,2);
Z = bonestruct.(bonecode_hand(b))(s).csys(1:3,3);
T = bonestruct.(bonecode_hand(b))(s).csys(1:3,4);
x = Y;
y = -Z;
z = -X;
bonestruct.(bonecode_hand(b))(s).csys_fixed = [x(1:3),y(1:3),z(1:3),T;0,0,0,1];

% ts2
b = 19;
X = bonestruct.(bonecode_hand(b))(s).csys(1:3,1);
Y = bonestruct.(bonecode_hand(b))(s).csys(1:3,2);
Z = bonestruct.(bonecode_hand(b))(s).csys(1:3,3);
T = bonestruct.(bonecode_hand(b))(s).csys(1:3,4);
x = X;
y = -Z;
z = Y;
bonestruct.(bonecode_hand(b))(s).csys_fixed = [x(1:3),y(1:3),z(1:3),T;0,0,0,1];

% pp1
b = 16;
X = bonestruct.(bonecode_hand(b))(s).csys(1:3,1);
Y = bonestruct.(bonecode_hand(b))(s).csys(1:3,2);
Z = bonestruct.(bonecode_hand(b))(s).csys(1:3,3);
T = bonestruct.(bonecode_hand(b))(s).csys(1:3,4);
x = X;
y = -Z;
z = Y;
bonestruct.(bonecode_hand(b))(s).csys_fixed = [x(1:3),y(1:3),z(1:3),T;0,0,0,1];

% dp1
b = 17;
X = bonestruct.(bonecode_hand(b))(s).csys(1:3,1);
Y = bonestruct.(bonecode_hand(b))(s).csys(1:3,2);
Z = bonestruct.(bonecode_hand(b))(s).csys(1:3,3);
T = bonestruct.(bonecode_hand(b))(s).csys(1:3,4);
x = X;
y = -Z;
z = Y;
bonestruct.(bonecode_hand(b))(s).csys_fixed = [x(1:3),y(1:3),z(1:3),T;0,0,0,1];

%% Fingers

% pp2
b = 20;
X = bonestruct.(bonecode_hand(b))(s).csys(1:3,1);
Y = bonestruct.(bonecode_hand(b))(s).csys(1:3,2);
Z = bonestruct.(bonecode_hand(b))(s).csys(1:3,3);
T = bonestruct.(bonecode_hand(b))(s).csys(1:3,4);
x = X;
y = -Z;
z = Y;
bonestruct.(bonecode_hand(b))(s).csys_fixed = [x(1:3),y(1:3),z(1:3),T;0,0,0,1];

% mp2
b = 21;
X = bonestruct.(bonecode_hand(b))(s).csys(1:3,1);
Y = bonestruct.(bonecode_hand(b))(s).csys(1:3,2);
Z = bonestruct.(bonecode_hand(b))(s).csys(1:3,3);
T = bonestruct.(bonecode_hand(b))(s).csys(1:3,4);
x = -X;
y = Z;
z = Y;
bonestruct.(bonecode_hand(b))(s).csys_fixed = [x(1:3),y(1:3),z(1:3),T;0,0,0,1];

% dp2
b = 22;
X = bonestruct.(bonecode_hand(b))(s).csys(1:3,1);
Y = bonestruct.(bonecode_hand(b))(s).csys(1:3,2);
Z = bonestruct.(bonecode_hand(b))(s).csys(1:3,3);
T = bonestruct.(bonecode_hand(b))(s).csys(1:3,4);
x = -X;
y = -Z;
z = -Y;
bonestruct.(bonecode_hand(b))(s).csys_fixed = [x(1:3),y(1:3),z(1:3),T;0,0,0,1];

% pp3
b = 23;
X = bonestruct.(bonecode_hand(b))(s).csys(1:3,1);
Y = bonestruct.(bonecode_hand(b))(s).csys(1:3,2);
Z = bonestruct.(bonecode_hand(b))(s).csys(1:3,3);
T = bonestruct.(bonecode_hand(b))(s).csys(1:3,4);
x = X;
y = -Z;
z = Y;
bonestruct.(bonecode_hand(b))(s).csys_fixed = [x(1:3),y(1:3),z(1:3),T;0,0,0,1];

% mp3
b = 24;
X = bonestruct.(bonecode_hand(b))(s).csys(1:3,1);
Y = bonestruct.(bonecode_hand(b))(s).csys(1:3,2);
Z = bonestruct.(bonecode_hand(b))(s).csys(1:3,3);
T = bonestruct.(bonecode_hand(b))(s).csys(1:3,4);
x = X;
y = Z;
z = -Y;
bonestruct.(bonecode_hand(b))(s).csys_fixed = [x(1:3),y(1:3),z(1:3),T;0,0,0,1];

% dp3
b = 25;
X = bonestruct.(bonecode_hand(b))(s).csys(1:3,1);
Y = bonestruct.(bonecode_hand(b))(s).csys(1:3,2);
Z = bonestruct.(bonecode_hand(b))(s).csys(1:3,3);
T = bonestruct.(bonecode_hand(b))(s).csys(1:3,4);
x = -X;
y = -Z;
z = -Y;
bonestruct.(bonecode_hand(b))(s).csys_fixed = [x(1:3),y(1:3),z(1:3),T;0,0,0,1];

% pp4
b = 26;
X = bonestruct.(bonecode_hand(b))(s).csys(1:3,1);
Y = bonestruct.(bonecode_hand(b))(s).csys(1:3,2);
Z = bonestruct.(bonecode_hand(b))(s).csys(1:3,3);
T = bonestruct.(bonecode_hand(b))(s).csys(1:3,4);
x = X;
y = -Z;
z = Y;
bonestruct.(bonecode_hand(b))(s).csys_fixed = [x(1:3),y(1:3),z(1:3),T;0,0,0,1];

% mp4
b = 27;
X = bonestruct.(bonecode_hand(b))(s).csys(1:3,1);
Y = bonestruct.(bonecode_hand(b))(s).csys(1:3,2);
Z = bonestruct.(bonecode_hand(b))(s).csys(1:3,3);
T = bonestruct.(bonecode_hand(b))(s).csys(1:3,4);
x = -X;
y = Z;
z = Y;
bonestruct.(bonecode_hand(b))(s).csys_fixed = [x(1:3),y(1:3),z(1:3),T;0,0,0,1];

% dp4
b = 28;
X = bonestruct.(bonecode_hand(b))(s).csys(1:3,1);
Y = bonestruct.(bonecode_hand(b))(s).csys(1:3,2);
Z = bonestruct.(bonecode_hand(b))(s).csys(1:3,3);
T = bonestruct.(bonecode_hand(b))(s).csys(1:3,4);
x = -X;
y = -Y;
z = Z;
bonestruct.(bonecode_hand(b))(s).csys_fixed = [x(1:3),y(1:3),z(1:3),T;0,0,0,1];

% pp5
b = 29;
X = bonestruct.(bonecode_hand(b))(s).csys(1:3,1);
Y = bonestruct.(bonecode_hand(b))(s).csys(1:3,2);
Z = bonestruct.(bonecode_hand(b))(s).csys(1:3,3);
T = bonestruct.(bonecode_hand(b))(s).csys(1:3,4);
x = X;
y = -Z;
z = -Y;
bonestruct.(bonecode_hand(b))(s).csys_fixed = [x(1:3),y(1:3),z(1:3),T;0,0,0,1];

% mp5
b = 30;
X = bonestruct.(bonecode_hand(b))(s).csys(1:3,1);
Y = bonestruct.(bonecode_hand(b))(s).csys(1:3,2);
Z = bonestruct.(bonecode_hand(b))(s).csys(1:3,3);
T = bonestruct.(bonecode_hand(b))(s).csys(1:3,4);
x = X;
y = Z;
z = -Y;
bonestruct.(bonecode_hand(b))(s).csys_fixed = [x(1:3),y(1:3),z(1:3),T;0,0,0,1];

% dp5
b = 31;
X = bonestruct.(bonecode_hand(b))(s).csys(1:3,1);
Y = bonestruct.(bonecode_hand(b))(s).csys(1:3,2);
Z = bonestruct.(bonecode_hand(b))(s).csys(1:3,3);
T = bonestruct.(bonecode_hand(b))(s).csys(1:3,4);
x = -X;
y = -Z;
z = -Y;
bonestruct.(bonecode_hand(b))(s).csys_fixed = [x(1:3),y(1:3),z(1:3),T;0,0,0,1];

save(fullfile(filepath_base,'preprocessing\structures\bonestruct_new.mat'),"bonestruct");