%调度

%一些准备工作

%已有的电源加上新建的电源作为2020年参与调度的电源
%现在的电源数量        水7 火10 风2 核0
%新增的电源数量 最大   水4 火10 风2 核1  根据Plan给出的BuildChoice
NewPower=BuildChoice.*AvailablePower;
%2020实际的电源 最大    水11 火20 风4 核01
Power2020=[PresentPower(1:7);
    NewPower(1:4);
    PresentPower(8:17);
    NewPower(5:14);
    PresentPower(18:19);
    NewPower(15:16);
    PresentPower(20);
    NewPower(17)];
%将电源按水电、火电、风电、核电排序

% i：小时   j:机组
%根据机组特性最大最小出力
for i=1:24
    for j=1:11%水电冬季0.6；夏季1.0
        stMaxPower1(i,j)=Power2020(j)*0.6;
        stMinPower1(i,j)=0;
        stMaxPower2(i,j)=Power2020(j)*1.0;
        stMinPower2(i,j)=0;
    end
    for j=12:31%火电0.5-1.0
        stMaxPower1(i,j)=Power2020(j);
        stMinPower1(i,j)=Power2020(j)*0.5;
        stMaxPower2(i,j)=Power2020(j);
        stMinPower2(i,j)=Power2020(j)*0.5;
    end
    for j=32:35%风电根据典型出力曲线
        stMaxPower1(i,j)=Power2020(j)*stTypicalWindPowerpu(i,1);%冬季
        stMinPower1(i,j)=0;
        stMaxPower2(i,j)=Power2020(j)*stTypicalWindPowerpu(i,2);%夏季
        stMinPower2(i,j)=0;
    end
    for j=36:37%核电0.9-1.0
        stMaxPower1(i,j)=Power2020(j);
        stMinPower1(i,j)=Power2020(j)*0.9;
        stMaxPower2(i,j)=Power2020(j);
        stMinPower2(i,j)=Power2020(j)*0.9;
    end
end


%优化数学建模

%设置变量
I1=binvar(24,37,'full');%0-1启动（冬季）
P1=sdpvar(24,37,'full');%机组出力功率(冬季）
Uup1=binvar(24,37,'full');%启停指示变量
Udown1=binvar(24,37,'full');%启停指示变量

I2=binvar(24,37,'full');%0-1启动（夏季）
P2=sdpvar(24,37,'full');%机组出力功率(夏季）
Uup2=binvar(24,37,'full');%启停指示变量
Udown2=binvar(24,37,'full');%启停指示变量

%设置目标函数

%机组出力顺序(优先风电，其次水电，其次核电，最后火电）
weight=[1*ones(11,1);3*ones(20,1);0*ones(4,1);2*ones(2,1)];
%一年的调度目标（冬季185天，夏季180天）低碳调度
 P=185*sum(P1*weight)+180*sum(P2*weight);
 
 %考虑火电成本曲线
% P=0;
% for i=1:24
% for j=12:31
%     if Power2020(j)==0
%         Power2020(j)=100;end
%     P=P+180*(P1(i,j)/Power2020(j)+P2(i,j)/Power2020(j));
% end
% end
%考虑启停成本 
%P=185*sum(P1*weight)+180*sum(P2*weight)+180*（Uup1+Uup2+Udown1+Udown2);


%设置约束条件    

C=[];
%负荷平衡约束(24小时）
for i=1:24
    C=[C,sum(P1(i,:))==stTypicalLoad(i,1)];%冬季
    C=[C,sum(P2(i,:))==stTypicalLoad(i,2)];%夏季
end

%系统备用约束
%实时最大最小功率范围
instMaxPower1=I1.*stMaxPower1;
instMinPower1=I1.*stMinPower1;
instMaxPower2=I2.*stMaxPower2;
instMinPower2=I2.*stMinPower2;
for i=24  %不考虑风电
    C=[C,sum(instMaxPower1(i,1:31))+sum(instMaxPower1(i,36:37))>=stTypicalLoad(i,1)*(1+0.1)];
    C=[C,sum(instMinPower1(i,1:31))+sum(instMinPower1(i,36:37))<=stTypicalLoad(i,1)*(1-0.1)];
    C=[C,sum(instMaxPower2(i,1:31))+sum(instMaxPower2(i,36:37))>=stTypicalLoad(i,2)*(1+0.1)];
    C=[C,sum(instMinPower2(i,1:31))+sum(instMinPower2(i,36:37))<=stTypicalLoad(i,2)*(1-0.1)];
end

%年发电最大小时数约束(最多37个机组）
%年发电量
shijiAnnualPower=ones(1,24)*(185*P1+180*P2);%冬季185天，夏季180天
%年最大发电小时
stMaxHours2020=[3000*ones(11,1);6000*ones(20,1);2000*ones(4,1);8000*ones(2,1)];
%年最大发电量
stMaxAnnualPower2020=Power2020.*stMaxHours2020;
for j=1:37
    C=[C,shijiAnnualPower(j)<=stMaxAnnualPower2020(j)];
end

%机组出力约束
for i=1:24%每个小时
    for j=1:35%水电和火电、风电（水电和风电的开关变量实际上不起作用）
        C=[C,I1(i,j)*stMinPower1(i,j)<=P1(i,j)<=I1(i,j)*stMaxPower1(i,j)];%冬季
        C=[C,I2(i,j)*stMinPower2(i,j)<=P2(i,j)<=I2(i,j)*stMaxPower2(i,j)];%夏季
    end
    for j=36:37%核电（0.9~1.0）（核电不能关）
        C=[C,stMinPower1(i,j)<=P1(i,j)<=stMaxPower1(i,j)];
        C=[C,stMinPower2(i,j)<=P2(i,j)<=stMaxPower2(i,j)];
    end
end

%火电机组爬坡约束
%将一天的0-6时作为第二天23时以后的出力，方便考虑爬坡和启停
I1=[I1;I1(1:6,:)];
P1=[P1;P1(1:6,:)];
Uup1=[Uup1;Uup1(1:6,:)];
Udown1=[Udown1;Udown1(1:6,:)];

I2=[I2;I2(1:6,:)];
P2=[P2;P2(1:6,:)];
Uup2=[Uup2;Uup2(1:6,:)];
Udown2=[Udown2;Udown2(1:6,:)];

%火电爬坡
for i=2:25%时间序号
    for j=12:31%火电机组序号
        C=[C, P1(i,j)-P1(i-1,j)+I1(i-1,j)*(stMinPower1(1,j)-0.2*stMaxPower1(1,j))+I1(i,j)*(stMaxPower1(1,j)-stMinPower1(1,j))<=stMaxPower1(1,j)];
        C=[C,-P1(i,j)+P1(i-1,j)+I1(i,j)*(stMinPower1(1,j)-0.2*stMaxPower1(1,j))+I1(i-1,j)*(stMaxPower1(1,j)-stMinPower1(1,j))<=stMaxPower1(1,j)];
        C=[C, P2(i,j)-P2(i-1,j)+I2(i-1,j)*(stMinPower2(1,j)-0.2*stMaxPower2(1,j))+I2(i,j)*(stMaxPower2(1,j)-stMinPower2(1,j))<=stMaxPower2(1,j)];
        C=[C,-P2(i,j)+P2(i-1,j)+I2(i,j)*(stMinPower2(1,j)-0.2*stMaxPower2(1,j))+I2(i-1,j)*(stMaxPower2(1,j)-stMinPower2(1,j))<=stMaxPower2(1,j)];
    end
end

%机组启停约束
%机组启停状态变量与机组启停指示变量关联约束
for i=2:25  
    for j=12:31
        C=[C,Uup1(i,j)>=I1(i,j)-I1(i-1,j)];
        C=[C,Udown1(i,j)>=I1(i-1,j)-I1(i,j)];
        C=[C,Uup2(i,j)>=I2(i,j)-I2(i-1,j)];
        C=[C,Udown2(i,j)>=I2(i-1,j)-I2(i,j)];
    end
end
%机组最小启停时间设置
%(假设所有机组启停最小时间按功率（万千瓦）100以上6小时，100以下3小时，200以上12小时）
for j=12:31
    TimeOnMin(j)=3;
    TimeOffMin(j)=3;
    if Power2020(j)>100
        TimeOnMin(j)=6;
        TimeOffMin(j)=6;
    end
     if Power2020(j)>200
        TimeOnMin(j)=12;
        TimeOffMin(j)=12;
    end
end
%机组最小启停时间约束
for i=7:30
    for j=12:31
        C=[C,(I1(i,j)-I1(i-1,j))*TimeOnMin(j)+sum(I1(i-TimeOnMin(j):i-1,j))>=0];
        C=[C,(I1(i-1,j)-I1(i,j))*TimeOffMin(j)+TimeOffMin(j)-sum(I1(i-TimeOffMin(j):i-1,j))>=0];
        C=[C,(I2(i,j)-I2(i-1,j))*TimeOnMin(j)+sum(I2(i-TimeOnMin(j):i-1,j))>=0];
        C=[C,(I2(i-1,j)-I2(i,j))*TimeOffMin(j)+TimeOffMin(j)-sum(I2(i-TimeOffMin(j):i-1,j))>=0];
    end
end
%机组最大启停次数约束（假设所有机组最多启/停3次）
UupMax=3;UdownMax=3;
for j=12:31
    C=[C,sum(Uup1(1:24,j))<=UupMax];
    C=[C,sum(Udown1(1:24,j))<=UdownMax];
    C=[C,sum(Uup2(1:24,j))<=UupMax];
    C=[C,sum(Udown2(1:24,j))<=UdownMax];
end

%优化设置
options=sdpsettings('solver','cplex','verbose',2);
%解优化
sol=optimize(C,P,options);

%取结果
I1=value(I1(1:24,:));
shijiPower1=value(P1(1:24,:));
I2=value(I2(1:24,:));
shijiPower2=value(P2(1:24,:));
