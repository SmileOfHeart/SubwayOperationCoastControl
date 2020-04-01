function [ ChroFlg ] = testchrom( CoastPoint )
%���п��Ƶ���жϣ���Ч����1����Ч����0
%   Detailed explanation goes here

global MAXBACC TRAVDIS;

% ʱ�䲽��Ϊ0.1s��Ĭ�϶��п��Ƶ���Ч
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
    
%     ���ٻ����ƶ�δ�����յ�ʱ�ٶȽ�Ϊ0�����
    if CurrVelo > spd
        ChroFlg = 0;
%         str =['spdHIGHT' num2str(spd) num2str(CurrVelo) ];
%         warning(str);
        return;
    elseif CurrVelo < 0 && CurrLoc <= TRAVDIS-0.5
        ChroFlg = 0;
        return;
    end
    
%     �ƶ��������г�����ƶ�����
    if CurrLoc>CoastPoint(n) && CurrLoc<TRAVDIS
        if Wb>MAXBACC*1000/g
            ChroFlg = 0;
%             warning('I can not stop');
        end
    end
end


end

