%��ͼ
%��������ܳ���
for i=1:24
    sHydroPower1(i)=sum(shijiPower1(i,1:11));
    sCoalPower1(i)=sum(shijiPower1(i,12:31));
    sWindPower1(i)=sum(shijiPower1(i,32:35));
    sNuclear1(i)=sum(shijiPower1(i,36:37));
    sPower1(i,:)=[sWindPower1(i),sNuclear1(i),sHydroPower1(i),sCoalPower1(i),sHydroPower1(i)+sWindPower1(i)+sNuclear1(i)+sCoalPower1(i)];
    s1Power1(i,:)=[sWindPower1(i),sWindPower1(i)+sNuclear1(i),sWindPower1(i)+sHydroPower1(i)+sNuclear1(i),sHydroPower1(i)+sWindPower1(i)+sNuclear1(i)+sCoalPower1(i)];
end



%��ͼ
f1 = figure;      
stairs(sPower1,'linewidth',3);

axis square
axis([1 24,0 3500])
                        


%����figure��������
f1.Color = [1,1,1];                     %����figure����Ϊ��ɫ
legend('Wind','Nuclear','Hydro','Coal','Tatal')
t1 = title('��������������(������');
x1 = xlabel('ʱ��/ʱ');          %����������tex����
y1 = ylabel('��������ܳ���/��ǧ��');
t1.FontName = '����';                   %�����ʽ����Ϊ���壬���������
x1.FontName = '����'; 
y1.FontName = '����'; 

