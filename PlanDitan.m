%现在的电源数量  水7 火10 风2 核0
%可选的电源数量  水4 火10 风2 核1

%设置0-1变量
B=binvar(17,1,'full');

%设置目标函数
%建造优先：风电、水电、核电、火电
weight=[1*ones(4,1);3*ones(10,1);0*ones(2,1);2*ones(1,1)];
P=(B.*AvailablePower)'*weight;

%设置约束条件

%正备用（考虑最大负荷出现在冬季，风电完全没有）
% MaxPower=sum(PresentPower(1:17))+B'*AvailablePower;（夏季，风电满，不合理）
MaxPower=0.6*sum(PresentPower(1:7))+sum(PresentPower(8:17))+0.6*B(1:4)'*AvailablePower(1:4)+B(5:14)'*AvailablePower(5:14)+B(17)*AvailablePower(17);
C=[MaxPower>=PredictionMaxPower*(1+0.1)];
%负备用（由于目前没有关于最小负荷的预测，因此不考虑负备用）

%年最大发电量、最大发电小时
stPresentMaxHours=[3000*ones(7,1);6000*ones(10,1);2000*ones(2,1);8000*ones(1,1)];
stBuildMaxHours=[3000*ones(4,1);6000*ones(10,1);2000*ones(2,1);8000*ones(1,1)];
MaxAnnual=PresentPower'*stPresentMaxHours+(B.*AvailablePower)'*stBuildMaxHours;
C=[C,MaxAnnual>=PredictionAnnual*(1+0.1)];

%优化设置
options=sdpsettings('solver','cplex','verbose',2);
%解优化
sol=optimize(C,P,options);

%结果
BuildChoice=value(B);
B=value(B);
MaxAnnual=PresentPower'*stPresentMaxHours+(B.*AvailablePower)'*stBuildMaxHours;
% MaxPower=sum(PresentPower)+B'*AvailablePower;
MaxPower=0.6*sum(PresentPower(1:7))+sum(PresentPower(8:17))+0.6*B(1:4)'*AvailablePower(1:4)+B(5:14)'*AvailablePower(5:14)+B(17)*AvailablePower(17);