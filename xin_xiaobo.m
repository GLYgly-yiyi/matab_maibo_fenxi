t_s = 0.005; %��������
t_start = 0.001; %��ʼʱ��
t_end = 10;     %����ʱ��
t = t_start : t_s : t_end;
% y = 10*sin(2*pi*0.5*t)+3*sin(2*pi*10*t)+1*sin(2*pi*20*t)+3*randn(1,length(t));  %�����ź�
[filename, pathname] = uigetfile({'*.xlsx'; '*.xls'; '*.txt'}, '������������ļ�');
[num, txt, raw] = xlsread([pathname, filename]);
y=num(:,1:end);
len = length(y);
%����ͻ���ź�
% y2 = 50*sin(2*pi*50*t);
% for i = 1: len
%     if i>=601&&i<=604
%         y(i) = y(i)+y2(i);
%     else
%         y(i) = y(i);
%     end
% end
figure
plot(y) %����ԭʼ�ź�
xlabel('���ݵ�') ;ylabel('����');title('ԭʼ�ź�');
[c,l] = wavedec(y,5,'db5');%��߶�һάС���ּ�
%�ع�1~5��ϸ�ں���
d5 = wrcoef('d',c,l,'db5',5);
d4 = wrcoef('d',c,l,'db5',4);
d3 = wrcoef('d',c,l,'db5',3);
d2 = wrcoef('d',c,l,'db5',2);
d1 = wrcoef('d',c,l,'db5',1);
%�ع�1~5����ƺ���
a5 = wrcoef('a',c,l,'db5',5);
a4 = wrcoef('a',c,l,'db5',4);
a3 = wrcoef('a',c,l,'db5',3);
a2 = wrcoef('a',c,l,'db5',2);
a1 = wrcoef('a',c,l,'db5',1);
figure
subplot(5,2,1);
plot(a1)
xlabel('ʱ��') ;ylabel('����');title('һ�׽����ź�');
subplot(5,2,2);
plot(d1)
xlabel('ʱ��') ;ylabel('����');title('һ��ϸ���ź�');
subplot(5,2,3);
plot(a2)
xlabel('ʱ��') ;ylabel('����');title('���׽����ź�');
subplot(5,2,4);
plot(d2)
xlabel('ʱ��') ;ylabel('����');title('����ϸ���ź�');
subplot(5,2,5);
plot(a3)
xlabel('ʱ��') ;ylabel('����');title('���׽����ź�');
subplot(5,2,6);
plot(d3)
xlabel('ʱ��') ;ylabel('����');title('����ϸ���ź�');

subplot(5,2,7);
plot(a4)
xlabel('ʱ��') ;ylabel('����');title('�Ľ׽����ź�');
subplot(5,2,8);
plot(d4)
xlabel('ʱ��') ;ylabel('����');title('�Ľ�ϸ���ź�');

subplot(5,2,9);
plot(a5)
xlabel('ʱ��') ;ylabel('����');title('��׽����ź�');
subplot(5,2,10);
plot(d5)
xlabel('ʱ��') ;ylabel('����');title('���ϸ���ź�');
