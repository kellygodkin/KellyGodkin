function [saddle, K,H,Pmax,Pmin, e1, e2] = sa_surfature_vectors(X,Y,Z,pts_moved, pts_moved_cent,verbose)
% SURFATURE -  COMPUTE GAUSSIAN AND MEAN CURVATURES OF A SURFACE
%   [K,H] = SURFATURE(X,Y,Z), WHERE X,Y,Z ARE 2D ARRAYS OF POINTS ON THE
%   SURFACE.  K AND H ARE THE GAUSSIAN AND MEAN CURVATURES, RESPECTIVELY.
%   SURFATURE RETURNS 2 ADDITIONAL ARGUEMENTS,
%   [K,H,Pmax,Pmin] = SURFATURE(...), WHERE Pmax AND Pmin ARE THE MINIMUM
%   AND MAXIMUM CURVATURES AT EACH POINT, RESPECTIVELY.

if ~exist('verbose','var')
    verbose =0;
end


% First Derivatives
[Xu,Xv] = gradient(X);
[Yu,Yv] = gradient(Y);
[Zu,Zv] = gradient(Z);

% Second Derivatives
[Xuu,Xuv] = gradient(Xu);
[Yuu,Yuv] = gradient(Yu);
[Zuu,Zuv] = gradient(Zu);

[Xuv,Xvv] = gradient(Xv);
[Yuv,Yvv] = gradient(Yv);
[Zuv,Zvv] = gradient(Zv);

%debugging test..
% v = -2:0.2:2;
% [x,y] = meshgrid(v);
% z = x .* exp(-x.^2 - y.^2);
% [px,py] = gradient(z,.2,.2);
% if ~verbose
%     contour(v,v,z), hold on, quiver(v,v,px,py), hold off
% end

% a=0:1:26;
% b=0:1:28;
% % figure
% plot3(X,Y, Zu, 'b*');
% figure
% plot3(X,Y, Zv, 'b*');
% 
% figure
if ~verbose
    contour(X,Y,Z), hold on, quiver(X,Y,Zu,Zv), hold on
    plot(pts_moved_cent(1,1),pts_moved_cent(1,2), 'ro'), hold on
end

absZu=abs(Zu);
absZv=abs(Zv);
s=absZu+absZv;
[b,c]=find(s==min(min(s(25:end-25,25:end-25))));
saddle=[X(b,c) Y(b,c) Z(b,c)];
if ~verbose
    plot(X(b,c),Y(b,c), 'bo'), hold off
end



% Reshape 2D Arrays into Vectors
Xu = Xu(:);   Yu = Yu(:);   Zu = Zu(:); 
Xv = Xv(:);   Yv = Yv(:);   Zv = Zv(:); 
Xuu = Xuu(:); Yuu = Yuu(:); Zuu = Zuu(:); 
Xuv = Xuv(:); Yuv = Yuv(:); Zuv = Zuv(:); 
Xvv = Xvv(:); Yvv = Yvv(:); Zvv = Zvv(:); 

Xu          =   [Xu Yu Zu];
Xv          =   [Xv Yv Zv];
Xuu         =   [Xuu Yuu Zuu];
Xuv         =   [Xuv Yuv Zuv];
Xvv         =   [Xvv Yvv Zvv];

% First fundamental Coeffecients of the surface (E,F,G)
E           =   dot(Xu,Xu,2);
F           =   dot(Xu,Xv,2);
G           =   dot(Xv,Xv,2);

m           =   cross(Xu,Xv,2);
p           =   sqrt(dot(m,m,2));
n           =   m./[p p p]; %unit normal each pt 

% Second fundamental Coeffecients of the surface (L,M,N)
L           =   dot(Xuu,n,2);
M           =   dot(Xuv,n,2);
N           =   dot(Xvv,n,2);

[s,t] = size(Z);

% Gaussian Curvature
K = (L.*N - M.^2)./(E.*G - F.^2);


% Mean Curvature
H = (E.*N + G.*L - 2.*F.*M)./(2*(E.*G - F.^2));


% Principal Curvatures
Pmax = H + sqrt(H.^2 - K);
Pmin = H - sqrt(H.^2 - K);


%principal direction unit vectors
a = [(Pmax .* F - M) ./ (L - Pmax .* E), (Pmin .* F - M) ./ (L -Pmin .* E)];
b = ones(size(a,1),2);
for i = 1:2
    mag = (a(:,i) .* a(:,i) + b(i) .* b(i)).^(1/2);
    a(:,i) = a(:,i) ./ mag;
    b(:,i) = b(:,i) ./ mag;
end %i

e1 = Xu .* [a(:,1) a(:,1) a(:,1)] + Xv .* [b(:,1) b(:,1) b(:,1)];
% e1 = unit(e1);

e2 = Xu .* [a(:,2) a(:,2) a(:,2)] + Xv .* [b(:,2) b(:,2) b(:,2)];
% e2 = unit(e2);

K = reshape(K,s,t);
H = reshape(H,s,t);
Pmax = reshape(Pmax,s,t);
Pmin = reshape(Pmin,s,t);
e1 = reshape(e1,s,t,3);
e2 = reshape(e2,s,t,3);

