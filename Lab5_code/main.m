close all; clear; clc;

%% read image
filename = '../image.jpg';
I = imread(filename);
figure('name', 'source image');
imshow(I);

%% ----- call functions ----- %%
% output = function(input1, input2, ...);
% grey_scale function
I2 = grey_scale(I);

% flip function
I3 = flipI(I,0);


% rotation function
I4 = rotation(I, pi/3);

% resize function
I5 = resize(I, 0.6);

% flip function
I6 = flipI(I,1);
I7 = flipI(I,2);

%% show image
figure('name', 'grey scale image'),
imshow(I2);
figure('name', 'flipped image'),
imshow(I3);
figure('name', 'rotated image'),
imshow(I4);
figure('name', 'resized image'),
imshow(I5);

%% write image
%save image for your report
filename2 = '../results/grey_image2.jpg';
imwrite(I2, filename2);
filename3 = '../results/hor_flip_image2.jpg';
imwrite(I3, filename3);
filename4 = '../results/rotated_image2.jpg';
imwrite(I4, filename4);
filename5 = '../results/resized_image2.jpg';
imwrite(I5, filename5);
filename6 = '../results/ver_flip_image2.jpg';
imwrite(I6, filename6);
filename7 = '../results/hor_ver_image2.jpg';
imwrite(I7, filename7);




