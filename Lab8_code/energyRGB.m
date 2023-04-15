function res = energyRGB(I)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sum up the enery for each channel 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

R = I(:, :, 1);
G = I(:, :, 2);
B = I(:, :, 3);

dx = [-1 0 1; -1 0 1; -1 0 1]; % horizontal gradient filter 
dy = dx'; % vertical gradient filter
Rx=abs(conv2(R,dx,'same'));    % calculate Ix
Ry=abs(conv2(R,dy,'same'));    % calcualte Iy
Gx=abs(conv2(G,dx,'same'));    % calculate Ix
Gy=abs(conv2(G,dy,'same'));    % calcualte Iy
Bx=abs(conv2(B,dx,'same'));    % calculate Ix
By=abs(conv2(B,dy,'same'));    % calcualte Iy

res = Rx+Ry+Gx+Gy+Bx+By;
end

function res = energyGrey(I)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% returns energy of all pixelels
% e = |dI/dx| + |dI/dy|
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dx = [-1 0 1; -1 0 1; -1 0 1]; % horizontal gradient filter 
dy = dx'; % vertical gradient filter
res = abs(conv2(I,dx,'same')) + abs(conv2(I,dy,'same'));
end

