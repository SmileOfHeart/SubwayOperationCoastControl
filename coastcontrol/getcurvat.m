function [ Curvat ] = getcurvat( CurrLoc )
%计算曲线附加阻力
%   Detailed explanation goes here
global CURVATARRAY;

Curvat = 0;
n = size(CURVATARRAY,2);
i = 1;
while ( i < n)
    if ((CurrLoc>=CURVATARRAY(1,i)) && (CurrLoc<CURVATARRAY(1,i+1)))
        if 0 == CURVATARRAY(2,i)
            Curvat = 0;
        else            
        Curvat = 600/CURVATARRAY(2,i);
        return;
        end
    end
            i = i + 1;
end

end

