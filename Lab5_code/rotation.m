% rotate image clockwised around the center point (1,1) with a radius degrees 
% input1---source image: I
% input2---rotation degrees: radius (ex: pi/3)
% output---rotated image: I_rot

function I_rot = rotation(I, radius);

% RGB channel
R(:, :) = I(:, :, 1);
G(:, :) = I(:, :, 2);
B(:, :) = I(:, :, 3);

% get height, width, channel of image
[height, width, ~] = size(I);

%% create new image
% step1. record image vertices, and use rotation matrix to get new vertices.
matrix = [cos(radius) -sin(radius) ; sin(radius) cos(radius)];
vertex = [1 1; width 1; 1 height; width height];
vertex_new = matrix*vertex.'; % 對每個column vector做線性變換

% step2. find min x, min y, max x, max y, use "min()" & "max()" function is ok
X_min = min(vertex_new(1,:)); % 旋轉後的圖形"邊界"
X_max = max(vertex_new(1,:)); 
Y_min = min(vertex_new(2,:)); % 旋轉後的圖形"邊界"
Y_max = max(vertex_new(2,:)); 

% step3. consider how much to shift the image to the positive axis
x_shift = X_min-1; % 需要"移動坐標軸"的量，使之能被移到"正確"的位置
y_shift = Y_min-1;

% step4. calculate new width and height, if they are not integer, use
% "ceil()" & "floor()" to help get the largest width and height.
width_new = ceil(X_max) - floor(X_min); % 計算新的圖片的長跟寬
height_new = ceil(Y_max) - floor(Y_min);

% initial r, g, b array for the new image
R_rot = zeros(height_new,width_new); % 建構新的圖片
G_rot = zeros(height_new,width_new);
B_rot = zeros(height_new,width_new);

%% backward warping using bilinear interpolation
% for each pixel on the rotation image, find the correspond r, g, b value 
% from the source image, and save to R_rot, G_rot, B_rot.
 for y_new=1:height_new
     for x_new=1:width_new
        
        % step5. shift the new pixel (y_new, x_new) back, and rotate -radius
        % degree to get (y_old, x_old)
        % 旋轉矩陣的反矩陣恰為其轉置 哈哈我線代不錯吧
        rotate_back_matrix = (matrix)';
        old_position = rotate_back_matrix * [double(x_new+x_shift); double(y_new+y_shift)];
        x_old=old_position(1,1);
        y_old=old_position(2,1);
                
        % step6. use "ceil()" & "floor()" to get interpolation coordinates
        % x1, x2, y1, y2
        x1=floor(x_old); % 向前向後的每一格，換句話說就是最靠近的四個格子
        y1=floor(y_old);
        x2=ceil(x_old);       
        y2=ceil(y_old);
                
        % step7. if (y_old, x_old) is inside of the source image, 
        % calculate r, g, b by interpolation.
        % else if (y_old, x_old) is outside of the source image, set
        % r, g, b = 0(black).
        if (x1 >= 1) && (x1 <= width) && (x2 >= 1) && (x2 <= width) && ...
            (y1 >= 1) && (y1 <= height)&& (y2 >= 1) && (y2 <= height)
            
            % step8. calculate weight wa, wb, notice that if x1 = x2 or y1 = y2,
            % function "wa = ()/(x1-x2)" will be fail. 
            % at this situation, you need to assign a value to wa directly.
            if (x1==x2) % 萬一相等就完了,需直接指定為1
                wa=1;
            else
                wa=(x_old-x1)/(x2-x1);
            end
            
            if (y1==y2)
                wb=1;
            else
                wb=(y_old-y1)/(y2-y1);
            end

            % step9. calculate weight w1, w2, w3, w4. 
            w1=(1-wa)*(1-wb); % 照抄講義上的公式
            w2=wa*(1-wb);
            w3=wa*wb;
            w4=(1-wa)*wb;
            
            % step10. calculate r, g, b with 4 neighbor points and their weights
            r =  R(y1,x1)*w1+R(y1,x2)*w2+R(y2,x1)*w3+R(y2,x2)*w4;
            g =  G(y1,x1)*w1+G(y1,x2)*w2+G(y2,x1)*w3+G(y2,x2)*w4;
            b =  B(y1,x1)*w1+B(y1,x2)*w2+B(y2,x1)*w3+B(y2,x2)*w4;
            
        else
            r = 0; % Thanks for writing for me!
            g = 0;
            b = 0;
        end
        R_rot(y_new, x_new) = double(r)/255;
        G_rot(y_new, x_new) = double(g)/255;
        B_rot(y_new, x_new) = double(b)/255;
    end
 end

% save R_rot, G_rot, B_rot to output image
I_rot(:, :, 1) = R_rot;
I_rot(:, :, 2) = G_rot;
I_rot(:, :, 3) = B_rot;

