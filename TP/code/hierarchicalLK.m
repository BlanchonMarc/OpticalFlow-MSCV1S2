function [u,v] = hierarchicalLK_corrected(im1, im2, numLevels, windowSize)
% Hierarchical implementation of Lucas and Kanade of OF method

% graylevel image
if (size(im1,3) ~= 1) || (size(im2, 3) ~= 1)
    im1 = rgb2gray(im1);
    im2 = rgb2gray(im2);
end;

im1 = double(im1);
im2 = double(im2);

im1 = imgaussfilt(im1,2);
im2 = imgaussfilt(im2,2);

% Build the pyramids
im1Pyr = {};
im2Pyr = {};
im1Pyr{1} = im1;
im2Pyr{1} = im2;

for i=2:numLevels
    im1Pyr{i} = imresize(im1Pyr{i-1},1/2);
    im2Pyr{i} = imresize(im2Pyr{i-1},1/2);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Begin of "Write your code here" section %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[u_base , v_base] = LK(im1Pyr{numLevels},im2Pyr{numLevels},windowSize);

for level = numLevels-1 : -1 : 1 %iterative way of descending levels
    
    u_current = u_base;
    v_current = v_base;
    
    
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% End of "Write your code here" section %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
