function bone_acs=main_sa_interativeCurvatureCS(facetIVpath,boneIVpath,writeIVfile_flag, boneCS_opt, verbose,threshR)

% verbose flag for supressing plots
if ~exist('verbose','var')
    verbose =1;
end
if ~exist('boneCS_opt','var')
    boneCS_opt =[zeros(1,3);NaN(1,3);eye(3)];
end
if ~exist('threshR', 'var')
    threshR = 0.0002;
end

[~,bone_name] = fileparts(boneIVpath); 
bone_name =bone_name(1:3);
    
inert  = boneCS_opt;
T = sa_RT_to_fX4(inert(3:5,1:3), inert(1,1:3));
T_inv = sa_transposefX4(T);
%**********************************************************

if writeIVfile_flag
%     %prompt for write path..
%     writepath = uigetdir(cd, 'Select Directory to write IV files');
    writepath = fileparts(fileparts(boneIVpath));
    %start the ivstring.. for output to iv file (called in wrist vis .. later)
    ivstring = [];
    ivstring = [ivstring sa_createInventorHeader];
    ivstring = [ivstring sa_createInventorLink(facetIVpath ,eye(3,3),zeros(1,3),[0 0 1], 0.3)]; %funct in P:\TheCollective
    ivstring = [ivstring sa_createInventorLink(boneIVpath ,eye(3,3),zeros(1,3),[0.7 0.7 0.7], 0.3)];
end

%read vrml_file
[pts1, con1] = sa_read_vrml_fast(facetIVpath);
pts_cent = [mean(pts1(:,1)) mean(pts1(:,2)) mean(pts1(:,3))];



%move pts into "surface fitting space".. transform into inertial CS
for i = 1:length(pts1)
    pts_moved(i,:) = (T_inv(1:3,1:3) * pts1(i,:)' + T_inv(1:3,4))';
end %i
pts_moved_cent = [mean(pts_moved(:,1)) mean(pts_moved(:,2)) mean(pts_moved(:,3))];

%fit 5th order surface to points.. same number points, but conform to M
fit_order = 5;
M = polyfitn(pts_moved(:,1:2),pts_moved(:,3), fit_order);

%compute Z value for x & y using surface equation
Z_fit =  polyvaln(M, [pts_moved(:,1) pts_moved(:,2)]);
pts_out = [pts_moved(:,1:2) Z_fit];
%compute RMS values and get r-square
rms_fit1 = rms(pts_out(:,3) - pts_moved(:,3));


%if facet is not expressed with X and Y vd ru from first attempt
%surface fitting space transform.. use PCA

sa_problemInertChecks

%create mesh grid for curvature computations.. parametric form of 5th
%order surface
[Xm, Ym] = meshgrid(min(pts_moved(:,1)):0.1:max(pts_moved(:,1)),min(pts_moved(:,2)):0.1:max(pts_moved(:,2)));

for i = 1:size(Xm,2)
    Zm(:,i) = polyvaln(M,[Xm(:,i) Ym(:,i)]);
end %i


if ~verbose
    figure;
    contourf(Xm, Ym, Zm);
end
%curvature parameters.. [critical point, Gaussian curvature, mean
%curvature, principal curv max, prinicpal curve min, principal
%direction unit vector(min) , unit vector (max)]
[old_saddle, K, H, Pmax, Pmin e1 e2] = sa_surfature_vectors(Xm, Ym, Zm,pts_moved, pts_moved_cent,verbose);
%     saddle_cent_diff(ws,1:3)=saddle-pts_moved_cent;

if ~verbose
    figure;
    surf(Xm, Ym, Zm);
    hold on
    plot3(pts_moved(:,1), pts_moved(:,2),pts_moved(:,3), 'b*');hold on
    plot3(old_saddle(:,1), old_saddle(:,2),old_saddle(:,3), 'go','MarkerFaceColor','g'); hold on
    plot3(pts_moved_cent(:,1), pts_moved_cent(:,2),pts_moved_cent(:,3), 'ro','MarkerFaceColor','r');
end
old_saddle = (T(1:3,1:3)*(old_saddle' - T_inv(1:3,4)))';
%plot values near real points
Zm_exclude(1:size(Xm,1),1:size(Xm,2)) = NaN;
e1_exclude(1:size(Xm,1),1:size(Xm,2),1:3) = NaN;
e2_exclude(1:size(Xm,1),1:size(Xm,2),1:3) = NaN;

% %Visualize Surfaces*************
% A = mesh(Xm,Ym,Zm);
% [F V C] = surf2patch(A);
%
%     for i = 1:length(V)
%         V_orig(i,:) = (V(i,:) - T_inv(1:3,4)')*T_inv(1:3,1:3);
%     end
%
% %clear V_orig
% patch2iv(V_orig, F,[subj '\tpm_quadsurf.iv']);


% in x and in y, find minimum absolute difference between 5th order fit
% pts and parametric range
%those closeset to pts % least offset.. lookup values of curvature for
%the actual pts locations

for i =1:length(pts_out)
    tell_y = Ym(:,1) - pts_out(i,2);
    tell_x = Xm(1,:) - pts_out(i,1);
    [y Iy] = min(abs(tell_y));
    [x Ix] = min(abs(tell_x));
    
    Zm_exclude(Iy,Ix) = pts_out(i,3);
    
    %assign pricipal axis at these indicies
    e1_exclude(Iy,Ix,1:3) = e1(Iy,Ix,1:3);
    e2_exclude(Iy,Ix,1:3) = e2(Iy,Ix,1:3);
end

%     S = surf(Xm,Ym,Pmin);

%%create coordinate system (old way)***********************************
tell_y = Ym(:,1) - pts_moved_cent(2);
tell_x = Xm(1,:) - pts_moved_cent(1);
[y, Iy] = min(abs(tell_y));
[x, Ix] = min(abs(tell_x));


zhat = unit(cross([e1_exclude(Iy,Ix,1),e1_exclude(Iy,Ix,2),e1_exclude(Iy,Ix,3)],[e2_exclude(Iy,Ix,1),e2_exclude(Iy,Ix,2),e2_exclude(Iy,Ix,3)]));
xhat = unit([e1_exclude(Iy,Ix,1),e1_exclude(Iy,Ix,2),e1_exclude(Iy,Ix,3)]);
yhat = unit([e2_exclude(Iy,Ix,1),e2_exclude(Iy,Ix,2),e2_exclude(Iy,Ix,3)]);
xhat = xhat';
yhat = yhat';
zhat = zhat';
origin = [Xm(1,Ix) Ym(Iy,1) Zm(Iy,Ix)]';
coordsys = [xhat yhat zhat origin; 0 0 0 1];
coordsys_bone = T * coordsys;

if ~verbose
    hold on
end
%%%**********************************************************************
%create coord sys
ham_x = [];
ham_y = [];
krms = [];
kmin = [];
kmax = [];
m=0;
n=0;
for i = 1:size(Xm,2)
    for j = 1:size(Ym,1)
        if ~isnan(Zm_exclude(j,i))
            m=m+1;
            zhat_temp = unit(cross([e1_exclude(j,i,1) e1_exclude(j,i,2) e1_exclude(j,i,3)], [e2_exclude(j,i,1) e2_exclude(j,i,2) e2_exclude(j,i,3)]));
            xhat_temp = unit([e1_exclude(j,i,1),e1_exclude(j,i,2),e1_exclude(j,i,3)]);
            yhat_temp = unit([e2_exclude(j,i,1),e2_exclude(j,i,2),e2_exclude(j,i,3)]);
            xhat_temp = xhat_temp';
            yhat_temp = yhat_temp';
            zhat_temp = zhat_temp';
            origin_temp = [Xm(1,i) Ym(j,1) Zm(j,i)]';
            coordsys_temp = [xhat_temp yhat_temp zhat_temp origin_temp; 0 0 0 1];
            coordsys_bone_temp = T * coordsys_temp;
            
            if sa_CMC_distance(coordsys_bone_temp(1:3,4)', coordsys_bone(1:3,4)') < 3.0
                n=n+1;
                ham_x = [ham_x; 10 coordsys_bone_temp(1:3,1)' 0 coordsys_bone_temp(1:3,4)'];
                ham_y = [ham_y; 10 coordsys_bone_temp(1:3,2)' 0 coordsys_bone_temp(1:3,4)'];
                
                dx=dot(coordsys_bone_temp(1:3,1),coordsys_bone(1:3,1));
                dy=dot(coordsys_bone_temp(1:3,2),coordsys_bone(1:3,2));
                %vis all princ dirs
                hx=ham_x(n,2:4);
                hy=ham_y(n,2:4);
                if dot(coordsys_bone_temp(1:3,1),inert(3:5,1))<0.5
                    hx=-hx;
                    ham_x(n,2:4)=-ham_x(n,2:4);
                elseif dot(coordsys_bone_temp(1:3,2),inert(3:5,2))<0.5
                    hy=-hy;
                    ham_y(n,2:4)=-ham_y(n,2:4);
                end
                
                
            end %if distance_tkp
            
        end %if isnan
        
    end %j
end %i



avg_1 = sa_calcAvgMotion(ham_x);
avg_2 = sa_calcAvgMotion(ham_y);

z_hat = -unit(avg_1(2:4));
y_hat = unit(cross(avg_2(2:4),z_hat));
x_hat = unit(cross(y_hat, z_hat));

bone_acs = [x_hat' y_hat' z_hat' pts_cent'; 0 0 0 1];
% ivstring = [ivstring sa_createInventorArrow(pts_cent,bone_acs1(1:3,1)', 25, 0.6, [1 0 0], 0.5)];
% ivstring = [ivstring sa_createInventorArrow(pts_cent,bone_acs1(1:3,2)', 25, 0.6, [0 1 0], 0.5)];
% ivstring = [ivstring sa_createInventorArrow(pts_cent,bone_acs1(1:3,3)', 25, 0.6, [0 0 1], 0.5)];

%     clear_all_but('pts1','con1', 'bone_acs','ivstring', 'CRpts', 'old_saddle', 'rms_fit1', 'subject', 'side','verbose');
clearvars -except pts1 con1 bone* ivstring CRpts old_saddle rms_fit1 subject side verbose write*

%%**********************start next fit***********************************%%
xlist = [];
ylist = [];
zlist = [];
nn=1;
%     saddle(1,:)=old_saddle;
rms_fit2=rms_fit1;
while  nn<5 &&  (abs(old_saddle(1,1)- bone_acs(1,4))>0.1 || abs(old_saddle(1,2)- bone_acs(2,4))>0.1) && (rms_fit1-rms_fit2)/rms_fit1>-0.1
    nn=nn+1;
    
    
    %read mc1 inertia
    inertR = bone_acs(1:3,1:3);
    
    %rotate inertias
    inert = inertR;
    inert(1:3,1) = inertR(1:3,3) * -1;
    inert(1:3,2) = inertR(1:3,1) * -1;
    inert(1:3,3) = inertR(1:3,2);
    % end %flip inert
    
    %inert = inertR;
    %create transform to move pts to "surface fitting space" (may not matter for some things).
    T = RT_to_fX4(inert(1:3,1:3), bone_acs(1:3,4)');
    T_inv = sa_transposefX4(T);
    %**********************************************************
    
    
    %move pts into "surface fitting space"
    for i = 1:length(pts1)
        pts_moved(i,:) = (T_inv(1:3,1:3) * pts1(i,:)' + T_inv(1:3,4))';
    end %i
    pts_moved_cent = [mean(pts_moved(:,1)) mean(pts_moved(:,2)) mean(pts_moved(:,3))];
    
    %fit 5th order surface to points
    fit_order = 5;
    M = polyfitn(pts_moved(:,1:2),pts_moved(:,3), fit_order);
    
    %compute Z value for x & y using surface equation
    Z_fit =  polyvaln(M, [pts_moved(:,1) pts_moved(:,2)]);
    pts_out = [pts_moved(:,1:2) Z_fit];
    
    %compute RMS values and get r-square
    rms_fit2 = rms(pts_out(:,3) - pts_moved(:,3));
    
    %create mesh grid for curvature computations
    [Xm Ym] = meshgrid(min(pts_moved(:,1)):0.1:max(pts_moved(:,1)),min(pts_moved(:,2)):0.1:max(pts_moved(:,2)));
    
    for i = 1:size(Xm,2)
        Zm(:,i) = polyvaln(M,[Xm(:,i) Ym(:,i)]);
    end %i
    
    old_saddle=bone_acs(1:3,4)';
    if ~verbose
        figure;
        contourf(Xm, Ym, Zm);
    end
    
    %curvature parameters
    [saddle, K, H, Pmax, Pmin, e1, e2] = sa_surfature_vectors(Xm, Ym, Zm,pts_moved, pts_moved_cent,verbose);
    
    if ~verbose
        figure;
        surf(Xm, Ym, Zm);
        hold on
        plot3(pts_moved(:,1), pts_moved(:,2),pts_moved(:,3), 'b*');hold on
        plot3(saddle(:,1), saddle(:,2),saddle(:,3), 'go','MarkerFaceColor','g'); hold on
        plot3(pts_moved_cent(:,1), pts_moved_cent(:,2),pts_moved_cent(:,3), 'ro','MarkerFaceColor','r');
    end
    
    saddle = (T(1:3,1:3)*(saddle' - T_inv(1:3,4)))';
    %plot values near real points
    Zm_exclude(1:size(Xm,1),1:size(Xm,2)) = NaN;
    e1_exclude(1:size(Xm,1),1:size(Xm,2),1:3) = NaN;
    e2_exclude(1:size(Xm,1),1:size(Xm,2),1:3) = NaN;
    
    for i =1:length(pts_out)
        tell_y = Ym(:,1) - pts_out(i,2);
        tell_x = Xm(1,:) - pts_out(i,1);
        [y Iy] = min(abs(tell_y));
        [x Ix] = min(abs(tell_x));
        
        Zm_exclude(Iy,Ix) = pts_out(i,3);
        e1_exclude(Iy,Ix,1:3) = e1(Iy,Ix,1:3);
        e2_exclude(Iy,Ix,1:3) = e2(Iy,Ix,1:3);
    end
    
    
    
    %%create coordinate system ***********************************
    tell_y = Ym(:,1) - pts_moved_cent(2);
    tell_x = Xm(1,:) - pts_moved_cent(1);
    [y Iy] = min(abs(tell_y));
    [x Ix] = min(abs(tell_x));
    
    zhat = unit(cross([e1_exclude(Iy,Ix,1),e1_exclude(Iy,Ix,2),e1_exclude(Iy,Ix,3)],[e2_exclude(Iy,Ix,1),e2_exclude(Iy,Ix,2),e2_exclude(Iy,Ix,3)]));
    xhat = unit([e1_exclude(Iy,Ix,1),e1_exclude(Iy,Ix,2),e1_exclude(Iy,Ix,3)]);
    yhat = unit([e2_exclude(Iy,Ix,1),e2_exclude(Iy,Ix,2),e2_exclude(Iy,Ix,3)]);
    xhat = xhat';
    yhat = yhat';
    zhat = zhat';
    origin = [Xm(1,Ix) Ym(Iy,1) Zm(Iy,Ix)]';
    coordsys = [xhat yhat zhat origin; 0 0 0 1];
    coordsys_bone = T * coordsys;
    
    if ~verbose
        hold on
    end
    
    
    ham_x = [];
    ham_y = [];
    krms = [];
    kmin = [];
    kmax = [];
    
    n=0;
    for i = 1:size(Xm,2)
        for j = 1:size(Ym,1)
            
            
            zhat_temp = unit(cross([e1(j,i,1) e1(j,i,2) e1(j,i,3)], [e2(j,i,1) e2(j,i,2) e2(j,i,3)]));
            xhat_temp = unit([e1(j,i,1),e1(j,i,2),e1(j,i,3)]);
            yhat_temp = unit([e2(j,i,1),e2(j,i,2),e2(j,i,3)]);
            xhat_temp = xhat_temp';
            yhat_temp = yhat_temp';
            zhat_temp = zhat_temp';
            origin_temp = [Xm(1,i) Ym(j,1) Zm(j,i)]';
            coordsys_temp = [xhat_temp yhat_temp zhat_temp origin_temp; 0 0 0 1];
            coordsys_bone_temp = T * coordsys_temp;
            
            if sa_CMC_distance(coordsys_bone_temp(1:3,4)', coordsys_bone(1:3,4)') < 3.0
                n=n+1;
                ham_x = [ham_x; 10 coordsys_bone_temp(1:3,1)' 0 coordsys_bone_temp(1:3,4)'];
                ham_y = [ham_y; 10 coordsys_bone_temp(1:3,2)' 0 coordsys_bone_temp(1:3,4)'];
                
                
                %vis all princ dirs
                hx=ham_x(n,2:4);
                hy=ham_y(n,2:4);
                
                if dot(coordsys_bone_temp(1:3,1),inert(1:3,1))<0.5
                    hx=-hx;
                    ham_x(n,2:4)=-ham_x(n,2:4);
                elseif dot(coordsys_bone_temp(1:3,2),inert(1:3,2))<0.5
                    hy=-hy;
                    ham_y(n,2:4)=-ham_y(n,2:4);
                end
                
            end %if distance
        end %j
    end %i
    
    avg_1 = sa_calcAvgMotion(ham_x);
    avg_2 = sa_calcAvgMotion(ham_y);
    krms_avg = mean(krms);
    kmin_avg = mean(kmin);
    kmax_avg = mean(kmax);
    
    
    z_hat = -unit(avg_1(2:4));
    y_hat = unit(cross(avg_2(2:4),z_hat));
    x_hat = unit(cross(y_hat, z_hat));
    
    bone_acs = [x_hat' y_hat' z_hat' saddle'; 0 0 0 1];
    clearvars -except pts1 con1 bone* ivstring old_saddle rms_fit1 rms_fit2 nn subject side verbose write*
end


% previous data written to the dat file...
% bone_acs = [bone_acs(1:3,1) -bone_acs(1:3,2) -bone_acs(1:3,3) bone_acs(1:3,4); 0 0 0 1]; %changed dirs to comply with ISB

if writeIVfile_flag
    % we can make the dat file match the iv by:
    bone_acs = [bone_acs(1:3,1) -bone_acs(1:3,2) -bone_acs(1:3,3) old_saddle'; 0 0 0 1];
    fid=fopen(fullfile(writepath,['SCS_',bone_name,'.dat']), 'w');
    fprintf(fid, '%g %g %g %g\n', bone_acs');
    fclose(fid);
    
    
    ivstring = [ivstring sa_createInventorArrow(old_saddle,bone_acs(1:3,1)', 25, 0.6, [1 0 0])];
    ivstring = [ivstring sa_createInventorArrow(old_saddle,bone_acs(1:3,2)', 25, 0.6, [0 1 0])];
    ivstring = [ivstring sa_createInventorArrow(old_saddle,bone_acs(1:3,3)', 25, 0.6, [0 0 1])];
    
    
    fid = fopen(fullfile(writepath,['SCS_',bone_name,'.iv']),'w');
    fprintf(fid, ivstring);
    fclose(fid);
end


figHandles = findall(0,'Type','figure');
figHandles = figHandles(figHandles<12);
close(figHandles);

end

