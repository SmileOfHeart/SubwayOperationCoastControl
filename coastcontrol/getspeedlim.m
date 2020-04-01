function [ SpdLim ] = getspeedlim( CurrLoc )
%获取区间限速值
%   Detailed explanation goes here
global SPDLIMARRAY;

%返回的速度值单位为m/s
SpdLim = 5/3.6;
n = size(SPDLIMARRAY, 2);
i = 1;
while i < n
    if((CurrLoc>=SPDLIMARRAY(1,i)) && (CurrLoc<SPDLIMARRAY(1,i+1)))
        SpdLim = (SPDLIMARRAY(2, i)-2)/3.6;
        return;
    end
    i = i + 1;
end

end

