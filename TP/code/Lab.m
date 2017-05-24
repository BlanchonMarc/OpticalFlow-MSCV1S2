im1 = imread('../sequences/garden/garden_1.png');
im2 = imread('../sequences/garden/garden_2.png');

ite = 100;
lambda = 0.1;

%[u,v] = HS(im1, im2 , lambda , ite);

%plotOF_arrows(u,v)

[u1,v1] = LK(im1, im2 , 5);

plotOF_arrows(u1,v1)