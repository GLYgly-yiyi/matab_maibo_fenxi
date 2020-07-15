function  [RR QRS Rh PP]=fenxi(Xn1)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%N=length(Xn1);
%input=Xn1(1:9000,1);
input=Xn1;
sig=input;
lensig=length(sig);

%定位极值点
ytemp=cwt(input,6,'mexh');
lenytemp=length(ytemp)
ytemp(1:20)=0;
ytemp(lenytemp-20:lenytemp)=0;
y=ytemp;
%subplot(1,1,1),plot(y);
%itle('连续小波变换后信号');grid on
%qujian=1:500
%f = linspace(0,1000/2,(1000)/2)%以采样频率做离散化的间隔
%打印原信号及变换信号
figure;
subplot(2,1,1),plot(sig);
title('脉搏原信号');
subplot(2,1,2),plot(ytemp);
title('脉搏小波变换信号');

%小波变换后极大、极小值
sigtemp=y;
siglen=length(y);
sigmax=[];                 %小波变换后极大值
for i=1:siglen-2
    %     if   y(i+1)>y(i)&&y(i+1)>y(i+2)           %%y(i)为极大值，&&
    if  (y(i+1)>y(i)&&y(i+1)>y(i+2))||(y(i+1)<y(i)&&y(i+1)<y(i+2))
        sigmax=[sigmax;abs(sigtemp(i+1)),i+1] ;  %%这句话什么意思，有问题
    end;
end;


%取阈值,阈值为相对幅值的差的60%
%最大幅度平均值，8个最大幅值点的平均值
thrtemp=sort(sigmax);
thrlen=length(sigmax);
thr=0;
for i=(thrlen-7):thrlen
    thr=thr+thrtemp(i);
end;
thrmax=thr/8;

%最大幅度平均值，100个最小幅值点的平均值
zerotemp=sort(y);
zerovalue=0;
for i=1:8
    zerovalue=zerovalue+zerotemp(i);
end;
zerovalue=zerovalue/8;    %最小幅度平均值，对消幅度，100个最小幅值点的平均值
%thr=(thrmax-zerovalue)*0.3 ;%最大、最小幅度的差值的30%为判别R波的阈值
thr=(thrmax-zerovalue)*0.05 ;%最大、最小幅度的差值的30%为判别R波的阈值
%thr=9;
%定位R波
rvalue=[];
for i=1:thrlen
    if sigmax(i,1)>thr
        rvalue=[rvalue;sigmax(i,2),sigmax(i,1)];
        
    end;
end;
rvalue_1=rvalue(:,1);%取 矩阵的第1列

% %排除误检，如果相邻两个极大值间距小于0.4，则去掉幅度较小的一个
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
   PP1(i)=min (y((rvalue_1(i)-6):(rvalue_1(i)+6)));%要改参数
    PP(i)=Rh(i)-PP1(i);
end


%HRV瞬时心率
RR=rvalue_1;
figure('NumberTitle','off','Name','特征点定位');
subplot(2,1,1),plot(1:lensig,sig,rvalue(:,1),sig(rvalue(:,1)),'ro');
title('校准前特征点定位');

%在原信号上精确校准            %不太明白
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

% % % %打印纠正及校准前后的R波信号
% figure('NumberTitle','off','Name','特征点定位');
% subplot(2,1,1),plot(1:lensig,sig,rvalue(:,1),sig(rvalue(:,1)),'r.');
% title('纠正及校准前的脉搏信号');
subplot(2,1,2),plot(1:lensig,sig,rvalue_1,sig(rvalue_1),'ro');
title('校准后特征点定位');

hold on;

%检测Q波
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
                %tempqvalue=j-200;                 %确定检测窗的起点
                tempqvalue=j-20;                 %确定检测窗的起点
                break;                        %正向波，取第一个负极大值
            end;
            
        else
            if wtsig2(j)>wtsig2(j-1)&&wtsig2(j)>wtsig2(j+1)
                %tempqvalue=j-200;                 %确定检测窗的起点
                tempqvalue=j-30;                 %确定检测窗的起点
                break;                      %倒置R波，取第一个正极大值
            end;
        end;
    end;
    x1=tempqvalue;
    y1=sig(tempqvalue);
    x2=rvalue_1(i);
    y2=sig(rvalue_1(i));
    a0=(y2-y1)/(x2-x1);
    b0=-1;
    c0=-a0*x1+y1;                        %求直线公式参数ax+by+c=0
    dist=[];
    for k=tempqvalue:rvalue_1(i)
        tempdist=(abs(a0*k+b0*sig(k)+c0))/sqrt(a0^2+b0^2);
        dist=[dist;tempdist];
    end;                                  %求点到直线距离
    [a,b]=max(dist);                      %找到距离最大值，Q波就在附近
    tempqvalue=tempqvalue+b-1;
    qvalue=[qvalue;tempqvalue];
end;

%检测S波
svalue=[];
for i=1:lenrvalue
  % for j=rvalue_1(i):1:(rvalue_1(i)+100)
        for j=rvalue_1(i)-15:1:(rvalue_1(i)+15)
        if ytemp(rvalue_1(i))>0
            if (wtsig2(j)<wtsig2(j-1))&&(wtsig2(j)<wtsig2(j+1))
                %tempsvalue=j+200;      %在小波变换域从R波开始向后寻找第一个极小值
                 tempsvalue=j+20;      %在小波变换域从R波开始向后寻找第一个极小值
                break;
            end;
            
        else
            if (wtsig2(j)>wtsig2(j-1))&&(wtsig2(j)>wtsig2(j+1))
                %tempsvalue=j+200;     %在小波变换域从R波开始向后寻找第一个极大值
                 tempsvalue=j+20;      %在小波变换域从R波开始向后寻找第一个极小值
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
    c0=-a0*x1+y1;                        %求直线公式参数ax+by+c=0
    dist=[];
    for k=rvalue_1(i):tempsvalue
        tempdist=(abs(a0*k+b0*sig(k)+c0))/sqrt(a0^2+b0^2);
        dist=[dist;tempdist];
    end;                                  %求点到直线距离
    [a,b]=max(dist);                   %找到距离最大值，S波就在附近
    tempsvalue=rvalue_1(i)+b-1;
    svalue=[svalue;tempsvalue];
end;
mink=min(length(qvalue),length(svalue));
for i=1:mink
    QRS(i)=svalue(i)-qvalue(i);
end
%检测QRS起点
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

%打印Q,S波信号
qrvalue=sort(qvalue);
srvalue=sort(svalue);
sstart=sort(start);
figure;
plot(1:lensig,sig,qrvalue,sig(qrvalue),'rd');
plot(1:lensig,sig,srvalue,sig(srvalue),'ro');
plot(1:lensig,sig,sstart,sig(sstart),'rx');
%title('定位');
end

