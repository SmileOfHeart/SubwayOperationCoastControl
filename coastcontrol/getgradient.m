function [ Gradient ] = getgradient( CurrLoc )
%计算坡道附加阻力
%   Detailed explanation goes here
global GRAARRAY;
Gradient = 0;
n = size(GRAARRAY, 2);
i = 1;
while (i<n)
    if((CurrLoc>=GRAARRAY(1,i)) && (CurrLoc<GRAARRAY(1,i+1)))
        Gradient = GRAARRAY(2, i);
        return;
    end
    i = i + 1;
end

end

