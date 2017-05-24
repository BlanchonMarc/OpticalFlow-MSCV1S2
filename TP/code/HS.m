function [u, v] = HS(im1, im2, lambda, ite)
% Horn-Schunck optical flow method 

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

IxMask = [-1 1; -1 1]; % Create the X derivative filter
IyMask = [-1 -1; 1 1]; % Create the Y derivative filter

ItMask_1 = [-1 -1; -1 -1]; %Create both the filters for the time derivative
ItMask_2 = [1 1; 1 1];

meanFilter = (1/8) * ones(3,3); % Create the mean filter and make the sum = 1 with the center pixel with no weight (0)
meanFilter(2,2) = 0;

Ix = (imfilter(im1,IxMask) + imfilter(im2,IxMask))/2; % Convolute the corrsponding filters with the images
Iy = (imfilter(im1,IyMask) + imfilter(im2,IyMask))/2;
It = imfilter(im1,ItMask_1) + imfilter(im2,ItMask_2);

u = zeros(size(im1)); % create u and v matrices
v = zeros(size(im1));

lambda_matrix = lambda * ones(size(u)); % create a matrix of lambdas values to easily compute the HS formula

for i = 1 : ite
    ubar  = imfilter(u , meanFilter); % caculate respectively ubar and v bar according to u and v and the mean filter
    vbar  = imfilter(v , meanFilter);
    
    u = ubar - (Ix .* ( It + vbar.*Iy + Ix.*ubar )) ./ (lambda_matrix.^2 + Iy.^2 + Ix.^2);  % formulas of the HS algorithm
    v = vbar - (Iy .* ( It + vbar.*Iy + Ix.*ubar )) ./ (lambda_matrix.^2 + Iy.^2 + Ix.^2); 
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% End of "Write your code here" section %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

u(isnan(u))=0;
v(isnan(v))=0;
