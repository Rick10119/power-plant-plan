%2020年用电量预测（用于设计）
PredictionAnnual=1500;%亿千瓦时
PredictionAnnual=1500*10000;%万千瓦时
%2020年最大负荷预测（用于设计）
PredictionMaxPower=2320;%万千瓦
%2020典型负荷（冬/夏）（用于调度仿真）
stTypicalLoad=[
1616 	1313 
1473 	1295 
1473 	1212 
1451 	1093 
1451 	1258 
1494 	1295 
1646 	1313 
1842 	1442 
1929 	1701 
2103 	1884 
2191 	1899 
2049 	1664 
1820 	1682 
1907 	1664 
1951 	1664 
1951 	1664 
1951 	1664 
2103 	1738 
2125 	1793 
2169 	1886 
2321 	1812 
2169 	1756 
1995 	1571 
1625 	1350 
];
%风力典型出力标幺（冬/夏）
stTypicalWindPowerpu=[
0.23	0.42
0.21	0.50
0.25	0.84
0.29	1.00
0.26	0.86
0.64	0.36
0.78	0.37
0.94	0.44
1.00	0.23
1.00	0.30
0.92	0.13
0.86	0.11
1.00	0.01
0.77	0.07
0.65	0.02
0.57	0.06
0.69	0.07
0.63	0.16
0.57	0.31
0.53	0.22
0.34	0.21
0.22	0.39
0.14	0.19
0.11	0.50
];
%现有电源：
PresentHydro=[
50
120
170
120
70
130
100
];
PresentCoal=[
170
170
150
170
150
130
130
70
70
70
];
PresentWind=[
20
20
];
PresentPower=[
PresentHydro
PresentCoal
PresentWind
0
];
%待选电源：
AvailableHydro=[
50
200
200
200
];
AvailableCoal=[
160
110
160
70
70
70
70
70
160
160
];
AvailableWind=[
60
60
];
AvailableNuclear=[
150
];
AvailablePower=[
AvailableHydro
AvailableCoal
AvailableWind
AvailableNuclear
];
%修建花费
BuildPriceHydro=[
25
190
200
180
];
BuildPriceCoal=[
50
40
55
20
20
20
20
25
60
60
];
BuildPriceWind=[
40
40
];
BuildPriceNuclear=[
150
];
BuildPrice=[
BuildPriceHydro
BuildPriceCoal
BuildPriceWind
BuildPriceNuclear
];
%约束条件
%最大利用小时。。。年度最大发电量
% stMaxHours=[3000;6000;2000;8000];
%水电最大出力因子（冬/夏）
% stHydroMaxPowerFactor=[0.60;1.00];
%核电最小出力因子（一经投产）
% stNuclearMinPowerFactor=0.90;
%火电碳排放强度
% stECoal=0.800;%kgCO2/kWh
%火电最小出力因子（一经启动）
% stCoalMinPowerFactor=0.50;
%不考虑网络特性和电力输送
%系统备用容量因子（正负）（风电不用考虑）
% stReservePowerFactor=0.10;

%有待添加：
%碳价
%爬坡约束