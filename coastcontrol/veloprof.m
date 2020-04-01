function [ TravTim, EnerCsm,Jerk ] = veloprof( CoastPoint )
%输出最佳惰行控制点、能耗和运行时间，画出速度-距离，时间能耗-距离曲线
%   Detailed explanation goes here

global SPDLIMARRAY TRAINLEN TRAVDIS MAXACC TRAINWGH  num;

dt = 0.1;                   %时间步长
r = 0.2;                    %列车电制动的一般j电能再生效率为0.2~0.8
y = 0.8;                    %机车电能转换成机械能的效率
e = 2.9;                    %惰行时机车的能每分钟能耗kw/h
g = 9.81;
tran = 3.6*10^6;            %千瓦时转焦耳系数



m = figure(2) ;
hold on;
stairs(SPDLIMARRAY(1,:),SPDLIMARRAY(2,:),'--k');    %区间速度限制
axis([0,(max(SPDLIMARRAY(1,:))+TRAINLEN +100),0,(max(SPDLIMARRAY(2,:))+5)]);
[ ~ ,TravTim, Jerk] = etjcalc( CoastPoint );

travtim = 0;
engy = 0;
CurrLoc = 0;
CurrVelo = 0;
OldAcc = 0;

n = round(TravTim/dt);                          
p = n + 1;                                          %图形输出控制点个数
velo = zeros(p,1);                                  
dist = zeros(p,1);
energy = zeros(p,1);
travtime = zeros(p,1);

for i=1:1:n
    [ CurrAcc,Wb, Sta ] = calcacc(CurrLoc,CurrVelo,OldAcc,CoastPoint);
    ds = CurrVelo*dt + 0.5*CurrAcc*dt^2;            %距离增量
    CurrLoc = CurrLoc + ds;
    CurrVelo = CurrVelo + CurrAcc*dt;
    travtim = travtim + dt;
    if 0==Sta
        de = 1000*TRAINWGH*MAXACC*ds/tran/y;        %能量增量
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

% 速度距离曲线
plot(dist,velo,'k');
xlabel('距离S（m）');
ylabel('速度V(km/h)');

% 保存到桌面文件夹，程序移值到别的计算机需要更改str值，
% 或者更改saveas()函数形式保存到当前工作目录
% str = ['C:\Users\Tfc\Desktop\profile\' num2str(num) num2str(TRAVDIS) '\disveo'];
% saveas(m,str,'fig');

% 时间、能耗曲线
n = figure(3);
plot(dist,travtime,'k',dist,energy,':k');
% grid;
legend('用时变化','能耗过程');
xlabel('距离S（m）');
ylabel('时间（s），能耗（kW˙h）');

% str = [  'C:\Users\Tfc\Desktop\profile\' num2str(num) num2str(TRAVDIS)  '\entim'];
% saveas(n,str,'fig');

%时间、能耗、惰行控制点以.txt格式保存
TravTim = travtime(p);
EnerCsm = energy(p);
% txtname = [ 'C:\Users\Tfc\Desktop\profile\' num2str(num) num2str(TRAVDIS) '\data.txt'];
% save(txtname,'TravTim','EnerCsm','CoastPoint','-ascii');

end

