%���ڵĵ�Դ����  ˮ7 ��10 ��2 ��0
%��ѡ�ĵ�Դ����  ˮ4 ��10 ��2 ��1

%����0-1����
B=binvar(17,1,'full');

%����Ŀ�꺯��
%�������ȣ���硢ˮ�硢�˵硢���
weight=[1*ones(4,1);3*ones(10,1);0*ones(2,1);2*ones(1,1)];
P=(B.*AvailablePower)'*weight;

%����Լ������

%�����ã�������󸺺ɳ����ڶ����������ȫû�У�
% MaxPower=sum(PresentPower(1:17))+B'*AvailablePower;���ļ����������������
MaxPower=0.6*sum(PresentPower(1:7))+sum(PresentPower(8:17))+0.6*B(1:4)'*AvailablePower(1:4)+B(5:14)'*AvailablePower(5:14)+B(17)*AvailablePower(17);
C=[MaxPower>=PredictionMaxPower*(1+0.1)];
%�����ã�����Ŀǰû�й�����С���ɵ�Ԥ�⣬��˲����Ǹ����ã�

%����󷢵�������󷢵�Сʱ
stPresentMaxHours=[3000*ones(7,1);6000*ones(10,1);2000*ones(2,1);8000*ones(1,1)];
stBuildMaxHours=[3000*ones(4,1);6000*ones(10,1);2000*ones(2,1);8000*ones(1,1)];
MaxAnnual=PresentPower'*stPresentMaxHours+(B.*AvailablePower)'*stBuildMaxHours;
C=[C,MaxAnnual>=PredictionAnnual*(1+0.1)];

%�Ż�����
options=sdpsettings('solver','cplex','verbose',2);
%���Ż�
sol=optimize(C,P,options);

%���
BuildChoice=value(B);
B=value(B);
MaxAnnual=PresentPower'*stPresentMaxHours+(B.*AvailablePower)'*stBuildMaxHours;
% MaxPower=sum(PresentPower)+B'*AvailablePower;
MaxPower=0.6*sum(PresentPower(1:7))+sum(PresentPower(8:17))+0.6*B(1:4)'*AvailablePower(1:4)+B(5:14)'*AvailablePower(5:14)+B(17)*AvailablePower(17);