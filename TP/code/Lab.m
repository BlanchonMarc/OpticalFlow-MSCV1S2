%% OPTICAL FLOW PRACTICAL
% Blanchon Marc
% MsCV 

clear all;
close all;
clc;
%% PART 1

%% IMAGES

im1 = imread('../sequences/garden/garden_1.png');
im2 = imread('../sequences/garden/garden_2.png');

warning('off','all'); %removing warning for LK function 


%% HORN AND SCHUNCK
ite = 100;
lambda = 0.1;

disp('Computation of Horn and Schunck Optical Flow : Process');
[u,v] = HS(im1, im2 , lambda , ite);
disp('Computation of Horn and Schunck Optical Flow : Done');

plotOF_arrows(u,v)
str = sprintf('Horn and Schunck computation of optical flow with lambda  = %i and #of iterations %i' , lambda , ite);
title(str);

%% LUCAS AND KANADE
windowSize = 5;

disp('Computation of Lucas and Kanade Optical Flow : Process');
[u1,v1] = LK(im1, im2 , windowSize);
disp('Computation of Lucas and Kanade Optical Flow : Done');

plotOF_arrows(u1,v1)
str = sprintf('Lucas and Kanade computation of optical flow with windowsize  = %i' , windowSize);
title(str);

%% LUCAS AND KANADE HIERARCHICAL



%% PART 2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Affine model                                                             %
%u = ax + by + c                                                          %
%v = dx + ey + f                                                          %
%                                                                         %
%OFCE                                                                     %
%Ix.u + Iy.v + It = 0                                                     %
%                                                                         %
% ------------------------------------------------------------------------%
%                                                                         %
%Ix( ax + by + c ) + Iy( dx + ey + f ) + It = 0                           %
%                                                                         %
%[Ix.x Ix.y Ix Iy.x Iy.y Iy] * [a b c d e f]' = -It                       %
%                                                                         %
%[Ix1.x1 Ix1.y1 Ix1 Iy1.x1 Iy1.y1 Iy1] * [  a  ] = [ -It1 ]               %
%[...................................]   [  b  ]   [  ... ]               %
%[...................................]   [  c  ]   [  ... ]               %
%[...................................]   [  d  ]   [  ... ]               % 
%[...................................]   [  e  ]   [  ... ]               %
%[...................................]   [  f  ]   [ -Itn ]               %
%[Ixn.xn Ixn.yn Ixn Iyn.xn Iyn.yn Iyn]                                    %
%                                                                         %
%-------------------------------------------------------------------------%
%                                                                         %
%   M * ? = P                                                             %
%   M'M * ? = M' * P                                                      %
%   ? = inv(M'M) * M' * P                                                 %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


IxMask = [-1 1; -1 1]; % Create the X derivative filter
IyMask = [-1 -1; 1 1]; % Create the Y derivative filter

ItMask_1 = [-1 -1; -1 -1]; %Create both the filters for the time derivative
ItMask_2 = [1 1; 1 1];


im1x = conv2(im1, IxMask,'same');
im2x = conv2(im2, IxMask,'same');
im1y = conv2(im1, IyMask,'same');
im2y = conv2(im2, IyMask,'same');

im1t = conv2(im1, ItMask_1,'same');
im2t = conv2(im2, ItMask_2,'same');

Ix = (im1x + im2x) ./ 2;
Iy = (im1y + im2y) ./ 2;
It = (im1t + im2t) ./ 2;

M=[];
P=[];

for i = 1 : size(im1,1)
    for j = 1 : size(im1,2)
        M = [M ; Ix(i,j)*i Ix(i,j)*j Ix(i,j) Iy(i,j)*i Iy(i,j)*j Iy(i,j)];
        P = [P ; It(i,j)];
    end
end


Theta = inv(M'*M) * M' * P;

[xm,ym] = meshgrid(1 : size(im2,2) , 1 : size(im2,1));

u2 = Theta(1) * xm + Theta(2) * ym + Theta(3);
v2 = Theta(4) * xm + Theta(5) * ym + Theta(6);

plotOF_arrows(u2,v2)

[xm_move,ym_move] = meshgrid(1 : size(im2,2) , 1 : size(im2,1));

xm_move = xm_move + u2;
ym_move = ym_move + v2;

newim = zeros(size(im2));

xm_move = floor(xm_move);
ym_move = floor(ym_move);

for i = 1 : size(im2,1)
    for j = 1 : size(im2,2)       
        if xm_move(i,j) > 0 && ym_move(i,j) > 0 && xm_move(i,j) < size(im2,2) && ym_move(i,j) < size(im2,1)
            %fprintf('inside : %f , %f \n' , xm_move(i,j) , ym_move(i,j));
            newim(i,j) = im2( ym_move(i,j) , xm_move(i,j));
        end
    end
end

figure
imshow(newim,[])

