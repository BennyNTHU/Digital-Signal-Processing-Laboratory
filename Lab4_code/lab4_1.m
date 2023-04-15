clear
close all

%% Load ECG data and plot
% This raw ECG did not go through the analog notch filter

data = load('1025ECG.mat');
ECG=data.y;
ECG(isnan(ECG))=0;
fs = 500;
Npoint = length(ECG);

% calculate t_axis and f_axis
dt = 1 / fs; % time resolution
t_axis = (0 : dt : 1/fs*(Npoint - 1));
df = fs / Npoint; % frequency resolution
f_axis = (0:1:(Npoint-1))*df - fs/2;  % frequency axis (shifted)

figure(1) % plot signal
plot(t_axis, ECG)
xlabel('Time (sec)')
ylabel('Quantized value')
title("Raw ECG Signal")

%% (1) Design a digital filter to remove the 60Hz power noise
h=ones(1,8); % you may tune here
y=conv(h, ECG); % remove the 60Hz power noise
remove_baseline_ECG=highpass(y, 5, fs); % remove baseline wander noise % you may tune here

figure(2) % plot
plot(y)
xlabel('Time (sec)')
ylabel('Quantized value')
title("Remove noise & Baseline ECG")
%% difference filtering
a = 1; % Av of filter
b = [1 -1]; % difference filtering
df_ECG = filter(b,a,remove_baseline_ECG);

figure(3) % plot
plot(df_ECG)
xlabel('Time (sec)')
ylabel('Quantized value')
title("difference filtering")

%% Squaring
df_ECG_square = df_ECG.^2;

figure(4) % plot
plot(df_ECG_square)
xlabel('Time (sec)')
ylabel('Quantized value')
title("squaried")

%% flattening
flat_ECG=lowpass(df_ECG_square, 4, fs); % you may tune here

figure(5) % plot
plot(flat_ECG)
xlabel('Time (sec)')
ylabel('Quantized value')
title("flatted ECG")

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

figure(6) % plot
plot(th_ECG)
xlabel('Time (sec)')
ylabel('Quantized value')
title("thresholded ECG")

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

figure(7) % plot R_peaks
plot(t_axis,y)
hold on
plot(t_axis_R,R2,'o')
xlabel('Time (sec)')
ylabel('Quantized value')
title("Raw ECG Signal")
