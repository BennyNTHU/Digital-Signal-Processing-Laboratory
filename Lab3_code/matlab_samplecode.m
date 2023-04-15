clear all;
fclose('all');

serialobj=instrfind;
if ~isempty(serialobj)
    delete(serialobj)
end
clc;clear all;close all;
s1 = serial('COM3');  %define serial port
s1.BaudRate=115200;     %define baud rate
 
disbuff=nan(1,1000);

fopen(s1);
clear data;
N_point = 1000; % fs*drawing time=N_point
fs=500;   %sample rate 500 200 100 80
time=[0:1/fs:2-1/fs]; 
figure
h_plot=plot(nan,nan);
hold off 
tic
for i= 1:N_point 
    data=fscanf(s1);%read sensor
    y(i) = str2double(data);

    if i<=1000
    disbuff(i)=y(i);
    
    else
    disbuff=[disbuff(2:end) y(i)];
    end

    if i>1
    set(h_plot,'xdata',time,'ydata',disbuff)
    title('test');
    xlabel('Time');
    ylabel('Quantization value');
    drawnow;
    end
   
end

%%
% Fourier transform
df = fs/N_point; % frequency resolution
f_axis = (0:1:(N_point-1))*df;   % frequency axis
SAMPLED_COS = fft(y); % spectrum of sampled cosine, freqeuncy domain, complex
mag_SAMPLED_COS = abs(SAMPLED_COS);   % magnitude
pha_SAMPLED_COS = angle(SAMPLED_COS); % phase

figure(2)
plot(f_axis-fs/2, fftshift(mag_SAMPLED_COS),'linewidth',2);
set(gca,'fontsize',14);
%set(gca,'linewidth',2);
set(gca,'box','off');
xlabel('Frequency (Hz)');
title('心電圖頻譜 (frequency domain)')
%set(gca,'Xtick',[-200 -100 0 100 200 300 400 500]);   % set(gca,'Ytick', [ ]); set(gca,'XtickLabel',[...]);
print -djpeg fft_example.jpg % or print -dtiff fft_example.tif

toc
% close the serial port
fclose(s1);  















