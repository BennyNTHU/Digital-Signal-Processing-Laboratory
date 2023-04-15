% Flip by matrix

function flip_by_matrix = flip_by_matrix(I, type);

% RGB channel
I = double(I);
R = I(:, :, 1);
G = I(:, :, 2);
B = I(:, :, 3);

% get height, width, channel of image
[height, width, ~] = size(I);

%%  horizontal flipping
if type == 0
    A=fliplr(eye(width));
    R_flip = (A*R.'./255).';
    G_flip = (A*G.'./255).';
    B_flip = (A*B.'./255).';
end

%% vertical flipping
if type == 1
    A=fliplr(eye(height));
    R_flip = A*R/255;
    G_flip = A*G/255;
    B_flip = A*B/255;
end

%%  horizontal + vertical flipping
if type == 2
    A=fliplr(eye(height));
    R_flip = A*R;
    G_flip = A*G;
    B_flip = A*B;
    A=fliplr(eye(width));
    R_flip = (A*R_flip.'./255).';
    G_flip = (A*G_flip.'./255).';
    B_flip = (A*B_flip.'./255).';
end

flip_by_matrix(:, :, 1) = R_flip;
flip_by_matrix(:, :, 2) = G_flip;
flip_by_matrix(:, :, 3) = B_flip;