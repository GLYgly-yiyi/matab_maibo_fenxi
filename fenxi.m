function  [RR QRS Rh PP]=fenxi(Xn1)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%N=length(Xn1);
%input=Xn1(1:9000,1);
input=Xn1;
sig=input;
lensig=length(sig);

%��λ��ֵ��
ytemp=cwt(input,6,'mexh');
lenytemp=length(ytemp)
ytemp(1:20)=0;
ytemp(lenytemp-20:lenytemp)=0;
y=ytemp;
%subplot(1,1,1),plot(y);
%itle('����С���任���ź�');grid on
%qujian=1:500
%f = linspace(0,1000/2,(1000)/2)%�Բ���Ƶ������ɢ���ļ��
%��ӡԭ�źż��任�ź�
figure;
subplot(2,1,1),plot(sig);
title('����ԭ�ź�');
subplot(2,1,2),plot(ytemp);
title('����С���任�ź�');

%С���任�󼫴󡢼�Сֵ
sigtemp=y;
siglen=length(y);
sigmax=[];                 %С���任�󼫴�ֵ
for i=1:siglen-2
    %     if   y(i+1)>y(i)&&y(i+1)>y(i+2)           %%y(i)Ϊ����ֵ��&&
    if  (y(i+1)>y(i)&&y(i+1)>y(i+2))||(y(i+1)<y(i)&&y(i+1)<y(i+2))
        sigmax=[sigmax;abs(sigtemp(i+1)),i+1] ;  %%��仰ʲô��˼��������
    end;
end;


%ȡ��ֵ,��ֵΪ��Է�ֵ�Ĳ��60%
%������ƽ��ֵ��8������ֵ���ƽ��ֵ
thrtemp=sort(sigmax);
thrlen=length(sigmax);
thr=0;
for i=(thrlen-7):thrlen
    thr=thr+thrtemp(i);
end;
thrmax=thr/8;

%������ƽ��ֵ��100����С��ֵ���ƽ��ֵ
zerotemp=sort(y);
zerovalue=0;
for i=1:8
    zerovalue=zerovalue+zerotemp(i);
end;
zerovalue=zerovalue/8;    %��С����ƽ��ֵ���������ȣ�100����С��ֵ���ƽ��ֵ
%thr=(thrmax-zerovalue)*0.3 ;%�����С���ȵĲ�ֵ��30%Ϊ�б�R������ֵ
thr=(thrmax-zerovalue)*0.05 ;%�����С���ȵĲ�ֵ��30%Ϊ�б�R������ֵ
%thr=9;
%��λR��
rvalue=[];
for i=1:thrlen
    if sigmax(i,1)>thr
        rvalue=[rvalue;sigmax(i,2),sigmax(i,1)];
        
    end;
end;
rvalue_1=rvalue(:,1);%ȡ ����ĵ�1��

% %�ų���죬���������������ֵ���С��0.4����ȥ�����Ƚ�С��һ��
lenvalue=length(rvalue_1);
i=2;
while i<=lenvalue
    %if (rvalue_1(i)-rvalue_1(i-1))<200
    if (rvalue_1(i)-rvalue_1(i-1))<11
        if y(abs(rvalue_1(i)))>y(abs(rvalue_1(i-1)))
            rvalue_1(i-1)=[];
        else
            rvalue_1(i)=[];
        end;
        lenvalue=length(rvalue_1);
        i=i-1;
    end;
    i=i+1;
end;
Rh=[];
for i=1:length(rvalue_1)
    Rh(i) = y(rvalue_1(i));
   % PP1(i)=min (y((rvalue_1(i)-100):(rvalue_1(i)+100)));
   PP1(i)=min (y((rvalue_1(i)-6):(rvalue_1(i)+6)));%Ҫ�Ĳ���
    PP(i)=Rh(i)-PP1(i);
end


%HRV˲ʱ����
RR=rvalue_1;
figure('NumberTitle','off','Name','�����㶨λ');
subplot(2,1,1),plot(1:lensig,sig,rvalue(:,1),sig(rvalue(:,1)),'ro');
title('У׼ǰ�����㶨λ');

%��ԭ�ź��Ͼ�ȷУ׼            %��̫����
for i=1:lenvalue
    if (ytemp(rvalue_1(i))>0)
        k=(rvalue_1(i)-5):(rvalue_1(i)+5);
        [a,b]=max(sig(k))
        rvalue_1(i)=rvalue_1(i)-6+b;
    else
        k=(rvalue_1(i)-5):(rvalue_1(i)+5);
        [a,b]=min(sig(k));
        rvalue_1(i)=rvalue_1(i)-6+b;
    end;
end;

% % % %��ӡ������У׼ǰ���R���ź�
% figure('NumberTitle','off','Name','�����㶨λ');
% subplot(2,1,1),plot(1:lensig,sig,rvalue(:,1),sig(rvalue(:,1)),'r.');
% title('������У׼ǰ�������ź�');
subplot(2,1,2),plot(1:lensig,sig,rvalue_1,sig(rvalue_1),'ro');
title('У׼�������㶨λ');

hold on;

%���Q��
wtsig2=cwt(sig,8,'mexh');
% figure;
% plot(wtsig2);
lenrvalue=length(rvalue_1);
%lenrvalue=5;
qvalue=[];
for i=1:lenrvalue
    %for j=rvalue_1(i):-1:(rvalue_1(i)-30)
   for j=rvalue_1(i)-15:1:(rvalue_1(i)+15)
        if wtsig2(rvalue_1(i))>0
            if wtsig2(j)<wtsig2(j-1)&&wtsig2(j)<wtsig2(j+1)
                %tempqvalue=j-200;                 %ȷ����ⴰ�����
                tempqvalue=j-20;                 %ȷ����ⴰ�����
                break;                        %���򲨣�ȡ��һ��������ֵ
            end;
            
        else
            if wtsig2(j)>wtsig2(j-1)&&wtsig2(j)>wtsig2(j+1)
                %tempqvalue=j-200;                 %ȷ����ⴰ�����
                tempqvalue=j-30;                 %ȷ����ⴰ�����
                break;                      %����R����ȡ��һ��������ֵ
            end;
        end;
    end;
    x1=tempqvalue;
    y1=sig(tempqvalue);
    x2=rvalue_1(i);
    y2=sig(rvalue_1(i));
    a0=(y2-y1)/(x2-x1);
    b0=-1;
    c0=-a0*x1+y1;                        %��ֱ�߹�ʽ����ax+by+c=0
    dist=[];
    for k=tempqvalue:rvalue_1(i)
        tempdist=(abs(a0*k+b0*sig(k)+c0))/sqrt(a0^2+b0^2);
        dist=[dist;tempdist];
    end;                                  %��㵽ֱ�߾���
    [a,b]=max(dist);                      %�ҵ��������ֵ��Q�����ڸ���
    tempqvalue=tempqvalue+b-1;
    qvalue=[qvalue;tempqvalue];
end;

%���S��
svalue=[];
for i=1:lenrvalue
  % for j=rvalue_1(i):1:(rvalue_1(i)+100)
        for j=rvalue_1(i)-15:1:(rvalue_1(i)+15)
        if ytemp(rvalue_1(i))>0
            if (wtsig2(j)<wtsig2(j-1))&&(wtsig2(j)<wtsig2(j+1))
                %tempsvalue=j+200;      %��С���任���R����ʼ���Ѱ�ҵ�һ����Сֵ
                 tempsvalue=j+20;      %��С���任���R����ʼ���Ѱ�ҵ�һ����Сֵ
                break;
            end;
            
        else
            if (wtsig2(j)>wtsig2(j-1))&&(wtsig2(j)>wtsig2(j+1))
                %tempsvalue=j+200;     %��С���任���R����ʼ���Ѱ�ҵ�һ������ֵ
                 tempsvalue=j+20;      %��С���任���R����ʼ���Ѱ�ҵ�һ����Сֵ
                break;
            end;
        end;
    end;
    x1=tempsvalue;
    y1=sig(tempsvalue);
    x2=rvalue_1(i);
    y2=sig(rvalue_1(i));
    a0=(y2-y1)/(x2-x1);
    b0=-1;
    c0=-a0*x1+y1;                        %��ֱ�߹�ʽ����ax+by+c=0
    dist=[];
    for k=rvalue_1(i):tempsvalue
        tempdist=(abs(a0*k+b0*sig(k)+c0))/sqrt(a0^2+b0^2);
        dist=[dist;tempdist];
    end;                                  %��㵽ֱ�߾���
    [a,b]=max(dist);                   %�ҵ��������ֵ��S�����ڸ���
    tempsvalue=rvalue_1(i)+b-1;
    svalue=[svalue;tempsvalue];
end;
mink=min(length(qvalue),length(svalue));
for i=1:mink
    QRS(i)=svalue(i)-qvalue(i);
end
%���QRS���
start=[];
for i=1:lenrvalue
   % for j=qvalue(i):-1:(qvalue(i)-200)
   for j=qvalue(i):-1:(qvalue(i)-11)
        if wtsig2(j)>0
            start=[start;j];
            break;
        end;
    end;
end;

%��ӡQ,S���ź�
qrvalue=sort(qvalue);
srvalue=sort(svalue);
sstart=sort(start);
figure;
plot(1:lensig,sig,qrvalue,sig(qrvalue),'rd');
plot(1:lensig,sig,srvalue,sig(srvalue),'ro');
plot(1:lensig,sig,sstart,sig(sstart),'rx');
%title('��λ');
end

