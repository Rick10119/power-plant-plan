%����

%һЩ׼������

%���еĵ�Դ�����½��ĵ�Դ��Ϊ2020�������ȵĵ�Դ
%���ڵĵ�Դ����        ˮ7 ��10 ��2 ��0
%�����ĵ�Դ���� ���   ˮ4 ��10 ��2 ��1  ����Plan������BuildChoice
NewPower=BuildChoice.*AvailablePower;
%2020ʵ�ʵĵ�Դ ���    ˮ11 ��20 ��4 ��01
Power2020=[PresentPower(1:7);
    NewPower(1:4);
    PresentPower(8:17);
    NewPower(5:14);
    PresentPower(18:19);
    NewPower(15:16);
    PresentPower(20);
    NewPower(17)];
%����Դ��ˮ�硢��硢��硢�˵�����

% i��Сʱ   j:����
%���ݻ������������С����
for i=1:24
    for j=1:11%ˮ�綬��0.6���ļ�1.0
        stMaxPower1(i,j)=Power2020(j)*0.6;
        stMinPower1(i,j)=0;
        stMaxPower2(i,j)=Power2020(j)*1.0;
        stMinPower2(i,j)=0;
    end
    for j=12:31%���0.5-1.0
        stMaxPower1(i,j)=Power2020(j);
        stMinPower1(i,j)=Power2020(j)*0.5;
        stMaxPower2(i,j)=Power2020(j);
        stMinPower2(i,j)=Power2020(j)*0.5;
    end
    for j=32:35%�����ݵ��ͳ�������
        stMaxPower1(i,j)=Power2020(j)*stTypicalWindPowerpu(i,1);%����
        stMinPower1(i,j)=0;
        stMaxPower2(i,j)=Power2020(j)*stTypicalWindPowerpu(i,2);%�ļ�
        stMinPower2(i,j)=0;
    end
    for j=36:37%�˵�0.9-1.0
        stMaxPower1(i,j)=Power2020(j);
        stMinPower1(i,j)=Power2020(j)*0.9;
        stMaxPower2(i,j)=Power2020(j);
        stMinPower2(i,j)=Power2020(j)*0.9;
    end
end


%�Ż���ѧ��ģ

%���ñ���
I1=binvar(24,37,'full');%0-1������������
P1=sdpvar(24,37,'full');%�����������(������
Uup1=binvar(24,37,'full');%��ָͣʾ����
Udown1=binvar(24,37,'full');%��ָͣʾ����

I2=binvar(24,37,'full');%0-1�������ļ���
P2=sdpvar(24,37,'full');%�����������(�ļ���
Uup2=binvar(24,37,'full');%��ָͣʾ����
Udown2=binvar(24,37,'full');%��ָͣʾ����

%����Ŀ�꺯��

%�������˳��(���ȷ�磬���ˮ�磬��κ˵磬����磩
weight=[1*ones(11,1);3*ones(20,1);0*ones(4,1);2*ones(2,1)];
%һ��ĵ���Ŀ�꣨����185�죬�ļ�180�죩��̼����
 P=185*sum(P1*weight)+180*sum(P2*weight);
 
 %���ǻ��ɱ�����
% P=0;
% for i=1:24
% for j=12:31
%     if Power2020(j)==0
%         Power2020(j)=100;end
%     P=P+180*(P1(i,j)/Power2020(j)+P2(i,j)/Power2020(j));
% end
% end
%������ͣ�ɱ� 
%P=185*sum(P1*weight)+180*sum(P2*weight)+180*��Uup1+Uup2+Udown1+Udown2);


%����Լ������    

C=[];
%����ƽ��Լ��(24Сʱ��
for i=1:24
    C=[C,sum(P1(i,:))==stTypicalLoad(i,1)];%����
    C=[C,sum(P2(i,:))==stTypicalLoad(i,2)];%�ļ�
end

%ϵͳ����Լ��
%ʵʱ�����С���ʷ�Χ
instMaxPower1=I1.*stMaxPower1;
instMinPower1=I1.*stMinPower1;
instMaxPower2=I2.*stMaxPower2;
instMinPower2=I2.*stMinPower2;
for i=24  %�����Ƿ��
    C=[C,sum(instMaxPower1(i,1:31))+sum(instMaxPower1(i,36:37))>=stTypicalLoad(i,1)*(1+0.1)];
    C=[C,sum(instMinPower1(i,1:31))+sum(instMinPower1(i,36:37))<=stTypicalLoad(i,1)*(1-0.1)];
    C=[C,sum(instMaxPower2(i,1:31))+sum(instMaxPower2(i,36:37))>=stTypicalLoad(i,2)*(1+0.1)];
    C=[C,sum(instMinPower2(i,1:31))+sum(instMinPower2(i,36:37))<=stTypicalLoad(i,2)*(1-0.1)];
end

%�귢�����Сʱ��Լ��(���37�����飩
%�귢����
shijiAnnualPower=ones(1,24)*(185*P1+180*P2);%����185�죬�ļ�180��
%����󷢵�Сʱ
stMaxHours2020=[3000*ones(11,1);6000*ones(20,1);2000*ones(4,1);8000*ones(2,1)];
%����󷢵���
stMaxAnnualPower2020=Power2020.*stMaxHours2020;
for j=1:37
    C=[C,shijiAnnualPower(j)<=stMaxAnnualPower2020(j)];
end

%�������Լ��
for i=1:24%ÿ��Сʱ
    for j=1:35%ˮ��ͻ�硢��磨ˮ��ͷ��Ŀ��ر���ʵ���ϲ������ã�
        C=[C,I1(i,j)*stMinPower1(i,j)<=P1(i,j)<=I1(i,j)*stMaxPower1(i,j)];%����
        C=[C,I2(i,j)*stMinPower2(i,j)<=P2(i,j)<=I2(i,j)*stMaxPower2(i,j)];%�ļ�
    end
    for j=36:37%�˵磨0.9~1.0�����˵粻�ܹأ�
        C=[C,stMinPower1(i,j)<=P1(i,j)<=stMaxPower1(i,j)];
        C=[C,stMinPower2(i,j)<=P2(i,j)<=stMaxPower2(i,j)];
    end
end

%����������Լ��
%��һ���0-6ʱ��Ϊ�ڶ���23ʱ�Ժ�ĳ��������㿼�����º���ͣ
I1=[I1;I1(1:6,:)];
P1=[P1;P1(1:6,:)];
Uup1=[Uup1;Uup1(1:6,:)];
Udown1=[Udown1;Udown1(1:6,:)];

I2=[I2;I2(1:6,:)];
P2=[P2;P2(1:6,:)];
Uup2=[Uup2;Uup2(1:6,:)];
Udown2=[Udown2;Udown2(1:6,:)];

%�������
for i=2:25%ʱ�����
    for j=12:31%���������
        C=[C, P1(i,j)-P1(i-1,j)+I1(i-1,j)*(stMinPower1(1,j)-0.2*stMaxPower1(1,j))+I1(i,j)*(stMaxPower1(1,j)-stMinPower1(1,j))<=stMaxPower1(1,j)];
        C=[C,-P1(i,j)+P1(i-1,j)+I1(i,j)*(stMinPower1(1,j)-0.2*stMaxPower1(1,j))+I1(i-1,j)*(stMaxPower1(1,j)-stMinPower1(1,j))<=stMaxPower1(1,j)];
        C=[C, P2(i,j)-P2(i-1,j)+I2(i-1,j)*(stMinPower2(1,j)-0.2*stMaxPower2(1,j))+I2(i,j)*(stMaxPower2(1,j)-stMinPower2(1,j))<=stMaxPower2(1,j)];
        C=[C,-P2(i,j)+P2(i-1,j)+I2(i,j)*(stMinPower2(1,j)-0.2*stMaxPower2(1,j))+I2(i-1,j)*(stMaxPower2(1,j)-stMinPower2(1,j))<=stMaxPower2(1,j)];
    end
end

%������ͣԼ��
%������ͣ״̬�����������ָͣʾ��������Լ��
for i=2:25  
    for j=12:31
        C=[C,Uup1(i,j)>=I1(i,j)-I1(i-1,j)];
        C=[C,Udown1(i,j)>=I1(i-1,j)-I1(i,j)];
        C=[C,Uup2(i,j)>=I2(i,j)-I2(i-1,j)];
        C=[C,Udown2(i,j)>=I2(i-1,j)-I2(i,j)];
    end
end
%������С��ͣʱ������
%(�������л�����ͣ��Сʱ�䰴���ʣ���ǧ�ߣ�100����6Сʱ��100����3Сʱ��200����12Сʱ��
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
%������С��ͣʱ��Լ��
for i=7:30
    for j=12:31
        C=[C,(I1(i,j)-I1(i-1,j))*TimeOnMin(j)+sum(I1(i-TimeOnMin(j):i-1,j))>=0];
        C=[C,(I1(i-1,j)-I1(i,j))*TimeOffMin(j)+TimeOffMin(j)-sum(I1(i-TimeOffMin(j):i-1,j))>=0];
        C=[C,(I2(i,j)-I2(i-1,j))*TimeOnMin(j)+sum(I2(i-TimeOnMin(j):i-1,j))>=0];
        C=[C,(I2(i-1,j)-I2(i,j))*TimeOffMin(j)+TimeOffMin(j)-sum(I2(i-TimeOffMin(j):i-1,j))>=0];
    end
end
%���������ͣ����Լ�����������л��������/ͣ3�Σ�
UupMax=3;UdownMax=3;
for j=12:31
    C=[C,sum(Uup1(1:24,j))<=UupMax];
    C=[C,sum(Udown1(1:24,j))<=UdownMax];
    C=[C,sum(Uup2(1:24,j))<=UupMax];
    C=[C,sum(Udown2(1:24,j))<=UdownMax];
end

%�Ż�����
options=sdpsettings('solver','cplex','verbose',2);
%���Ż�
sol=optimize(C,P,options);

%ȡ���
I1=value(I1(1:24,:));
shijiPower1=value(P1(1:24,:));
I2=value(I2(1:24,:));
shijiPower2=value(P2(1:24,:));
