function patch_bonetype(bone_data, bones_cell, number_of_bones, type)

figure('units','normalized','outerposition',[0 0 1 1]);


for i = 1:number_of_bones
    b = string(bones_cell(i));
    p = 'pts';
    subplot(3,(number_of_bones/3),i); 
    title(b); leg_str = {};
    for j = 1:length(bone_data.(b))
        axis equal; hold on;
        patch('Vertices', bone_data.(b)(j).(type).(p), 'Faces', bone_data.(b)(j).(type).cnt, 'FaceAlpha', 0.5, 'FaceColor', [rand rand rand], 'EdgeAlpha', 0)
        leg_str = [leg_str; string(j)];
    end
    legend(leg_str, 'Location', 'eastoutside')
end
uiwait(msgbox(['Visualising all ' type ' bones. Press Okay to continue']))
close all

end
