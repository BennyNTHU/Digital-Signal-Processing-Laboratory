% My Harris detector
% The code calculates
% the Harris Feature/Interest Points (FP or IP) 

% When u execute the code, the test image file opened
% then the code will print out and display the feature points.
% You can select the number of FPs by changing the variables 

%%%
%corner : significant change in all direction for a sliding window
%%%

close all; clc; clear;
%%
% parameters
% corner response related
sigma = 2;
n_x_sigma = 6;
alpha = 0.04;

% maximum suppression related
Thrshold = 25;  % should be between 0 and 1000
r = 10;          % k for calculate Rv


%%
% filter kernels
dx = [-5 0 3; -5 0 3; -5 0 3]; % horizontal gradient filter 
dy = dx'; % vertical gradient filter
g = fspecial('gaussian', max(1, fix(2 * n_x_sigma*sigma)), sigma); % Gaussien Filter: filter size 2*n_x_sigma*sigma
% g = ones(max(1, fix(2 * n_x_sigma*sigma)));
%g = fspecial('log',max(1, fix(2 * n_x_sigma*sigma)), sigma);

%% load 'Im.jpg'
frame = imread('data/ntu.jpg');
I = double(frame);
figure(1);
imagesc(frame);
[xmax, ymax,ch] = size(I);
xmin = 1;
ymin = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%% Intrest Points %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%%% get image gradient

% Grey Scale
R = I(:, :, 1);
G = I(:, :, 2);
B = I(:, :, 3);
matrix = [0.299 0.587 0.114];
Y = (matrix(1)*double(R)+matrix(2)*double(G)+matrix(3)*double(B))/255;
I_g = Y;

% calculate Ix
Ix=conv2(I_g,dx,'same');

% calcualte Iy
Iy=conv2(I_g,dy,'same');


%%% get all components of second moment matrix M = [[Ix2 Ixy];[Iyx Iy2]];
%%% note Ix2 Ixy Iy2 are all Gaussian smoothed

% calculate Ix2 
Ix2=conv2(Ix.*Ix, g, 'same');

% calculate Iy2
Iy2=conv2(Iy.*Iy, g, 'same');

% calculate Ixy
Ixy=conv2(Ix.*Iy, g, 'same');


%% visualize Ixy
figure(2);
imagesc(Ixy);

%-------------------------- Demo Check Point -----------------------------%

%%
%%% get corner response function R = det(M)-alpha*trace(M)^2
% calculate R
R = zeros(xmax, ymax);
for i=1:xmax
    for j=1:ymax
        M=[Ix2(i,j) Ixy(i,j); Ixy(i,j) Iy2(i,j)];
        R(i,j) = det(M)-alpha*trace(M)^2;
    end
end

%% make max R value to be 1000
R = (1000 / max(max(R)+eps)) * R; % be aware of if max(R) is 0 or not

%% using B = ordfilt2(A,order,domain) to complment a maxfilter
sze = 2*r + 1; % domain width

%%% find local maximum and get RBinary.
% calculate MX
MX = ordfilt2(R,sze^2,ones(sze,sze)); 

% calculate RBinary
RBinary = zeros(xmax, ymax);
for i=1:xmax
    for j=1:ymax
        if MX(i,j)>Thrshold
            if MX(i,j)==R(i,j)
                RBinary(i,j)=1;
            end
        end
    end
end


%% get location of corner points not along image's edges
offe = r-1;
count = sum(sum(RBinary(offe:size(RBinary, 1) - offe, offe:size(RBinary,2) - offe))); % How many interest points, avoid the image's edge   
R = R*0;
R(offe:size(RBinary, 1) - offe, offe:size(RBinary, 2) - offe) = RBinary(offe:size(RBinary, 1) - offe, offe:size(RBinary, 2) - offe);
[r1,c1] = find(R);
  

%% Display
figure(3)
imagesc(uint8(I));
hold on;
plot(c1,r1,'or');
return;
