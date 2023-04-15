% input1---source image: I
% input2---flip direction: type (0: horizontal, 1: vertical, 2: both)
% output---flipped image: I_flip

function I_flip = flipI(I, type);

% RGB channel
R = I(:, :, 1);
G = I(:, :, 2);
B = I(:, :, 3);

% get height, width, channel of image
[height, width, channel] = size(I);

%%  horizontal flipping
if type == 0
    % initial r, g, b array for flipped image using zeros()
    R_flip = zeros(height,width);
    G_flip = zeros(height,width);
    B_flip = zeros(height,width);
    
    % assign pixels from R, G, B to R_flip, G_flip, B_flip
    for i=1:width
        R_flip(:, i) = double(R(:, width-i+1))/255;
        G_flip(:, i) = double(G(:, width-i+1))/255;
        B_flip(:, i) = double(B(:, width-i+1))/255;
    end
    
    % save R_flip, G_flip, B_flip to output image
    I_flip(:, :, 1) = R_flip;
    I_flip(:, :, 2) = G_flip;
    I_flip(:, :, 3) = B_flip;
end

%% vertical flipping
if type == 1
    % initial r, g, b array for flipped image using zeros()
    R_flip = zeros(height,width);
    G_flip = zeros(height,width);
    B_flip = zeros(height,width);
    
    for i=1:height
        R_flip(i, :) = double(R(height-i+1, :))/255;
        G_flip(i, :) = double(G(height-i+1, :))/255;
        B_flip(i, :) = double(B(height-i+1, :))/255;
    end
    
    % save R_flip, G_flip, B_flip to output image
    I_flip(:, :, 1) = R_flip;
    I_flip(:, :, 2) = G_flip;
    I_flip(:, :, 3) = B_flip;
end

%%  horizontal + vertical flipping
if type == 2
    R_flip = zeros(height,width);
    G_flip = zeros(height,width);
    B_flip = zeros(height,width);
    
    for i=1:height
        R_flip(i,:) = double(R(height-i+1,:))/255;
        G_flip(i,:) = double(G(height-i+1,:))/255;
        B_flip(i,:) = double(B(height-i+1,:))/255;
    end
    
    for i=1:width/2
        v = R_flip(:,i);
        R_flip(:,i) = R_flip(:,width-i+1);
        R_flip(:,width-i+1) = v;
        v = G_flip(:,i);
        G_flip(:,i) = G_flip(:,width-i+1);
        G_flip(:,width-i+1) = v;
        v = B_flip(:,i);
        B_flip(:,i) = B_flip(:,width-i+1);
        B_flip(:,width-i+1) = v;
    end
    
    % save R_flip, G_flip, B_flip to output image
    I_flip(:, :, 1) = R_flip;
    I_flip(:, :, 2) = G_flip;
    I_flip(:, :, 3) = B_flip;
end