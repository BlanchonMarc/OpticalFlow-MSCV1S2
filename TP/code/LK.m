function [u, v] = LucasKanade(im1, im2, windowSize)
% Lucas and Kanade of OF method

if size(size(im1),2)==3
    im1=rgb2gray(im1);
end
if size(size(im2),2)==3
    im2=rgb2gray(im2);
end

im1=double(im1);
im2=double(im2);

im1 = imgaussfilt(im1,2);
im2 = imgaussfilt(im2,2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Begin of "Write your code here" section %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


u = zeros(size(im1)); % create u and v matrices
v = zeros(size(im2));


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

newnumb1 = size(im1,1) - mod(size(im1,1),windowSize);
newnumb2 = size(im1,2) - mod(size(im1,2),windowSize);

for i = 1 : newnumb1 - windowSize
    for j = 1 : newnumb2 - windowSize
%for i = 1 : windowSize : newnumb1 - windowSize
 %   for j = 1 : windowSize : newnumb2 - windowSize
        %Ixwindow=Ix(i  : i + windowSize , j : j + windowSize);
        %Iywindow=Iy(i  : i + windowSize , j : j + windowSize);
        %Itwindow=It(i  : i + windowSize , j : j + windowSize);
        
        Ixwindow=Ix(i  : i + windowSize , j : j + windowSize);
        Iywindow=Iy(i  : i + windowSize , j : j + windowSize);
        Itwindow=It(i  : i + windowSize , j : j + windowSize);
        
        Ixwindow = reshape(Ixwindow , [1 , size(Ixwindow,1)^2 ])';
        Iywindow = reshape(Iywindow , [1 , size(Iywindow,1)^2 ])';
        Itwindow = reshape(Itwindow , [1 , size(Itwindow,1)^2 ])';
        
        A=[Ixwindow Iywindow];
        B=Itwindow;

        [outpute]=inv(A'*A)*A'*B;

        
        u(i  , j) = outpute(1);
        v(i  , j) = outpute(2);
        
        
    end
end
% A=[Ixwindow Iywindow];
% B=Itwindow;
% 
% [outpute]=inv(A'*A)*A'*B;
% 
% size(outpute)
% 
% u=outpute(1:windowSize^2,:);
% v=outpute((windowSize^2)+1:(windowSize^2)*2,:);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Begin of "Write your code here" section %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

u(isnan(u))=0;
v(isnan(v))=0;
