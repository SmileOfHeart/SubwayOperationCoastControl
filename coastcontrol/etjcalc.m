function [ EnerCsm ,TravTim, Jerk ] = etjcalc( CoastPoint )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
global TRAVDIS TRAINWGH MAXACC;
r = 0.2;                    %�г����ƶ���һ��j��������Ч��Ϊ0.2~0.8
y = 0.8;                    %��������ת���ɻ�е�ܵ�Ч��
e = 2.9;                    %����ʱ��������ÿ�����ܺ�kw.h
g = 9.81;
dt = 0.1;                   %ʱ�䲽��
tran = 3.6*10^6;            %ǧ��ʱת����ϵ��

CurrVelo = 0;               %��ʼ�ٶ�m
CurrLoc = 0;                %��ʼλ��m
CoaTim = 0;                 %��ʼ�ܶ���ʱ��s
TravTim = 0;                %������ʱ��s
RproEner = 0;               %��ʼ��������
OldAcc = 0;                 %��ʼ���ٶ�
Jer = 0;                    %��ʼ���ٶȱ仯�� 
n = size(CoastPoint, 2);

%��ʱ
EnerCsm = 1000*TRAINWGH*MAXACC*CoastPoint(1);

%�г����ٹ��̵ľ����ܼ���
for i=1:1:n-1
    if (0==mod(i,2))
        EnerCsm = EnerCsm + 1000*TRAINWGH*MAXACC*(CoastPoint(i+1)-CoastPoint(i));
    end
end

%�ƶ�ͣ��ǰ���г��ܶ���ʱ�估�г���ǰλ�õ�ǰ�ٶȵļ��㡣
while CurrLoc < CoastPoint(n)
    [ CurrAcc,~,Sta ] = calcacc(CurrLoc,CurrVelo,OldAcc,CoastPoint);
    CurrLoc = CurrLoc + CurrVelo*dt + 0.5*CurrAcc*dt^2;
%     CurrLoc
    CurrVelo = CurrVelo + CurrAcc*dt;
    TravTim = TravTim + dt;
    if (1 == Sta)
        CoaTim = CoaTim + dt;
    end
    Jer = Jer + abs(CurrAcc-OldAcc);            %���ٶȱ仯��
    OldAcc = CurrAcc;
end

cEnerCsm = e*CoaTim/60;                                             %���к���

%�ƶ�ͣ��ʱ���������ļ���,Ŀ���ٶ�����Ϊ0km/h
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
    Jer = Jer + abs(CurrAcc-OldAcc);                                %���ٶȱ仯��

    RproEner = RproEner + r*TRAINWGH*g*Wb*ds;
    OldAcc = CurrAcc;
end

EnerCsm = EnerCsm/tran/y + cEnerCsm - RproEner/tran;
Jerk = Jer/TravTim;
       
    
end

