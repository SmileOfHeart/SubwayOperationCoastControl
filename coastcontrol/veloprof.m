function [ TravTim, EnerCsm,Jerk ] = veloprof( CoastPoint )
%�����Ѷ��п��Ƶ㡢�ܺĺ�����ʱ�䣬�����ٶ�-���룬ʱ���ܺ�-��������
%   Detailed explanation goes here

global SPDLIMARRAY TRAINLEN TRAVDIS MAXACC TRAINWGH  num;

dt = 0.1;                   %ʱ�䲽��
r = 0.2;                    %�г����ƶ���һ��j��������Ч��Ϊ0.2~0.8
y = 0.8;                    %��������ת���ɻ�е�ܵ�Ч��
e = 2.9;                    %����ʱ��������ÿ�����ܺ�kw/h
g = 9.81;
tran = 3.6*10^6;            %ǧ��ʱת����ϵ��



m = figure(2) ;
hold on;
stairs(SPDLIMARRAY(1,:),SPDLIMARRAY(2,:),'--k');    %�����ٶ�����
axis([0,(max(SPDLIMARRAY(1,:))+TRAINLEN +100),0,(max(SPDLIMARRAY(2,:))+5)]);
[ ~ ,TravTim, Jerk] = etjcalc( CoastPoint );

travtim = 0;
engy = 0;
CurrLoc = 0;
CurrVelo = 0;
OldAcc = 0;

n = round(TravTim/dt);                          
p = n + 1;                                          %ͼ��������Ƶ����
velo = zeros(p,1);                                  
dist = zeros(p,1);
energy = zeros(p,1);
travtime = zeros(p,1);

for i=1:1:n
    [ CurrAcc,Wb, Sta ] = calcacc(CurrLoc,CurrVelo,OldAcc,CoastPoint);
    ds = CurrVelo*dt + 0.5*CurrAcc*dt^2;            %��������
    CurrLoc = CurrLoc + ds;
    CurrVelo = CurrVelo + CurrAcc*dt;
    travtim = travtim + dt;
    if 0==Sta
        de = 1000*TRAINWGH*MAXACC*ds/tran/y;        %��������
    elseif 1==Sta
        de = e*dt/60;
    else
        de =  - r*TRAINWGH*g*Wb*ds/tran;
    end
    engy = engy + de;
    
    OldAcc = CurrAcc;
    
    travtime(i+1) = travtim ;
    energy(i+1) = engy;
    velo(i+1) = CurrVelo*3.6;
    dist(i+1) = CurrLoc;
end

% �ٶȾ�������
plot(dist,velo,'k');
xlabel('����S��m��');
ylabel('�ٶ�V(km/h)');

% ���浽�����ļ��У�������ֵ����ļ������Ҫ����strֵ��
% ���߸���saveas()������ʽ���浽��ǰ����Ŀ¼
% str = ['C:\Users\Tfc\Desktop\profile\' num2str(num) num2str(TRAVDIS) '\disveo'];
% saveas(m,str,'fig');

% ʱ�䡢�ܺ�����
n = figure(3);
plot(dist,travtime,'k',dist,energy,':k');
% grid;
legend('��ʱ�仯','�ܺĹ���');
xlabel('����S��m��');
ylabel('ʱ�䣨s�����ܺģ�kW�Bh��');

% str = [  'C:\Users\Tfc\Desktop\profile\' num2str(num) num2str(TRAVDIS)  '\entim'];
% saveas(n,str,'fig');

%ʱ�䡢�ܺġ����п��Ƶ���.txt��ʽ����
TravTim = travtime(p);
EnerCsm = energy(p);
% txtname = [ 'C:\Users\Tfc\Desktop\profile\' num2str(num) num2str(TRAVDIS) '\data.txt'];
% save(txtname,'TravTim','EnerCsm','CoastPoint','-ascii');

end

