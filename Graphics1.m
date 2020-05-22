%作图
%各类机组总出力
for i=1:24
    sHydroPower1(i)=sum(shijiPower1(i,1:11));
    sCoalPower1(i)=sum(shijiPower1(i,12:31));
    sWindPower1(i)=sum(shijiPower1(i,32:35));
    sNuclear1(i)=sum(shijiPower1(i,36:37));
    sPower1(i,:)=[sWindPower1(i),sNuclear1(i),sHydroPower1(i),sCoalPower1(i),sHydroPower1(i)+sWindPower1(i)+sNuclear1(i)+sCoalPower1(i)];
    s1Power1(i,:)=[sWindPower1(i),sWindPower1(i)+sNuclear1(i),sWindPower1(i)+sHydroPower1(i)+sNuclear1(i),sHydroPower1(i)+sWindPower1(i)+sNuclear1(i)+sCoalPower1(i)];
end



%绘图
f1 = figure;      
stairs(sPower1,'linewidth',3);

axis square
axis([1 24,0 3500])
                        


%设置figure各个参数
f1.Color = [1,1,1];                     %设置figure背景为白色
legend('Wind','Nuclear','Hydro','Coal','Tatal')
t1 = title('各类机组出力曲线(冬季）');
x1 = xlabel('时刻/时');          %轴标题可以用tex解释
y1 = ylabel('各类机组总出力/万千瓦');
t1.FontName = '宋体';                   %标题格式设置为宋体，否则会乱码
x1.FontName = '宋体'; 
y1.FontName = '宋体'; 

