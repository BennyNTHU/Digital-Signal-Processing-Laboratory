clear
close all

%% Load ECG data
% This raw ECG did not go through the analog notch filter
data = load('ECG_signal.mat');
ECG = data.ECG;
fs = data.fs;
Npoint = length(ECG);

% calculate t_axis and f_axis
dt = 1 / fs; % time resolution
t_axis = (0 : dt : 1/fs*(Npoint - 1));
df = fs / Npoint; % frequency resolution
f_axis = (0:1:(Npoint-1))*df - fs/2;  % frequency axis (shifted)

% plot signal and its frequency spectrum
figure(1)
plot(t_axis, ECG)
xlabel('Time (sec)')
ylabel('Quantized value')
title("Raw ECG Signal")

figure(2)
plot(f_axis, abs(fftshift(fft(ECG))))
title('Frequency spectrum')

%% (1) Design a digital filter to remove the 60Hz power noise

% filter design
% https://www.mathworks.com/help/signal/filter-design.html
% Hint: you may use moving average filter or fir1() or anything else
% In the report, please describe how you design this filter

% filtering

% Plot the filtered signal and its frequency spectrum
lpf = fir1(330, 3.1415/100);
h=ones(1,10);
x=conv(lpf, ECG);
y=conv(h, ECG);

figure(3)
plot(x)

figure(4)
plot(y)


%% (2) Design a digital filter to remove baseline wander noise

% filter design or somehow remove the baseline wander noise
% Hint: you may use high-pass filters or (original signal - low passed signal)

% plot the filtered signal
remove_baseline_ECG=highpass(y, 5, fs);
figure(5)
plot(remove_baseline_ECG)


%% (3) Utilizing the ADC dynamic range in 8-bit
% the code should be written in Arduino
