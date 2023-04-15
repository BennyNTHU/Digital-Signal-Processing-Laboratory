% rotate image clockwised around the center point (1,1) with a radius
% degrees by forward_warping method
% input1---source image: I
% input2---rotation degrees: radius (ex: pi/3)
% output---rotated image: I_rot

function I_rot = forward_warping(I, radius);

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
B_rot = zeros(height_new,width_new); %到以上都一樣,照抄就可以了

%% backward warping using bilinear interpolation
% for each pixel on the rotation image, find the correspond r, g, b value 
% from the source image, and save to R_rot, G_rot, B_rot.
 for y_old=1:height
     for x_old=1:width
        
        % step5. 換成新的坐標 (只有這裡不一樣)
        new_position = matrix * [double(x_old); double(y_old)];
        x_new=new_position(1,1)-x_shift;
        y_new=new_position(2,1)-y_shift;
                
        % step6. use "ceil()" & "floor()" to get interpolation coordinates
        % x1, x2, y1, y2
        x1=floor(x_new); % 向前向後的每一格，換句話說就是最靠近的四個格子
        y1=floor(y_new);
        x2=ceil(x_new);       
        y2=ceil(y_new);
                
        % step7. if (y_old, x_old) is inside of the source image, 
        % calculate r, g, b by interpolation.
        % else if (y_old, x_old) is outside of the source image, set
        % r, g, b = 0(black).
        if (x1 >= 1) && (x1 <= width_new) && (x2 >= 1) && (x2 <= width_new) && ... 
            (y1 >= 1) && (y1 <= height_new)&& (y2 >= 1) && (y2 <= height_new) % 條件是一樣的，只是改成在新的圖片上
            
            % step8. calculate weight wa, wb, notice that if x1 = x2 or y1 = y2,
            % function "wa = ()/(x1-x2)" will be fail. 
            % at this situation, you need to assign a value to wa directly.
            if (x1==x2) % 萬一相等就完了,需直接指定為1
                wa=1;
            else
                wa=(x_new-x1)/(x2-x1);
            end
            
            if (y1==y2)
                wb=1;
            else
                wb=(y_new-y1)/(y2-y1);
            end

            % step9. calculate weight w1, w2, w3, w4. 
            w1=(1-wa)*(1-wb); % 照抄講義上的公式
            w2=wa*(1-wb);
            w3=wa*wb;
            w4=(1-wa)*wb;
            
            % step10. calculate r, g, b with 4 neighbor points and their weights
            R_rot(y1,x1) = R_rot(y1,x1) + double(R(y_old,x_old))*w1;
            G_rot(y1,x1) = G_rot(y1,x1) + double(G(y_old,x_old))*w1;
            B_rot(y1,x1) = B_rot(y1,x1) + double(B(y_old,x_old))*w1;
            
            R_rot(y1,x2) = R_rot(y1,x2) + double(R(y_old,x_old))*w2;
            G_rot(y1,x2) = G_rot(y1,x2) + double(G(y_old,x_old))*w2;
            B_rot(y1,x2) = B_rot(y1,x2) + double(B(y_old,x_old))*w2;
            
            R_rot(y2,x1) = R_rot(y2,x1) + double(R(y_old,x_old))*w3;
            G_rot(y2,x1) = G_rot(y2,x1) + double(G(y_old,x_old))*w3;
            B_rot(y2,x1) = B_rot(y2,x1) + double(B(y_old,x_old))*w3;
            
            R_rot(y1,x2) = R_rot(y1,x2) + double(R(y_old,x_old))*w4;
            G_rot(y1,x2) = G_rot(y1,x2) + double(G(y_old,x_old))*w4;
            B_rot(y1,x2) = B_rot(y1,x2) + double(B(y_old,x_old))*w4;
        end
    end
 end

% save R_rot, G_rot, B_rot to output image
I_rot(:, :, 1) = (double(R_rot)/255);
I_rot(:, :, 2) = (double(G_rot)/255);
I_rot(:, :, 3) = (double(B_rot)/255);