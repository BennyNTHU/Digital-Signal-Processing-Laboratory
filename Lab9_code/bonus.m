clear;close;clc;

a=[1];
i=1;

for alpha=[0.95 0.99 0.65]
    
    b=[1 -alpha];
    [h,w] = freqz(b,a,'whole',2001);
    
    figure(i)
    plot(w/pi,abs(h))
    ax = gca;
    ax.XTick = 0:.5:2;
    xlabel('Normalized Frequency (\times\pi rad/sample)')
    ylabel('Magnitude')
    title(['\alpha = ' num2str(alpha)])
    
    i=i+1;
end