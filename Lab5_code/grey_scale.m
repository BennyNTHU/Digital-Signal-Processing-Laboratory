%% grey scale 
% 1. matrix: [a,b,c] = [a b c]
%    matrix: [a;b;c] = [a b c]'
%
% 2. zeros: create an array of 0
% zeros(3) = [ 0 0 0 
%              0 0 0 
%              0 0 0 ]
% zeros(2,5) = [ 0 0 0 0 0
%                0 0 0 0 0 ]
% data type of zeros() is preset "double".
% show the result on command window to help yourself understand 

%% data type
% 1. data type of RGB channel is preset "uint8", range 0-255
% assume that Y = R+G+B; if R+G+B > 255, Y will be assigned the maximum 255,
% so we need to calculate in data type "double": 
%               Y = double(R) + double(G) + double(B);
%
% 2. data type and data range for imshow(I)
% uint8: 0-255:   Y = uint8((double(R) + double(G) + double(B)) / 3);
%                    => turn back to uint8
% double: 0-1     Y = ((double(R) + double(G) + double(B)) / 3) / 255;
%                    => scale 0-255 to 0-1

%% function
% input---source image: I
% output---grey scale image: I_grey
function I_grey = grey_scale(I);

% RGB channel
R = I(:, :, 1);
G = I(:, :, 2);
B = I(:, :, 3);

% get height, width, channel of the image
[height, width, ~] = size(I);

% initial the intensity array Y using zeros()
Y = zeros(height, width);

% weight of RGB channel
matrix = [0.299 0.587 0.114];

% implement the grey scale convertion

Y = (matrix(1)*double(R)+matrix(2)*double(G)+matrix(3)*double(B))/255;
    
% save intensity Y to output image
I_grey(:, :, 1) = Y;
I_grey(:, :, 2) = Y;
I_grey(:, :, 3) = Y;
