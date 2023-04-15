function output = my_imfilter(image, filter)
% This function is intended to behave like the built in function imfilter()
% See 'help imfilter' or 'help conv2'. While terms like "filtering" and
% "convolution" might be used interchangeably, and they are indeed nearly
% the same thing, there is a difference:
% from 'help filter2'
%    2-D correlation is related to 2-D convolution by a 180 degree rotation
%    of the filter matrix.
% Your function should work for color images. Simply filter each color
% channel independently.
% Your function should work for filters of any width and height
% combination, as long as the width and height are odd (e.g. 1, 7, 9). This
% restriction makes it unambigious which pixel in the filter is the center
% pixel.
% Boundary handling can be tricky. The filter can't be centered on pixels
% at the image boundary without parts of the filter being out of bounds. If
% you look at 'help conv2' and 'help imfilter' you see that they have
% several options to deal with boundaries. You should simply recreate the
% default behavior of imfilter -- pad the input image with zeros, and
% return a filtered image which matches the input resolution. A better
% approach is to mirror the image content over the boundaries for padding.
% % Uncomment if you want to simply call imfilter so you can see the desired
% % behavior. When you write your actual solution, you can't use imfilter,
% % filter2, conv2, etc. Simply loop over all the pixels and do the actual
% % computation. It might be slow.
% output = imfilter(image, filter);

if size(image, 3)==3 % 彩色圖片

[height, width, ~] = size(image);
[filter_height, filter_width] = size(filter);

R = image(:, :, 1);
G = image(:, :, 2);
B = image(:, :, 3);
R_filt = zeros(height,width);
G_filt = zeros(height,width);
B_filt = zeros(height,width);
output(:, :, 1) = R_filt;
output(:, :, 2) = G_filt;
output(:, :, 3) = B_filt;

paddingR = padarray(R,[(filter_height-1)/2 (filter_width-1)/2],0,'both');   % padding zeros for R
paddingG = padarray(G,[(filter_height-1)/2 (filter_width-1)/2],0,'both');   % padding zeros for G
paddingB = padarray(B,[(filter_height-1)/2 (filter_width-1)/2],0,'both');   % padding zeros for B

for x=1:height
    for y=1:width
        R_filt(x,y)=sum(paddingR(x:filter_height+x-1, y:filter_width+y-1).*filter, 'all');
    end
end

for x=1:height
    for y=1:width
        G_filt(x,y)=sum(paddingG(x:filter_height+x-1, y:filter_width+y-1).*filter, 'all');
    end
end

for x=1:height
    for y=1:width
        B_filt(x,y)=sum(paddingB(x:filter_height+x-1, y:filter_width+y-1).*filter, 'all');
    end
end

output(:, :, 1) = R_filt;
output(:, :, 2) = G_filt;
output(:, :, 3) = B_filt;

elseif size(image, 3)==3
    [height, width, ~] = size(image);
    [filter_height, filter_width] = size(filter);
    R = image(:, :);
    R_filt = zeros(height,width);
    output(:, :) = R_filt;
    paddingR = padarray(R,[(filter_height-1)/2 (filter_width-1)/2],0,'both');   % padding zeros for R
    for x=1:height
        for y=1:width
            R_filt(x,y)=sum(paddingR(x:filter_height+x-1, y:filter_width+y-1).*filter, 'all');
        end
    end
    output(:, :, 1) = R_filt;
else
    output=image;
end