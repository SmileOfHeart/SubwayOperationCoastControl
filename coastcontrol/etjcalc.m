function [ EnerCsm ,TravTim, Jerk ] = etjcalc( CoastPoint )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
global TRAVDIS TRAINWGH MAXACC;
r = 0.2;                    %列车电制动的一般j电能再生效率为0.2~0.8
y = 0.8;                    %机车电能转换成机械能的效率
e = 2.9;                    %惰行时机车的能每分钟能耗kw.h
g = 9.81;
dt = 0.1;                   %时间步长
tran = 3.6*10^6;            %千瓦时转焦耳系数

CurrVelo = 0;               %初始速度m
CurrLoc = 0;                %初始位置m
CoaTim = 0;                 %初始总惰行时间s
TravTim = 0;                %运行总时间s
RproEner = 0;               %初始再生能量
OldAcc = 0;                 %初始加速度
Jer = 0;                    %初始加速度变化和 
n = size(CoastPoint, 2);

%起车时
EnerCsm = 1000*TRAINWGH*MAXACC*CoastPoint(1);

%列车加速过程的净耗能计算
for i=1:1:n-1
    if (0==mod(i,2))
        EnerCsm = EnerCsm + 1000*TRAINWGH*MAXACC*(CoastPoint(i+1)-CoastPoint(i));
    end
end

%制动停车前的列车总惰行时间及列车当前位置当前速度的计算。
while CurrLoc < CoastPoint(n)
    [ CurrAcc,~,Sta ] = calcacc(CurrLoc,CurrVelo,OldAcc,CoastPoint);
    CurrLoc = CurrLoc + CurrVelo*dt + 0.5*CurrAcc*dt^2;
%     CurrLoc
    CurrVelo = CurrVelo + CurrAcc*dt;
    TravTim = TravTim + dt;
    if (1 == Sta)
        CoaTim = CoaTim + dt;
    end
    Jer = Jer + abs(CurrAcc-OldAcc);            %加速度变化和
    OldAcc = CurrAcc;
end

cEnerCsm = e*CoaTim/60;                                             %惰行耗能

%制动停车时再生能量的计算,目标速度暂设为0km/h
while CurrLoc <= TRAVDIS
    [ CurrAcc, Wb, ~ ] = calcacc(CurrLoc,CurrVelo,OldAcc,CoastPoint);
    ds = CurrVelo*dt + 0.5*CurrAcc*dt^2;
    if ds < 0
        break;
    end
    CurrLoc = CurrLoc + ds;
%     CurrLoc
    CurrVelo = CurrVelo + CurrAcc*dt;
    TravTim = TravTim + dt;
    Jer = Jer + abs(CurrAcc-OldAcc);                                %加速度变化和

    RproEner = RproEner + r*TRAINWGH*g*Wb*ds;
    OldAcc = CurrAcc;
end

EnerCsm = EnerCsm/tran/y + cEnerCsm - RproEner/tran;
Jerk = Jer/TravTim;
       
    
end

