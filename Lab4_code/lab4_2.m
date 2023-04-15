clear; close all; clc;

%% Load ECG data and plot
% loadfiles

file = ['230.xlsx']; %填入檔案名稱
MIT_ans = importdata(file);
MIT_ans = MIT_ans.data;
MIT_ans = MIT_ans(:,4);
MIT_ans = MIT_ans.';
MIT_ans = [MIT_ans 0];

load 230m.mat; %填入檔案名稱
ECG=val(1,:);

fs = 360;
Npoint = length(ECG);

% calculate t_axis and f_axis
dt = 1 / fs; % time resolution
t_axis = (0 : dt : 1/fs*(Npoint - 1));
df = fs / Npoint; % frequency resolution
f_axis = (0:1:(Npoint-1))*df - fs/2;  % frequency axis (shifted)

%% (1) Design a digital filter to remove the 60Hz power noise
h=ones(1,30); % you may tune here
y=lowpass(ECG, 50, fs); % remove the 60Hz power noise
remove_baseline_ECG=highpass(y, 5, fs); % remove baseline wander noise % you may tune here

%% difference filtering
a = 1;
b = [1 -1];
df_ECG = filter(b,a,remove_baseline_ECG);

%% Squaring
df_ECG_square = df_ECG.^2;

%% flattening
flat_ECG=lowpass(df_ECG_square, 4, fs); % you may tune here

%% Thresholding
th_ECG=[];
m=mean(flat_ECG);
for i=1:length(flat_ECG)
    if flat_ECG(i) > 1.5*m % 10/25:Use 1.5*m as new threhold, success in dorm % you may tune here
        th_ECG(i)=flat_ECG(i);
    else
        th_ECG(i)=0;
    end
end

%% Find the peak
[pks_th,locs_th,w,~] = findpeaks(th_ECG);
R_index=[];
R=[];
for i=1:length(locs_th)
    if i < length(locs_th)
        [pks_ECG,index_ECG] = max(ECG(locs_th(i):locs_th(i)+round(w)+10));
    else
        [pks_ECG,index_ECG] = max(ECG(locs_th(i)-10:length(ECG)));
    end
    index_ECG = index_ECG + locs_th(i) - 1;
    if index_ECG<length(ECG)
        R_index=[R_index index_ECG];
    end
    R=[R pks_ECG];
end

dt = 1 / fs; % time resolution
t_axis = (0 : dt : 1/fs*(length(remove_baseline_ECG) - 1));
t_axis_R = R_index.*dt;
R2=[];
for i=1:length(t_axis_R)
    R2=[R2 y(R_index(i))];
end

%% Calculate the desired values
%t_axis_R vs ans
TP = 0;
FN = 0;
FP = 0;

i=1;  
j=1;
t_axis_R = [t_axis_R 0]; % For convnience
while (MIT_ans(i)~=0 && t_axis_R(j)~=0) % Walk through the array
    if (abs(t_axis_R(j)-MIT_ans(i)) <= 20*dt)
        TP = TP+1;
        i = i+1;
        j = j+1;
    elseif ((t_axis_R(j)-MIT_ans(i)) < 20*dt)
        FN = FN+1;
        j = j+1;
    else
        FP = FP+1;
        i = i+1;
    end
end

if (j < length(MIT_ans)) % There are some last points in t_axis_R haven't be determined yet
    FN = FN+length(MIT_ans)-j; % Don't find some last peaks
elseif (i < length(t_axis_R))  % Wrong peaks
    FP = FP+length(t_axis_R)-i;
end

record=[TP FN FP]; % show the result
record 

