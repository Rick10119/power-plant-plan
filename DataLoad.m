%2020���õ���Ԥ�⣨������ƣ�
PredictionAnnual=1500;%��ǧ��ʱ
PredictionAnnual=1500*10000;%��ǧ��ʱ
%2020����󸺺�Ԥ�⣨������ƣ�
PredictionMaxPower=2320;%��ǧ��
%2020���͸��ɣ���/�ģ������ڵ��ȷ��棩
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
%�������ͳ������ۣ���/�ģ�
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
%���е�Դ��
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
%��ѡ��Դ��
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
%�޽�����
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
%Լ������
%�������Сʱ�����������󷢵���
% stMaxHours=[3000;6000;2000;8000];
%ˮ�����������ӣ���/�ģ�
% stHydroMaxPowerFactor=[0.60;1.00];
%�˵���С�������ӣ�һ��Ͷ����
% stNuclearMinPowerFactor=0.90;
%���̼�ŷ�ǿ��
% stECoal=0.800;%kgCO2/kWh
%�����С�������ӣ�һ��������
% stCoalMinPowerFactor=0.50;
%�������������Ժ͵�������
%ϵͳ�����������ӣ�����������粻�ÿ��ǣ�
% stReservePowerFactor=0.10;

%�д���ӣ�
%̼��
%����Լ��