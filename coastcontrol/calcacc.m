function [ CurrAcc, Wb, Sta ] =calcacc( CurrLoc, CurrVelo,OldAcc, CoastPoint )
%计算列车的加速度
%   输入参数         含义
%   CurrLoc       列车当前位置
%   CurrVelo      当前速度
%   OldAcc        上一时刻加速度
%   CoastPoint    惰行控制点
    
%   输出参数                 含义
%   CurrAcc             当前加速度
%   Wb                  当前单位制动力
%   Sta                 运行状态（0 牵引；1惰行；2制动）
%   Detailed explanation goes here

%计算列车当前加速度及制动力
global MAXACC TRAVDIS COMFACC;           %加速度，减速度，站间距

dt = 0.1;                                %时间步长
Sta = 1;                                 %默认惰行状态
CurrAcc = 0;                                    
g = 9.81;                                %重力加速度
Wb = 0;
v = CurrVelo*3.6;                        %传入参数CurrVelo单位为m/s，为了计算单位合力需要转换为km/h。
da = dt*COMFACC;

%简化的牵引力特性，Atr牵引力大小的系数
Atr =1;
if v >=50
    Atr = 1-(v-50)/70;
end
if Atr < 0
    Atr =0;
end


%坡度附力阻力wg=gradient, 曲线附加阻力wc=600/R,R为曲线半径，默认列车长度小于曲线长度。
%根据换算，加速度 a=c*g/1000,g为重力加速度，取9.81m/s^2,c为单位合力。
a = 1.66; b = 0.0075; c = 0.000155;         %牵规规定的21、22型客车基本阻力系数。

[ Curvat ] = getcurvat( CurrLoc );          %曲度
[ Gradient ] = getgradient( CurrLoc );      %坡度
n = size( CoastPoint, 2 );                  %惰行点个数

Wq = a + b*v + c*v^2;
Wg = Gradient;
Wc = Curvat;
c = 1000 * MAXACC/g;
rc = Atr*c;
cacc = ( - Wq - Wg - Wc)*g/1000;

%起车加速时
if ((CurrLoc>=0) && (CurrLoc<CoastPoint(1)))
    CurrAcc = (rc - Wq - Wg - Wc)*g/1000;
    Sta = 0;

%制动停车，目标速度设为0，如果实际计算时有问题，可以考虑把目标速度设为5km/h.
elseif (CurrLoc>CoastPoint(n) && (CurrLoc<=TRAVDIS))
    Sta = 2;
    if CurrLoc < TRAVDIS-0.01
        CurrAcc = -0.5*CurrVelo^2/(TRAVDIS-CurrLoc);
        Wb = 0.5*CurrVelo^2/(TRAVDIS-CurrLoc)*1000/g-Wq-Wg-Wc;
    end
    
    %列车制动停车时通过距离计算的加速度值小于基本阻力提供的加速度时，
    %制动力为0，加速度为基本阻力提供
    if CurrAcc > cacc 
        CurrAcc = cacc;
    end
    if Wb < 0
        Wb = 0;
    end
    
%在惰行点间运行时，偶数点为牵引，奇数点为惰行   
else
    i = 1;
    while (i < n)
        if ( (CurrLoc>=CoastPoint(i)) && (CurrLoc<CoastPoint(i+1)) )
            if (0==mod(i,2))
                CurrAcc = rc*g/1000 + cacc;
                Sta = 0;
            else
                CurrAcc = cacc;
                Sta = 1;
            end
            break;
        end
        i = i + 1;
    end
end
if abs(CurrAcc - OldAcc) > da
    if CurrAcc > OldAcc
        CurrAcc = OldAcc + da;
    else
        CurrAcc = OldAcc - da;
    end
end
        
    

end

