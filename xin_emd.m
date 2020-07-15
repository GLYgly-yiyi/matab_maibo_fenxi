[filename, pathname] = uigetfile({'*.xlsx'; '*.xls'; '*.txt'}, '读入测试数据文件');
[num, txt, raw] = xlsread([pathname, filename]);
y=num(:,1:end);
% load('sinusoidalSignalExampleData.mat','X','fs')  %载入数据
fs=100;
t = (0:length(y)-1)/fs;
%plot(t,y)                       %绘制原始信号图
%xlabel('Time(s)') 
[imf,residual,info]=emd(y,'Interpolation','pchip')  %emd分解
%emd(y,'Interpolation','pchip')
%%
s1=imf(:,1);
s2=imf(:,2);
s3=imf(:,3);
s4=imf(:,4);
s5=imf(:,5);
s6=imf(:,6);
s7=imf(:,7);

%[x,w]=dtft(s5,fs);
%plot(w/pi,real(x));grid 

f = linspace(0,fs/2,(500)/2);%以采样频率做离散化的间隔
% %%
% Y0 = fft(y,500);%
% Y0 = Y0(1:(500)/2);%只取Y的前半部分
% subplot(521),plot(y);
% xlabel('t'),ylabel('幅度'); 
% title('原始信号')  
% subplot(522),plot(f,2*sqrt(Y0.*conj(Y0)));%画幅值谱 
% xlabel('f'),ylabel('real'); 
% title('幅值谱') 
%%
Y1 = fft(s1,500);%
Y1 = Y1(1:(500)/2);%只取Y的前半部分
subplot(521),plot(s1);
xlabel('时间'),ylabel('幅度'); 
title('IMF1')  
subplot(522),plot(f,2*sqrt(Y1.*conj(Y1)));%画幅值谱 
xlabel('频率'),ylabel('幅度'); 
title('幅值谱')  
%%
Y2 = fft(s2,500);%
Y2 = Y2(1:(500)/2);%只取Y的前半部分
subplot(523),plot(s2);
xlabel('时间'),ylabel('幅度'); 
title('IMF2')  
subplot(524),plot(f,2*sqrt(Y2.*conj(Y2)));%画幅值谱 
xlabel('频率f'),ylabel('幅度'); 
title('幅值谱') 
%%
Y3 = fft(s3,500);%
Y3 = Y3(1:(500)/2);%只取Y的前半部分
subplot(525),plot(s3);
xlabel('时间'),ylabel('幅度'); 
title('IMF3')  
subplot(526),plot(f,2*sqrt(Y3.*conj(Y3)));%画幅值谱 
xlabel('频率'),ylabel('幅度'); 
title('幅值谱') 
%%
Y4 = fft(s4,500);%
Y4 = Y4(1:(500)/2);%只取Y的前半部分
subplot(527),plot(s4);
xlabel('时间t'),ylabel('幅度'); 
title('IMF4')  
subplot(5,2,8),plot(f,2*sqrt(Y4.*conj(Y4)));%画幅值谱 
xlabel('频率'),ylabel('幅度'); 
title('幅值谱') 
%%
Y5 = fft(s5,500);%
Y5 = Y5(1:(500)/2);%只取Y的前半部分
subplot(529),plot(s5);
xlabel('时间'),ylabel('幅度'); 
title('IMF5')  
subplot(5,2,10),plot(f,2*sqrt(Y5.*conj(Y5)));%画幅值谱 
xlabel('频率'),ylabel('幅值'); 
title('幅值谱') 
%%
%%残余边带分量
% Yy = fft(residual,500);%
% Yy = Yy(1:(500)/2);%只取Y的前半部分
% subplot(521),plot(residual);
% xlabel('t'),ylabel('幅度'); 
% title('IMF1')  
% subplot(522),plot(f,2*sqrt(Yy.*conj(Yy)));%画幅值谱 
% xlabel('f'),ylabel('real'); 
% title('幅值谱') 
%%
%希尔伯特变换
figure;
subplot(321);
hht(s1,fs);
xlabel('时间'),ylabel('频率'); 
title('IMF1') 
subplot(322);
hht(s2,fs);
axis([0,4,0,10])
xlabel('时间'),ylabel('频率'); 
title('IMF2')
subplot(323);
hht(s3,fs);
axis([0,4,0,10])
xlabel('时间'),ylabel('频率'); 
title('IMF3')
subplot(324);
hht(s4,fs);
axis([0,4,0,10])
xlabel('时间'),ylabel('频率'); 
title('IMF4')
subplot(325);
hht(s5,fs);
axis([0,4,0,10])
xlabel('时间'),ylabel('频率'); 
title('IMF5')
subplot(326);
hht(imf,fs);
axis([0,4,0,10])
xlabel('时间'),ylabel('频率'); 
title('原始信号')


 


