function [ SpdLim ] = getspeedlim( CurrLoc )
%��ȡ��������ֵ
%   Detailed explanation goes here
global SPDLIMARRAY;

%���ص��ٶ�ֵ��λΪm/s
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

