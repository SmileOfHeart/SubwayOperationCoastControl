function [ ChroFlg ] = testchrom( CoastPoint )
%惰行控制点的判断，有效返回1，无效返回0
%   Detailed explanation goes here

global MAXBACC TRAVDIS;

% 时间步长为0.1s，默认惰行控制点有效
g = 9.81;
dt = 0.1;
ChroFlg = 1;                    
CurrLoc = 0;
CurrVelo = 0;
OldAcc = 0;
n = length(CoastPoint);



while CurrLoc <= TRAVDIS
    [ CurrAcc,Wb,~ ] = calcacc(CurrLoc,CurrVelo,OldAcc,CoastPoint);
    ds = CurrVelo*dt + 0.5*CurrAcc*dt^2;
    CurrLoc = CurrLoc + ds;
    OldAcc = CurrAcc;
    
    %
    if ds <= 0 && CurrLoc >= TRAVDIS-0.5
%         warning('more coasting point needed.');
        break;
    end
    
    CurrVelo = CurrVelo + CurrAcc*dt;
    
    if CurrVelo<0.8 && CoastPoint(1)<CurrLoc && CoastPoint(n)>CurrLoc
        ChroFlg = 0;
%         warning('spdLOW');
        return;
    end
    spd = getspeedlim(CurrLoc);
    
%     超速或者制动未到达终点时速度降为0的情况
    if CurrVelo > spd
        ChroFlg = 0;
%         str =['spdHIGHT' num2str(spd) num2str(CurrVelo) ];
%         warning(str);
        return;
    elseif CurrVelo < 0 && CurrLoc <= TRAVDIS-0.5
        ChroFlg = 0;
        return;
    end
    
%     制动力超过列车最大制动能力
    if CurrLoc>CoastPoint(n) && CurrLoc<TRAVDIS
        if Wb>MAXBACC*1000/g
            ChroFlg = 0;
%             warning('I can not stop');
        end
    end
end


end

