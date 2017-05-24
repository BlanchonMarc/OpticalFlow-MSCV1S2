im1 = imread('/Users/marc/Documents/MsCV/Semester 2/Autonomous Robotics/OpticalFlowClass/TP/sequences/garden/garden_1.png');
im2 = imread('/Users/marc/Documents/MsCV/Semester 2/Autonomous Robotics/OpticalFlowClass/TP/sequences/garden/garden_2.png');

ite = 100;
lambda = 0.1;

[u,v] = HS(im1, im2 , lambda , ite);

plotOF_arrows(u,v)