function [inertialACS, inertial_pts] = rotateInertialBones2(reference_bone, input_bone, varargin)
% Add description here
% INPUTS:
%		1. 'reference_bone', the INERTIALLY ALIGNED reference bone that all
%		others will align to, points and connections should be in this
%		2. 'input_bone', the bone to be rotated to match the reference
%		bone, points and connections should be in this
%       3. 'num' is the participant number (A STRING) that can be added so you can
%       track where you are at in the rotations
% OUTPUTS:
%		1. inertialACS - the inertial ACS
%		2. inertialpts - the inertial points
% __________________________________________________________________________________________________
%% downsample the bones if necessary, with a target of 15000 pts (this is an initial guess to see if it makes sense and works)
if length(input_bone.pts) > 15000
    % Set the target number of points
    desiredNumPoints = 2000;
    % Initial reduction factor
    reductionFactor = desiredNumPoints/length(input_bone.pts);
    [downsampled_input_bone.cnt, downsampled_input_bone.pts] = reducepatch(input_bone.cnt, input_bone.pts, reductionFactor);
end
if length(reference_bone.pts) > 5000
    % Set the target number of points
    desiredNumPoints = 2000;
    % Initial reduction factor
    reductionFactor = desiredNumPoints/length(reference_bone.pts);
    % Iteratively adjust the reduction factor to achieve the desired number of points
    [downsampled_reference_bone.cnt, downsampled_reference_bone.pts] = reducepatch(reference_bone.cnt, reference_bone.pts, reductionFactor);
end
if exist('downsampled_reference_bone', 'var')
    inertial_reference_bone.pts = downsampled_reference_bone.pts;
    inertial_reference_bone.cnt = downsampled_reference_bone.cnt;
else
    inertial_reference_bone.pts = reference_bone.pts;
    inertial_reference_bone.cnt = reference_bone.cnt;
end


%% align the input_bone to its own inertial axis
% find inertial ACS from original sized bones
[centroid,~,~,~,inertialACS, ~,~,~,~,~] = mass_properties(input_bone.pts, input_bone.cnt);
inertialACS = [inertialACS centroid';[0 0 0 1]];
%inertially align the input bone -- or the downsampled one if it exists
if exist('downsampled_input_bone', 'var')
    inertial_input_bone.pts = transformPoints(inertialACS, downsampled_input_bone.pts, -1);
    inertial_input_bone.cnt = downsampled_input_bone.cnt;
else
    inertial_input_bone.pts = transformPoints(inertialACS, input_bone.pts, -1);
    inertial_input_bone.cnt = input_bone.cnt;
end


%% visualise to see if rotations need to take place
col1 = [rand rand rand]; col2 = [rand rand rand];
% Create the main figure and set it to full screen
screenSize = get(0, 'ScreenSize'); fig = uifigure('Name', 'Manually rotating inertial bones', 'Position', [0, 0, screenSize(3), screenSize(4)]);
% Create a 2x1 grid layout for the plots and buttons (if no title)
if isempty(varargin)
    gl_main = uigridlayout(fig, [2, 1]);
    gl_main.RowHeight = {'9x', '1x'};
else
    % Create a 3x1 grid layout for the title, plots, and buttons (if title provided)
    gl_main = uigridlayout(fig, [3, 1]);
    gl_main.RowHeight = {'1x', '8x', '1x'};
    % Add a title to the figure
    lblTitle = uilabel(gl_main, 'Text', varargin{1}, 'FontSize', 20, 'HorizontalAlignment', 'center');
    lblTitle.Layout.Row = 1;
    lblTitle.Layout.Column = 1;
end
gl_main.ColumnWidth = {'1x'};
% Create a 1x3 grid layout for the plots
gl_plots = uigridlayout(gl_main, [1, 3]);
if isempty(varargin)
    gl_plots.Layout.Row = 1;
else
    gl_plots.Layout.Row = 2;
end
gl_plots.RowHeight = {'1x'};gl_plots.ColumnWidth = {'1x', '1x', '1x'};
% Create the axes and set viewpoints
ax1 = uiaxes(gl_plots);ax1.Layout.Row = 1;ax1.Layout.Column = 1;hold(ax1, 'on');axis(ax1, 'equal');view(ax1, [0 -90]);
ax2 = uiaxes(gl_plots);ax2.Layout.Row = 1;ax2.Layout.Column = 2;hold(ax2, 'on');axis(ax2, 'equal');view(ax2, [80 0]);
ax3 = uiaxes(gl_plots);ax3.Layout.Row = 1;ax3.Layout.Column = 3;hold(ax3, 'on');axis(ax3, 'equal');view(ax3, [0 0]);


% Create a 1x5 grid layout for the buttons (added new button)
gl_buttons = uigridlayout(gl_main, [1, 6]);
if isempty(varargin)
    gl_buttons.Layout.Row = 2;
else
    gl_buttons.Layout.Row = 3;
end
gl_buttons.ColumnWidth = {'1x', '1x', '1x', '1x', '1x', '1x'};
% Add buttons
btn_flipX = uibutton(gl_buttons, 'Text', 'Flip X', 'ButtonPushedFcn', @(btn,event)buttonCallback(1));
btn_flipY = uibutton(gl_buttons, 'Text', 'Flip Y', 'ButtonPushedFcn', @(btn,event)buttonCallback(2));
btn_flipZ = uibutton(gl_buttons, 'Text', 'Flip Z', 'ButtonPushedFcn', @(btn,event)buttonCallback(3));
btn_rotateX90 = uibutton(gl_buttons, 'Text', 'Rotate 90° X', 'ButtonPushedFcn', @(btn,event)buttonCallback(5)); % New button for 90-degree rotation
btn_rotateY90 = uibutton(gl_buttons, 'Text', 'Rotate 90° Y', 'ButtonPushedFcn', @(btn,event)buttonCallback(6));
btn_noRotation = uibutton(gl_buttons, 'Text', 'No Rotation', 'ButtonPushedFcn', @(btn,event)buttonCallback(4));

%% stop this function from 'finishing'



%% add patches of the reference bone and the input bone
h1 = patch(ax1, 'Vertices', inertial_reference_bone.pts, 'Faces', inertial_reference_bone.cnt, 'EdgeAlpha', 0.2, 'FaceAlpha', 0.5, 'FaceColor', col1);
h2 = patch(ax1, 'Vertices', inertial_input_bone.pts, 'Faces', inertial_input_bone.cnt, 'EdgeAlpha', 0.2, 'FaceAlpha', 0.5, 'FaceColor', col2);

h1 = patch(ax2, 'Vertices', inertial_reference_bone.pts, 'Faces', inertial_reference_bone.cnt, 'EdgeAlpha', 0.2, 'FaceAlpha', 0.5, 'FaceColor', col1);
h2 = patch(ax2, 'Vertices', inertial_input_bone.pts, 'Faces', inertial_input_bone.cnt, 'EdgeAlpha', 0.2, 'FaceAlpha', 0.5, 'FaceColor', col2);

h1 = patch(ax3, 'Vertices', inertial_reference_bone.pts, 'Faces', inertial_reference_bone.cnt, 'EdgeAlpha', 0.2, 'FaceAlpha', 0.5, 'FaceColor', col1);
h2 = patch(ax3, 'Vertices', inertial_input_bone.pts, 'Faces', inertial_input_bone.cnt, 'EdgeAlpha', 0.2, 'FaceAlpha', 0.5, 'FaceColor', col2);


%add legends
legend(ax1, [h1, h2], {'reference bone', varargin{1}});
legend(ax2, [h1, h2], {'reference bone', varargin{1}});
legend(ax3, [h1, h2], {'reference bone', varargin{1}});
%% define each button
uiwait(fig)
    function buttonCallback(option)
        switch option
            case 1 % Flip X
                flipMatrix = diag([-1, 1, 1]);
                inertialACS(1:3, 1:3) = inertialACS(1:3, 1:3) * flipMatrix;            
            case 2 % Flip Y
                flipMatrix = diag([1, -1, 1]);
                inertialACS(1:3, 1:3) = inertialACS(1:3, 1:3) * flipMatrix;
            case 3 % Flip Z
                flipMatrix = diag([1, 1, -1]);
                inertialACS(1:3, 1:3) = inertialACS(1:3, 1:3) * flipMatrix;
            case 5 % Rotate 90 degrees around X
                rotationMatrix = [1 0 0; 0 cosd(90) -sind(90); 0 sind(90) cosd(90)];
                inertialACS(1:3, 1:3) = inertialACS(1:3, 1:3) * rotationMatrix;
            case 6 % Rotate 90 degrees around X
                rotationMatrix = [0 1 0; cosd(90) 0 -sind(90); sind(90) 0 cosd(90)];
                inertialACS(1:3, 1:3) = inertialACS(1:3, 1:3) * rotationMatrix;
            case 4 % No Rotation
                uiresume(fig);
                close(fig);
                return;
        end
        if exist('downsampled_input_bone', 'var')
            inertial_input_bone.pts = transformPoints(inertialACS, downsampled_input_bone.pts, -1);
        else
            inertial_input_bone.pts = transformPoints(inertialACS, input_bone.pts, -1);
        end
        updatePlots(inertial_input_bone.pts)
    end
% Function to update plots with new vertices
    function updatePlots(vertices)
        cla(ax1)
        patch(ax1, 'Vertices', inertial_reference_bone.pts, 'Faces', inertial_reference_bone.cnt, 'EdgeAlpha', 0.2, 'FaceAlpha', 0.5, 'FaceColor', col1);
        patch(ax1, 'Vertices', vertices, 'Faces', inertial_input_bone.cnt, 'EdgeAlpha', 0.2, 'FaceAlpha', 0.5, 'FaceColor', col2);
        view(ax1, [0 -90]);

        cla(ax2)
        patch(ax2, 'Vertices', inertial_reference_bone.pts, 'Faces', inertial_reference_bone.cnt, 'EdgeAlpha', 0.2, 'FaceAlpha', 0.5, 'FaceColor', col1);
        patch(ax2, 'Vertices', vertices, 'Faces', inertial_input_bone.cnt, 'EdgeAlpha', 0.2, 'FaceAlpha', 0.5, 'FaceColor', col2);
        view(ax2, [80 0]);

        cla(ax3)
        patch(ax3, 'Vertices', inertial_reference_bone.pts, 'Faces', inertial_reference_bone.cnt, 'EdgeAlpha', 0.2, 'FaceAlpha', 0.5, 'FaceColor', col1);
        patch(ax3, 'Vertices', vertices, 'Faces', inertial_input_bone.cnt, 'EdgeAlpha', 0.2, 'FaceAlpha', 0.5, 'FaceColor', col2);
        view(ax3, [0 0]);
    end

%% find the final inertial_pts of the ORIGINAL input bones
inertial_pts = transformPoints(inertialACS, input_bone.pts, -1);

% Paige Treherne (2024) ______________________________________________________________________________
end
