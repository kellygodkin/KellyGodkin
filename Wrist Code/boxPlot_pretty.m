%% Make Graphs Pretty!!!
% To make box plot
clear all; close all; clc;
load(append('C:\Users\kelly\Desktop\ISB_25\DATA\bone.mat'),'bone');
load(append('C:\Users\kelly\Desktop\ISB_25\DATA\combined.mat'),'combined');
pilot = load(append('C:\Users\kelly\Desktop\ISB_25\DATA\bone_pilot.mat'),'bone');

files = dir('P:\GordieHardDrive\carpal_lax_db\E*');
subject = {files(:).name}';
bone_num = 7;

fonttype = 'Arial';
fontsize = 12;
colour = lines(31);
% % 0.7,0.7,0.7;  %rad
% %         0.7,0.7,0.7;    %uln
% %         0.7,0.7,0.7;    %sca
% %         0.7,0.7,0.7;    %lun
% %         0.7,0.7,0.7;    %trq
% %         0.7,0.7,0.7;    %pis
colour = [0.0670, 0.4430, 0.7450; %tpd
        % 0.8200, 0.0160, 0.5450; %tpm
        0.8670, 0.3290, 0;      %cap
        0.929, 0.694, 0.1250;   %ham
        % 0.7,0.7,0.7;    %mc1
        0.4660,0.6740,0.1880;    %mc2
        0.4660,0.6740,0.1880;  %mc3
        0.4660,0.6740,0.1880;    %mc4
        0.4660,0.6740,0.1880];   %mc5


%% Data set up
data.sd = bone.ttest.sd([1,3:end],:);
data.combined = combined([1:2,4:end],:);
data.phi_diff = bone.phi_diff([1,3:end],:);
data.pilot = pilot.bone.phi_relative.E00001([7,9:10,12:end],:);



figure
hold on
yline(0,'color','k','LineStyle','--')
% bone_order = [3,2,1,4,5,6,7];
for i = 1:bone_num%numel(fields(bonestruct))
    x = 0:8;
    y  = 0;

    if i == 1 
        b = i+6;   
    elseif 1<i<=4
        b = i+7;
    else
        b = i+8;
    end
    if i == 1
        p = 3;
    elseif i == 3
        p = 1;
    elseif i == 4
        p = 7;    
    elseif i == 5
        p = 6;
    elseif i == 6
        p = 5;
    elseif i == 7
        p = 4;
    else
        p = i;
    end
    std_pos_data = data.sd(i,11);
    mean_pos_data = data.combined(i+1,4);
    median_pos_data = nanmedian(data.phi_diff (p,:));
    pilot_med = nanmedian(data.pilot(p,1:10));
    percentile_75 = prctile(data.phi_diff', 75);
    percentile_25 = prctile(data.phi_diff', 25);
   
    errorbar(i,median_pos_data,data.sd(p,11),'color',colour(p,:))
    patch([i-0.2 i+0.2 i+0.2 i-0.2],[percentile_25(p) percentile_25(p) percentile_75(p) percentile_75(p)],colour(p,:),'FaceAlpha',0.8,'EdgeColor','k')
    if i == 0
        plot([i-0.2 i+0.2],[median_pos_data median_pos_data],'color',[0.8200, 0.0160, 0.5450])
    else
        plot([i-0.2 i+0.2],[median_pos_data median_pos_data],'-k')
    end
    % legend(' ',' ',' ','Pilot')
    % plot(i,pilot_med,"Marker",'d','MarkerFaceColor',[0 0 0],"Color",[1 1 01])

end
xlim([0 bone_num+1])
ylabel('Relative Angle [degrees]','FontName',fonttype,'FontSize',fontsize)
set(gca,'XTickLabel',[' hamate  ';'capitate ';'trapezoid';'   mc5   ';'   mc4   ';'   mc3   ';'   mc2   '],'XTick',[1 2 3 4 5 6 7],'FontName',fonttype,'FontSize',fontsize)
x = 1;

for b = 7:15
    x=x+1;
    
    if b == 12
        x=x-1;
    end
    combined(1,8) = {'Maximum Relative Ang- Pilot'};
    combined(x,8) ={max(abs(pilot.bone.phi_relative.E00001(b,:)))};

end
% combined(1,8) = {'Maximum Relative Ang'};

for x = 1:8
    combined(1,9) = {'Maximum Relative Ang- Gordie'};
    combined(x+1,9) ={max(abs(bone.phi_diff(x,:)))};
end