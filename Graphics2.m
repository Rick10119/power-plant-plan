%��ͼ
%��������ܳ���


for i=1:24
    sHydroPower2(i)=sum(shijiPower2(i,1:11));
    sCoalPower2(i)=sum(shijiPower2(i,12:31));
    sWindPower2(i)=sum(shijiPower2(i,32:35));
    sNuclear2(i)=sum(shijiPower2(i,36:37));
    sPower2(i,:)=[sWindPower2(i),sNuclear2(i),sHydroPower2(i),sCoalPower2(i),sHydroPower2(i)+sWindPower2(i)+sNuclear2(i)+sCoalPower2(i)];
    s2Power2(i,:)=[sWindPower2(i),sWindPower2(i)+sNuclear2(i),sWindPower2(i)+sHydroPower2(i)+sNuclear2(i),sHydroPower2(i)+sWindPower2(i)+sNuclear2(i)+sCoalPower2(i)];
end



%��ͼ
f1 = figure;      
stairs(sPower2,'linewidth',3);

axis square
axis([1 24,0 3500])
                        


%����figure��������
f1.Color = [1,1,1];                     %����figure����Ϊ��ɫ
legend('Wind','Nuclear','Hydro','Coal','Tatal')
t1 = title('��������������(�ļ���');
x1 = xlabel('ʱ��/ʱ');          %����������tex����
y1 = ylabel('��������ܳ���/��ǧ��');
t1.FontName = '����';                   %�����ʽ����Ϊ���壬���������
x1.FontName = '����'; 
y1.FontName = '����'; 

