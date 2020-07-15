[filename, pathname] = uigetfile({'*.xlsx'; '*.xls'; '*.txt'}, '读入测试数据文件');
%str=[pathname filename];
[num, txt, raw] = xlsread([pathname, filename]);
y=num(:,1:end);

%[t,Xn]=duquxinhao(str)
[RR QRS Rh PP]=fenxi(y);
%tongji( RR,QRS,Rh,PP);
%plot(y);
ma = max(y); 			%最大值
mi = min(y); 			%最小值	
me = mean(y); 			%平均值
pk = ma-mi;			    %峰-峰值
av = mean(abs(y));		%绝对值的平均值(整流平均值)
va = var(y);			%方差
st = std(y);			%标准差
ku = kurtosis(y);		%峭度
sk = skewness(y);       %偏度
rm = rms(y);			%均方根
S = rm/av;			%波形因子
C = pk/rm;			%峰值因子
I = pk/av;			%脉冲因子
xr = mean(sqrt(abs(y)))^2;
L = pk/xr;			%裕度因子