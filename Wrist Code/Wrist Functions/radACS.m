function bonestruct = radACS(bonestruct,slh,rad_styloid_dir)
% function created to create the correct rad ACS based on gordies code
% create_radCS in P:\GordieHardDrive\Gordie\Gordie Files\Code\carpal_mech_laxity_study\create_db
% rad_styloid_dir is the global coordinate system direction of the axis
% which points to the radial sytloid to take max point in that direction
% for the point of the radial styloid
% Choose slice thickness based on CT parameters
t = 0.625; % thickness of slices
t1 = t/2;  % half the slice thickness
%% This is the number of slices to consider for the diaphysis for all 10 subjects
% use mimics and go from scan 0 to the top scan of the radius
% slh = 67;
% 
% if rad_styloid_input == 1
%     rad_styloid_dir = 1;
% elseif rad_styloid_input == 2
%     rad_styloid_dir = 2;
% else
%     fprintf('Incorrect input for radial styloid');
%     return
% end
% rad_styloid_dir = 2

for s = 1:size(bonestruct.rad,2)
    pts = bonestruct.rad(s).global.pts;
    cnt = bonestruct.rad(s).global.cnt;
    cnt = cnt(:,1:3) +1;

    [mx nx] = max(pts(:,3));
    [mn nn] = min(pts(:,3));
    figure; hold on
    scatter3(pts(:,1),pts(:,2),pts(:,3))
    scatter3(pts(nn,1),pts(nn,2),pts(nn,3), 'filled', 'r')
    scatter3(pts(nx,1),pts(nx,2),pts(nx,3), 'filled', 'r')
    hold off

    %% Diving the points up into slices

    % The amount of slices that you have based on the max/min and the slice thickness
    slcs = round(mx-mn/t);
    
    % Step through and sort points into different slices
    clear slices
    for sl = 1:slh %(slcs(end)-40)
        ct = 1;
        clear grp
        for i = 1:length(pts)
            stpt = mn-t1; % start half a slice below minimm
            
            % for first slice 
            if sl == 1
                if  (stpt) < pts(i,3) && pts(i,3) < (mn+t)
                    grp(ct,:) = i;
                    ct = ct + 1;
                else
                end
            % for last slice
            elseif sl == (slcs(end)-1)
                if  (stpt+sl*t)< pts(i,3)
                    grp(ct,:) = i;
                    ct = ct + 1;
                else
                end
            % for all slices in between    
            else
                if  (stpt+sl*t)< pts(i,3) && pts(i,3) < (stpt+sl*t+t)
                    grp(ct,:) = i;
                    ct = ct + 1;
                else
                end
            end
            
        end
        slices{sl,1} = grp;
        slices{sl,2} = mn + t*(sl-1);
    end

    %% Visualize the slices for the radius
    %  Based on this choose how many slices to use for calculating long axis 
    figure; hold on
    for sl = 1:slh
        clear grp
        grp = slices{sl,1};
        lvl = slices{sl,2};
        for j = 1:length(grp)
    
            scatter3(pts(grp(j),1),pts(grp(j),2),pts(grp(j),3))
        end
    
    end
    
    hold off
    %% Calculate the centroid of the slices and least squares vector fit for the points 
    figure; hold on
    ct = 1;
    for sl = 2:slh
        clear grp lvl xy
        grp = slices{sl,1};
        lvl = slices{sl,2};
        for j = 1:length(grp)
    
            scatter3(pts(grp(j),1),pts(grp(j),2),pts(grp(j),3))
            xy(j,:) = [pts(grp(j),1),pts(grp(j),2)];
        end
        
        
        cntr(ct,1:3) = [mean(xy(:,1)) mean(xy(:,2)) lvl+t];
        scatter3(mean(xy(:,1)),mean(xy(:,2)),lvl+t, '*')
        ct=ct+1;
        
        
    
    end
    
    [x0 a] = ls3dline(cntr);
        p1 = x0 + 50*a;
        p2 = x0 - 50*a;
        scatter3(p1(1,1),p1(2,1),p1(3,1), '*')
        scatter3(p2(1,1),p2(2,1),p2(3,1), '*')
        title("Center?")
    
    hold off
    %% Plot the centroids in 2D to examine line.
    clear cntr
    ct=1;
    for sl = 2:slh
        
        clear grp lvl xy
        grp = slices{sl,1};
        lvl = slices{sl,2};
        for j = 1:length(grp)
    
           xy(j,:) = [pts(grp(j),1),pts(grp(j),2)];
        end
        
        
        cntr(ct,1:3) = [mean(xy(:,1)) mean(xy(:,2)) lvl+t];
        
        plot(mean(xy(:,1)),ct)  
        
        ct=ct+1;
    end
    
    scatter(cntr(:,2),cntr(:,3))
    title('Centroid 2')
    figure;
    scatter(cntr(:,1),cntr(:,3))
    title('Centroid 1')
    %% Calculating intersection between the long axis and the bone
    %  This distal intersection will be the centroid of the radACS
    
    for i = 1:length(cnt)
        
        pa = pts(cnt(i,1),:);
        pb = pts(cnt(i,2),:);
        pc = pts(cnt(i,3),:);
        
        [intersect(i,:) p(i,1:3)] = intersect_line_facet(p1',p2', pa,pb,pc);
        
    end
    
    int = find(intersect == 1);
    intpt = p(int,:);
    
    %% Visualize the intersection points and the other bony features
     
    [mxx nxx] = max(pts(:,rad_styloid_dir));
    [mnx nnx] = min(pts(:,rad_styloid_dir));
    if rad_styloid_dir == 1
        [mxy nxy] = min(pts(:,2));
        [mny nny] = max(pts(:,2));
    else
        [mxy nxy] = min(pts(:,1));
        [mny nny] = max(pts(:,1));
    end
    
    
    
    % figure; hold on
    % scatter3(pts(:,1),pts(:,2),pts(:,3))
    % 
    % scatter3(intpt(1,1),intpt(1,2),intpt(1,3), 'filled', 'r')
    % scatter3(intpt(2,1),intpt(2,2),intpt(2,3), 'filled', 'r')
    % 
    % scatter3(pts(nxx,1),pts(nxx,2),pts(nxx,3), 'filled', 'r')
    % scatter3(pts(nnx,1),pts(nnx,2),pts(nnx,3), 'filled', 'r')
    % 
    % hold off
    %% Setting up RadCS
    
    % 3 pts - 2 from the intersection of the rad, B - the radial styloid
    A = intpt(2,:);
    C = intpt(1,:);
    B = pts(nxx,:);
    
    v1 = C-A; % -a
    v2 = A-B;
    v3 = cross(v2,v1);
    v4 = cross(v3,v1);
    R = [unit(v1)' unit(v4)' unit(v3)'];
    radCS = [R A'; 0 0 0 1];

    %% Saving the Rad CS in summary file
    bonestruct.rad(s).transforms.S15R_new = radCS;
    bonestruct.rad(s).csys_fixed = radCS;

end