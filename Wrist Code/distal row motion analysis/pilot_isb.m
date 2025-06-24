%% Statistical Testing - CMC 

close all; clear all;
addpath(genpath('C:\Users\Kelly\Documents\MATLAB\Github'));  %add sol coding repo to file path
addpath(genpath('C:\Projects\Max_wrist_movement'));  %add sol coding repo to file path
addpath(genpath('P:\GordieHardDrive\Code'));
addpath(genpath('P:\GordieHardDrive\Gordie\Gordie Files\Code\carpal_mech_laxity_study'));

%% Variables
bone_registered = 11;
files = dir('C:\Users\Kelly\Desktop\motion_test\CMC*');
subject = {files(:).name}';

directory_neutral = fullfile('C:\Users\Kelly\Desktop\motion_test',subject);
hand = 'R';      %change per trial for all
bone_rotated = 8;   % to check helical axis angle
boneindex = [7, 8, 9, 10, 12, 13, 14, 15]; % skip MC1
for b = 1:length(boneindex)
        bonename(1,b) = {bonecode(boneindex(b))};
end


%%
for s = 1:length(directory_neutral)
    %%
    info = getSubjectFilePath(directory_neutral{s},hand);
    
    directory_general = fullfile('C:\Users\Kelly\Desktop\motion_test',bonecode(bone_registered));

    hand = 'R';      %change per trial for all
    p1 = nchoosek(info.series(2:end),2); %moving from position 1 to pos 2
    p2 = nchoosek(info.series,2);
    
    
    % Set to 1 if going position p1 to position p2 
    flag = 1;
    
    %% Load Data
    
    %load('P:\GordieHardDrive\carpal_lax_db\E00001\S15R\IV.files','bone'); %change first part for different people
    for b = 1:15
        [R T mag] = getInertialInfo(fullfile(directory_neutral{s},position(1,hand),"inertia15R.dat"),b);
        bone.(subject{s}).(info.series{1}).(bonecode(b)).Inertia = RT_to_fX4(R,T);
    end
    
    for p = 2:6
        pos_temp = info.motionFiles{p};
        
        for b = 1:15
            matrix_temp = dlmread(pos_temp);
            RT = matrix_temp(b*4-3:b*4,1:3);
            bone.(subject{s}).(info.series{p}).(bonecode(b)).transform = RT_to_fX4(RT(1:3,1:3),RT(4,1:3));
        end
    end
    
    
    
    
    %% For Helical axis of relative position
        % Not relative to neutral
    
    if flag == 1
        for p = 1:length(p1)
            
            for b = 7:15
                boneregp1.(subject{s}).(p1{p,1}).(bonecode(b)) = bone.(subject{s}).(p1{p,1}).(bonecode(bone_registered)).transform^-1* bone.(subject{s}).(p1{p,1}).(bonecode(b)).transform;
                boneregp2.(subject{s}).(p1{p,2}).(bonecode(b)) = bone.(subject{s}).(p1{p,2}).(bonecode(bone_registered)).transform^-1* bone.(subject{s}).(p1{p,2}).(bonecode(b)).transform;
                Transformation_matrix.(bonecode(b)) =  boneregp2.(subject{s}).(p1{p,2}).(bonecode(b))*boneregp1.(subject{s}).(p1{p,1}).(bonecode(b))^-1;
        
                % RT to Helical
                R = Transformation_matrix.(bonecode(b))(1:3,1:3);
                T = Transformation_matrix.(bonecode(b))(1:3,4);
                [phi,n,t_ham,q] = RT_to_helical(R,T);
                % q is centriod, t is the vector
                
                bone.phi.(subject{s})(b,p)  = phi;
                bone.(subject{s}).helical.(p1{p,1}).(p1{p,2}).(bonecode(b)) = [n',q'];
            end
        end
    end

    for p = 1:length(p1)
        for b = 7:15

            q = bone.(subject{s}).helical.(p1{p,1}).(p1{p,2}).(bonecode(b))(:,2);
            n = bone.(subject{s}).helical.(p1{p,1}).(p1{p,2}).(bonecode(b))(:,1);
            bone_reg_centroid = bone.(subject{s}).helical.(p1{p,1}).(p1{p,2}).(bonecode(bone_registered))(:,2);
            [newq, dist] = min_dist_P_line(q,q + n,bone_reg_centroid);
            q2 = newq + (norm(n))/2;
            bone.(subject{s}).helical.(p1{p,1}).(p1{p,2}).(bonecode(b)) = [n,q2];

        end

    end

    %% Helical Axis printed
    for p = 1:length(p1)
    
        ivstring = createInventorHeader();
            
        for b = 7:15
                                  
            

            colour = lines(15); % preset matlab colour schemes
            
        
            filename_temp = append('\IV.files\',bonecode(b),'15',hand,'.iv');
            ivstring = [ivstring createInventorLink(fullfile(info.neutralSeriesPath,filename_temp), boneregp2.(subject{s}).(p1{p,2}).(bonecode(b))(1:3,1:3), boneregp2.(subject{s}).(p1{p,2}).(bonecode(b))(1:3,4)', colour(b,:), 0.3)];
        
        
            %Neutral original position
            ivstring = [ivstring createInventorLink(fullfile(info.neutralSeriesPath,filename_temp), boneregp1.(subject{s}).(p1{p,1}).(bonecode(b))(1:3,1:3), boneregp1.(subject{s}).(p1{p,1}).(bonecode(b))(1:3,4)', [0.7 0.7 0.7], 0.3)]; %registered position (cyan)
            if b ~= bone_registered
                ivstring = [ivstring createInventorArrow(bone.(subject{s}).helical.(p1{p,1}).(p1{p,2}).(bonecode(b))(1:3,2)', bone.(subject{s}).helical.(p1{p,1}).(p1{p,2}).(bonecode(b))(1:3,1)', 25, 0.5, colour(b,:), 0)];
            end
            
            
        
        end
        
        filename = append((subject{s}),'helical',(p1{p,1}),'_',(p1{p,2}),'.iv');
        fid = fopen(fullfile(directory_general, filename),"w");     %where data is being saved
        fprintf(fid,ivstring);
        fclose(fid);
    
    end
    
    %% For Helical axis of relative position
        % relative to neutral
    temp_length = length(bone.phi.(subject{s}));
    if flag == 1
        for p = 2:length(info.series)
            
            for b = 7:15
                boneregp1.(subject{s}).(info.series{p}).(bonecode(b)) = bone.(subject{s}).(info.series{p}).(bonecode(bone_registered)).transform^-1* bone.(subject{s}).(info.series{p}).(bonecode(b)).transform;
                            
                Transformation_matrix.(bonecode(b)) =  boneregp1.(subject{s}).(info.series{p}).(bonecode(b));
        
                % RT to Helical
                R = Transformation_matrix.(bonecode(b))(1:3,1:3);
                T = Transformation_matrix.(bonecode(b))(1:3,4);
                [phi,n,t_ham,q] = RT_to_helical(R,T);
                % q is centriod, n is the vector
                bone.phi.(subject{s})(b,temp_length+p-1) = phi;
                bone.(subject{s}).helical.(info.series{1}).(info.series{p}).(bonecode(b)) = [n',q'];
                
            end
        end
    end
    
    %% Neutral position Relative motion
    for p = 2:length(info.series)
    
        ivstring = createInventorHeader();
            
        for b = 7:15
            % bone.phi_relative.(subject{s})(b,s) = bone.phi.(subject{s})(b,s) - bone.phi.(subject{s})(8,s);
                        
            colour = hsv(15); % preset matlab colour schemes
        
            filename_temp = append('\IV.files\',bonecode(b),'15',hand,'.iv');
            % ivstring = [ivstring createInventorLink(fullfile(info.neutralSeriesPath,filename_temp), boneregp1.(subject{s}).(info.series{p}).(bonecode(b))(1:3,1:3), boneregp1.(subject{s}).(info.series{p}).(bonecode(b))(1:3,4)', colour(b,:), 0)];
        
        
            %Neutral original position
            % ivstring = [ivstring createInventorLink(fullfile(info.neutralSeriesPath,filename_temp), eye(3,3), [0 0 0], [0.7 0.7 0.7], 0.2)]; %registered position (cyan)
    
            ivstring = [ivstring createInventorArrow(bone.(subject{s}).helical.(info.series{1}).(info.series{p}).(bonecode(b))(1:3,2)', bone.(subject{s}).helical.(info.series{1}).(info.series{p}).(bonecode(b))(1:3,1)', 50, 0.5, colour(b,:), 0)];
            
            
        
        end
    
        filename = append((subject{s}),'helical',(position(15,hand)),'_',(position(p,hand)),'.iv');
        fid = fopen(fullfile(directory_general, filename),"w");     %where data is being saved
        fprintf(fid,ivstring);
        fclose(fid);
    
    
    end
%% angle between helical axis and other bones

for p = 1:length(p2)
    for b = 7:15
        
        n1 = bone.(subject{s}).helical.(p2{p,1}).(p2{p,2}).(bonecode(bone_rotated))(1:3,1);
        n2 = bone.(subject{s}).helical.(p2{p,1}).(p2{p,2}).(bonecode(b))(1:3,1);
        bone.phi_relative.(subject{s})(b,p) = (bone.phi.(subject{s})(b,p) - bone.phi.(subject{s})(8,p));

        bone.relative_angle.(subject{s})(b,p) = acosd(dot(n1, n2));
        if dot(n1,n2) > 1
            bone.relative_angle.(subject{s})(b,p)  = 0;
        end
    
    end

end




end


%% Box plot

for s = 1:length(subject)

    for b = 1:length(boneindex)
        bones_wanted(b,:) = bone.relative_angle.(subject{s})(boneindex(b),:);
        phi_wanted(b,:) = bone.phi_relative.(subject{s})(boneindex(b),:);
        I = find(phi_wanted(b,:)<=5);
        for X = 1:length(I)
            bones_wanted(b,I(1,X)) = NaN;
        end

    end
    x = 55*(s-1)+1;
    z = x+54;
    all_bones(:,:) = bones_wanted(:,:);
    all_phi(:,:) = phi_wanted(:,:); 

    figure(s)

    hold on

    subplot(2,1,1)
    boxplot(bones_wanted',bonename);
    xlabel('Bone ')
    ylabel('Relative Angle [degrees]')
    title({append('Subject ',(subject{s}))})
    subtitle('Angle')


    subplot(2,1,2)
    boxplot(phi_wanted',bonename);

    xlabel('Bone ')
    ylabel('Phi [degrees]')
    subtitle('Phi')

    hold off
    

end

%% Plot gen


phi_mean = mean(all_phi')'
abs_phi_mean = mean(abs(all_phi'))'
phi_std = std(all_phi')'
relativeAng_mean = nanmean(all_bones')'
relativeAng_std = nanstd(all_bones')'

figure(length(subject)+1)
hold on

subplot(2,1,1)
boxplot(all_bones',bonename);

xlabel('Bone ')
ylabel('Relative Angle [degrees]')
subtitle('Angle')

subplot(2,1,2)

boxplot((all_phi)',bonename);


xlabel('Bone ')
ylabel('Phi [degrees]')
subtitle('Phi')
hold off

%%  Statistical Testing

for s = 1:length(subject)
    mean_phi = mean(bone.phi.(subject{s})')'
    
    for b = 1:length(boneindex)
        temp = all_phi(b,:)';
        phi_sd(b,s) = (std(temp));
        [h,p,ci,stats] = ttest(bone.phi_relative.(subject{s})(boneindex(b),:));
        bone.ttest.h(b,s+1) = h;
        bone.ttest.p(b,s+1) = p;
        bone.ttest.ci_max(b,s+1) = ci(1,1);
        bone.ttest.ci_min(b,s+1) = ci(1,2);
        bone.ttest.sd(b,s+1) = stats.sd;
        bone.ttest.df(b,s+1) = stats.df;
        bone.ttest.tstast(b,s+1) = stats.tstat;
        bone.ttest.h(b,1) = (boneindex(b));
        bone.ttest.p(b,1) = (boneindex(b));
        bone.ttest.ci_max(b,1) = (boneindex(b));
        bone.ttest.ci_min(b,1) = (boneindex(b));
    end

end

for s = 1:length(subject)
    % mean_phi = mean(bone.phi.(subject{s})')'
    for b = 1:length(boneindex)

        [h,p,ci,stats] = ttest(abs(bone.phi_relative.(subject{s})(boneindex(b),:)));
        bone.abs.ttest.h(b,s+1) = h;
        bone.abs.ttest.p(b,s+1) = p;
        bone.abs.ttest.ci_max(b,s+1) = ci(1,1);
        bone.abs.ttest.ci_min(b,s+1) = ci(1,2);
        bone.abs.ttest.sd(b,s+1) = stats.sd;
        bone.abs.ttest.df(b,s+1) = stats.df;
        bone.abs.ttest.tstast(b,s+1) = stats.tstat;
        bone.abs.ttest.h(b,1) = (boneindex(b));
        bone.abs.ttest.p(b,1) = (boneindex(b));
        bone.abs.ttest.ci_max(b,1) = (boneindex(b));
        bone.abs.ttest.ci_min(b,1) = (boneindex(b));
    end

end


for b = 1:length(boneindex)
    [h,p,ci,stats] = ttest(all_phi(b,:));
    bone.ttest.h(b,length(subject)+2) = h;
    bone.ttest.p(b,length(subject)+2) = p;
    bone.ttest.ci_max(b,length(subject)+2) = ci(1,1);
    bone.ttest.ci_min(b,length(subject)+2) = ci(1,2);
    % bone.ttest.stats(b,length(subject)+2) = stats;
    bone.ttest.sd(b,length(subject)+2) = stats.sd;
    bone.ttest.df(b,length(subject)+2) = stats.df;
    bone.ttest.tstast(b,length(subject)+2) = stats.tstat;
    % bone.ttest(b,1) = nan;
    combined(1,:) = [{'bone'},{'p value'},{'sd'},{'mean phi'},{'mean phi tpm'},{'abs mean phi tpm'}];
    % mean_phi2 = mean_phi(boneindex,:)
    combined(b+1,:) = [{bonecode(boneindex(b))}, bone.ttest.p(b,length(subject)+2), bone.ttest.sd(b,length(subject)+2),mean_phi(boneindex(b),:), phi_mean(b,:),abs_phi_mean(b,:)] ;
    % [{bonecode(boneindex(b))}, bone.ttest.p(b,length(subject)+2), bone.ttest.sd(b,length(subject)+2)];

end

save(append('C:\Users\kelly\GitHub\SOL_Coding_Repo\Wrist Code\bone_structs\bone.mat'),'bone')