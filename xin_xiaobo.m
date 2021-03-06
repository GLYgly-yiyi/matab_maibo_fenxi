t_s = 0.005; %采样周期
t_start = 0.001; %起始时间
t_end = 10;     %结束时间
t = t_start : t_s : t_end;
% y = 10*sin(2*pi*0.5*t)+3*sin(2*pi*10*t)+1*sin(2*pi*20*t)+3*randn(1,length(t));  %生成信号
[filename, pathname] = uigetfile({'*.xlsx'; '*.xls'; '*.txt'}, '读入测试数据文件');
[num, txt, raw] = xlsread([pathname, filename]);
y=num(:,1:end);
len = length(y);
%生成突变信号
% y2 = 50*sin(2*pi*50*t);
% for i = 1: len
%     if i>=601&&i<=604
%         y(i) = y(i)+y2(i);
%     else
%         y(i) = y(i);
%     end
% end
figure
plot(y) %绘制原始信号
xlabel('数据点') ;ylabel('幅度');title('原始信号');
[c,l] = wavedec(y,5,'db5');%多尺度一维小波分级
%重构1~5层细节函数
d5 = wrcoef('d',c,l,'db5',5);
d4 = wrcoef('d',c,l,'db5',4);
d3 = wrcoef('d',c,l,'db5',3);
d2 = wrcoef('d',c,l,'db5',2);
d1 = wrcoef('d',c,l,'db5',1);
%重构1~5层近似函数
a5 = wrcoef('a',c,l,'db5',5);
a4 = wrcoef('a',c,l,'db5',4);
a3 = wrcoef('a',c,l,'db5',3);
a2 = wrcoef('a',c,l,'db5',2);
a1 = wrcoef('a',c,l,'db5',1);
figure
subplot(5,2,1);
plot(a1)
xlabel('时间') ;ylabel('幅度');title('一阶近似信号');
subplot(5,2,2);
plot(d1)
xlabel('时间') ;ylabel('幅度');title('一阶细节信号');
subplot(5,2,3);
plot(a2)
xlabel('时间') ;ylabel('幅度');title('二阶近似信号');
subplot(5,2,4);
plot(d2)
xlabel('时间') ;ylabel('幅度');title('二阶细节信号');
subplot(5,2,5);
plot(a3)
xlabel('时间') ;ylabel('幅度');title('三阶近似信号');
subplot(5,2,6);
plot(d3)
xlabel('时间') ;ylabel('幅度');title('三阶细节信号');

subplot(5,2,7);
plot(a4)
xlabel('时间') ;ylabel('幅度');title('四阶近似信号');
subplot(5,2,8);
plot(d4)
xlabel('时间') ;ylabel('幅度');title('四阶细节信号');

subplot(5,2,9);
plot(a5)
xlabel('时间') ;ylabel('幅度');title('五阶近似信号');
subplot(5,2,10);
plot(d5)
xlabel('时间') ;ylabel('幅度');title('五阶细节信号');
