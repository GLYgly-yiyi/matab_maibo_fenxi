[filename, pathname] = uigetfile({'*.xlsx'; '*.xls'; '*.txt'}, '������������ļ�');
%str=[pathname filename];
[num, txt, raw] = xlsread([pathname, filename]);
y=num(:,1:end);

%[t,Xn]=duquxinhao(str)
[RR QRS Rh PP]=fenxi(y);
%tongji( RR,QRS,Rh,PP);
%plot(y);
ma = max(y); 			%���ֵ
mi = min(y); 			%��Сֵ	
me = mean(y); 			%ƽ��ֵ
pk = ma-mi;			    %��-��ֵ
av = mean(abs(y));		%����ֵ��ƽ��ֵ(����ƽ��ֵ)
va = var(y);			%����
st = std(y);			%��׼��
ku = kurtosis(y);		%�Ͷ�
sk = skewness(y);       %ƫ��
rm = rms(y);			%������
S = rm/av;			%��������
C = pk/rm;			%��ֵ����
I = pk/av;			%��������
xr = mean(sqrt(abs(y)))^2;
L = pk/xr;			%ԣ������