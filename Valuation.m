%º∆À„÷∏±Í
% shijiPower1=DispatchPower11;
% shijiPower2=DispatchPower12;

% shijiPower1=DispatchPower21;
% shijiPower2=DispatchPower22;

% for i=1:24
%     sHydroPower1(i)=sum(shijiPower1(i,1:11));
%     sCoalPower1(i)=sum(shijiPower1(i,12:31));
%     sWindPower1(i)=sum(shijiPower1(i,32:35));
%     sNuclear1(i)=sum(shijiPower1(i,36:37));
%     sPower1(i,:)=[sWindPower1(i),sNuclear1(i),sHydroPower1(i),sCoalPower1(i),sHydroPower1(i)+sWindPower1(i)+sNuclear1(i)+sCoalPower1(i)];
%     s1Power1(i,:)=[sWindPower1(i),sWindPower1(i)+sNuclear1(i),sWindPower1(i)+sHydroPower1(i)+sNuclear1(i),sHydroPower1(i)+sWindPower1(i)+sNuclear1(i)+sCoalPower1(i)];
% end
% 
% for i=1:24
%     sHydroPower2(i)=sum(shijiPower2(i,1:11));
%     sCoalPower2(i)=sum(shijiPower2(i,12:31));
%     sWindPower2(i)=sum(shijiPower2(i,32:35));
%     sNuclear2(i)=sum(shijiPower2(i,36:37));
%     sPower2(i,:)=[sWindPower2(i),sNuclear2(i),sHydroPower2(i),sCoalPower2(i),sHydroPower2(i)+sWindPower2(i)+sNuclear2(i)+sCoalPower2(i)];
%     s2Power2(i,:)=[sWindPower2(i),sWindPower2(i)+sNuclear2(i),sWindPower2(i)+sHydroPower2(i)+sNuclear2(i),sHydroPower2(i)+sWindPower2(i)+sNuclear2(i)+sCoalPower2(i)];
% end

%    percentage=value(shijiAnnualPower'./stMaxAnnualPower2020);
%    per1=mean(percentage(1:11))
P=0;
for i=1:24
for j=12:31
    
    P=P+180*(P1(i,j)/Power2020(j)+P2(i,j)/Power2020(j));
end
end
ave=1000*value(P)/sum(shijiAnnualPower(12:31));
sum(shijiAnnualPower)



