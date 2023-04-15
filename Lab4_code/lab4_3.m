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
fs=200;   %sample rate 500 200 100 80
time=[0:1/fs:2-1/fs]; 
figure
h_plot=plot(nan,nan);
hold on
peak_plot=plot(nan,nan,'ro');
title("Real time filtered ECG Signal");
xlabel('Time (sec)');
ylabel('Quantized value');
hold off 

lpFilt = designfilt('lowpassiir','FilterOrder',8,'PassbandFrequency',4,'SampleRate',fs); % flattening  % you may tune here
hpFilt = designfilt('highpassiir','FilterOrder',8,'PassbandFrequency',4,'SampleRate',fs); % remove baseline wander noise  % you may tune here
output=[];
dt = 1 / fs;
t_axis = (0 : dt : 1/fs*(length(disbuff) - 1));
tic
%profile on
for i=1:100*N_point
    data=fscanf(s1);    %read sensor
    y(i) = str2double(data);
    
    if i<=1000
        disbuff(i)=y(i);
    else
        disbuff=[disbuff(2:end) y(i)];
    end
    disbuff(isnan(disbuff))=0;
    

    
    if i>1 && mod(i,10)==0
        R_peak=[];
        R_peak_index=[];
        [pks_th,locs_th,~,~] = findpeaks(disbuff);
        for m=1:length(pks_th)
            if pks_th(m)>400
                R_peak=[R_peak pks_th(m)];
                R_peak_index=[R_peak_index locs_th(m)*dt];
            end
        end
        set(h_plot, 'Xdata',t_axis,'Ydata',disbuff)
        set(peak_plot, 'Xdata',R_peak_index,'Ydata',R_peak)
        if length(R_peak_index)>=2
            heart_rate = 60/(R_peak_index(2)-R_peak_index(1));
            title(['Heart Rate : ',num2str(heart_rate),' per min']);
        end
        drawnow;
    end
end
%profile viewer

