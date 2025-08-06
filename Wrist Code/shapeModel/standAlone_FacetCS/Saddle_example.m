


clear all
close all
clc
% addpath(genpath('C:\Users\anveb\Documents\Repositories'))
% addpath(genpath('C:\Users\anveb\OneDrive - The University of Queensland\Data'))
% addpath(genpath('C:\Users\anveb\OneDrive - The University of Queensland\Matlab Libraries'))
addpath(genpath("C:\Users\kelly\GitHub\SOL_Coding_Repo\Mesh"));

%% saddle function to test concept of curvature
[x y] = meshgrid(-25:25,-25:25);

% determine radii
xrad = 5;
yrad = 5;


% Number of points along one dimension
N = size(x,1);

% Initialize triangles array
triangles = [];

for i = 1:N-1
    for j = 1:N-1
        % Two triangles for each square
        triangles = [triangles;
                     sub2ind([N, N], i, j), sub2ind([N, N], i+1, j), sub2ind([N, N], i, j+1);
                     sub2ind([N, N], i+1, j), sub2ind([N, N], i+1, j+1), sub2ind([N, N], i, j+1)];
    end
end


%% upwards facing bowl
z_up = (x.^2)/(xrad) +(y.^2)/(yrad);

% Now you can use patch to visualize
h1 = patch('Vertices', [x(:) y(:) z_up(:)], 'Faces', triangles, 'FaceColor', 'cyan');
hold on
view([30, 30])
xlabel('X')
ylabel('Y')
zlabel('Z')
triangles = [triangles(:,1) triangles(:,3) triangles(:,2)]; 
patch2iv([x(:) y(:) z_up(:)], triangles, 'C:\Users\kelly\GitHub\SOL_Coding_Repo\Wrist Code\standAlone_FacetCS\test_code\test_bowl.iv' )


%% setup downwards facing bowl
z_down = -(x.^2)/xrad -(y.^2)/yrad;

% Now you can use patch to visualize
figure
h2 = patch('Vertices', [x(:) y(:) z_down(:)], 'Faces', triangles, 'FaceColor', 'cyan');
hold on
view([30, 30])
xlabel('X')
ylabel('Y')
zlabel('Z')
triangles = [triangles(:,1) triangles(:,3) triangles(:,2)]; 
patch2iv([x(:) y(:) z_down(:)], triangles ,'C:\Users\kelly\GitHub\SOL_Coding_Repo\Wrist Code\standAlone_FacetCS\test_code\test_bowldown.iv')


%% make saddle out of it
z_saddle = (x.^2)/xrad -(y.^2)/yrad; % same curvature of in both directions

% Now you can use patch to visualize
figure
h3 = patch('Vertices', [x(:) y(:) z_saddle(:)], 'Faces', triangles, 'FaceColor', 'cyan');hold on
view([30, 30])
xlabel('X')
ylabel('Y')
zlabel('Z')
triangles = [triangles(:,1) triangles(:,3) triangles(:,2)]; 
patch2iv([x(:) y(:) z_saddle(:)], triangles ,'C:\Users\kelly\GitHub\SOL_Coding_Repo\Wrist Code\standAlone_FacetCS\test_code\test_saddle.iv')

%% make saddle out of it and flip it
z_saddle = -((x.^2)/xrad -(y.^2)/yrad); % same curvature of in both directions

% Now you can use patch to visualize
figure
h4 = patch('Vertices', [x(:) y(:) z_saddle(:)], 'Faces', triangles, 'FaceColor', 'cyan');hold on
view([30, 30])
xlabel('X')
ylabel('Y')
zlabel('Z')
triangles = [triangles(:,1) triangles(:,3) triangles(:,2)]; 
patch2iv([x(:) y(:) z_saddle(:)], triangles ,'C:\Users\kelly\GitHub\SOL_Coding_Repo\Wrist Code\standAlone_FacetCS\test_code\test_saddle_flipped.iv')

