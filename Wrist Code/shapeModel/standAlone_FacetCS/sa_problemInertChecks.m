% problemInertChecks

% based on first rms fit value on "surface fitting space".. used a pcs cs expression
% instead
rms_fit1=5
if rms_fit1 > threshR
    
    colsO = {'r','g','b'};
    colsP = {'m','k','y'};
    
    %take original pts
    
    %subtract mean
    pts_mm = mean(pts1,1);
    
    vec = pca(pts1);
    
    Tpca = RT_to_fX4(vec, pts_mm);
    T_pca_inv = sa_transposefX4(Tpca);
    %**********************************************************
    
    %move pts into NEW "surface fitting space".. transform into inertial CS
    for i = 1:length(pts1)
        pts_pca_moved(i,:) = (T_pca_inv(1:3,1:3) * pts1(i,:)' + T_pca_inv(1:3,4))';
    end %i
    pts_moved_pca_cent = [mean(pts_pca_moved(:,1)) mean(pts_pca_moved(:,2)) mean(pts_pca_moved(:,3))];
    
    %fit 5th order surface to points.. same number points, but conform to M
    fit_order = 5;
    M = polyfitn(pts_pca_moved(:,1:2),pts_pca_moved(:,3), fit_order);
    
    %compute Z value for x & y using surface equation
    Z_fit_pca =  polyvaln(M, [pts_pca_moved(:,1) pts_pca_moved(:,2)]);
    pts_out_pca = [pts_pca_moved(:,1:2) Z_fit_pca];
    %compute RMS values and get r-square
    rms_fit_pca = rms(pts_out_pca(:,3) - pts_pca_moved(:,3));
    
    
    
    
    [~, locx] = max(pts_moved(:,1));
    
    [~,locy] = max(pts_moved(:,2));
    %recheck before assigning..
    %
    
    %also visualize min max color coded points (to know if we need to
    %swap/flipp)
    
    csPCA = repmat(pts_moved_pca_cent,3,1) + vec*5;
    csPCA = [pts_moved_pca_cent ; csPCA];
    
    csTO = repmat(pts_moved_cent,3,1) + inert(3:5,1:3)*5;
    csTO = [pts_moved_cent ; csTO];
    
    csP = repmat(pts_mm,3,1) + vec*5;
    csP= [pts_mm; csP];
    
    csI = repmat(pts_mm,3,1) + inert(3:5,1:3)*5;
    csI= [pts_mm; csI];
    
    
    
    if rms_fit_pca < rms_fit1
        
        [stat, sel, vec2] = sa_highRMS_PCAselect(con1(:,1:3)+1, pts_moved,pts_pca_moved,...
            rms_fit1,rms_fit_pca, [locx;locy], pts1, pts_mm, vec);
        
        
        
        
        
        if strcmp(stat,'cancel')
            return
        elseif strcmp(sel,'pca')
            
            
            
            Tpca = RT_to_fX4(vec2, pts_mm);
            T_pca_inv = sa_transposefX4(Tpca);
            %**********************************************************
            
            %move pts into "surface fitting space".. transform into inertial CS
            for i = 1:length(pts1)
                pts_pca_moved(i,:) = (T_pca_inv(1:3,1:3) * pts1(i,:)' + T_pca_inv(1:3,4))';
            end %i
            pts_moved_pca_cent = [mean(pts_pca_moved(:,1)) mean(pts_pca_moved(:,2)) mean(pts_pca_moved(:,3))];
            
            %fit 5th order surface to points.. same number points, but conform to M
            fit_order = 5;
            M = polyfitn(pts_pca_moved(:,1:2),pts_pca_moved(:,3), fit_order);
            
            %compute Z value for x & y using surface equation
            Z_fit_pca =  polyvaln(M, [pts_pca_moved(:,1) pts_pca_moved(:,2)]);
            pts_out_pca = [pts_pca_moved(:,1:2) Z_fit_pca];
            %compute RMS values and get r-square
            rms_fit_pca = rms(pts_out_pca(:,3) - pts_pca_moved(:,3));
            
            
            
            
            
            
            %reassign vars
            pts_moved = pts_pca_moved;
            pts_out = pts_out_pca;
            T = Tpca;
            T_inv = T_pca_inv;
            rms_fit1 = rms_fit_pca;
            Z_fit = Z_fit_pca;
            pts_moved_cent = pts_moved_pca_cent;
        end
        
    end
    
    
    
    
    
    
    
    
    
    
end




