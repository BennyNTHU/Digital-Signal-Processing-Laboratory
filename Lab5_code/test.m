clc; clear; close;

% 這個程式只是拿來檢查的 沒有特別的用途
I=imread('../image.jpg');

%% grey scale
I_grey = grey_scale(I);
imshow(I_grey)

%% flip
tic
I_flip_h = flipI(I, 0);
toc
%%
I_flip_v = flipI(I, 1);
I_flip_vh = flipI(I, 2);
figure(1)
imshow(I_flip_h)
figure(2)
imshow(I_flip_v)
figure(3)
imshow(I_flip_vh)

%% Image rotation
tic
I_rot=rotation(I, pi/4);
toc
%imshow(I_rot)

%% resize
I_res = resize(I, 10);
imshow(I_res)

%% forward_warping
tic
I_rot = forward_warping(I, pi/3);
toc
imshow(I_rot)

%% flip_by_matrix
I_flip_by_matrix_h = flip_by_matrix(I, 0);
I_flip_by_matrix_v = flip_by_matrix(I, 1);
I_flip_by_matrix_vh = flip_by_matrix(I, 2);
figure(1)
imshow(I_flip_by_matrix_h)
figure(2)
imshow(I_flip_by_matrix_v)
figure(3)
imshow(I_flip_by_matrix_vh)
