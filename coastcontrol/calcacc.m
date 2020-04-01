function [ CurrAcc, Wb, Sta ] =calcacc( CurrLoc, CurrVelo,OldAcc, CoastPoint )
%�����г��ļ��ٶ�
%   �������         ����
%   CurrLoc       �г���ǰλ��
%   CurrVelo      ��ǰ�ٶ�
%   OldAcc        ��һʱ�̼��ٶ�
%   CoastPoint    ���п��Ƶ�
    
%   �������                 ����
%   CurrAcc             ��ǰ���ٶ�
%   Wb                  ��ǰ��λ�ƶ���
%   Sta                 ����״̬��0 ǣ����1���У�2�ƶ���
%   Detailed explanation goes here

%�����г���ǰ���ٶȼ��ƶ���
global MAXACC TRAVDIS COMFACC;           %���ٶȣ����ٶȣ�վ���

dt = 0.1;                                %ʱ�䲽��
Sta = 1;                                 %Ĭ�϶���״̬
CurrAcc = 0;                                    
g = 9.81;                                %�������ٶ�
Wb = 0;
v = CurrVelo*3.6;                        %�������CurrVelo��λΪm/s��Ϊ�˼��㵥λ������Ҫת��Ϊkm/h��
da = dt*COMFACC;

%�򻯵�ǣ�������ԣ�Atrǣ������С��ϵ��
Atr =1;
if v >=50
    Atr = 1-(v-50)/70;
end
if Atr < 0
    Atr =0;
end


%�¶ȸ�������wg=gradient, ���߸�������wc=600/R,RΪ���߰뾶��Ĭ���г�����С�����߳��ȡ�
%���ݻ��㣬���ٶ� a=c*g/1000,gΪ�������ٶȣ�ȡ9.81m/s^2,cΪ��λ������
a = 1.66; b = 0.0075; c = 0.000155;         %ǣ��涨��21��22�Ϳͳ���������ϵ����

[ Curvat ] = getcurvat( CurrLoc );          %����
[ Gradient ] = getgradient( CurrLoc );      %�¶�
n = size( CoastPoint, 2 );                  %���е����

Wq = a + b*v + c*v^2;
Wg = Gradient;
Wc = Curvat;
c = 1000 * MAXACC/g;
rc = Atr*c;
cacc = ( - Wq - Wg - Wc)*g/1000;

%�𳵼���ʱ
if ((CurrLoc>=0) && (CurrLoc<CoastPoint(1)))
    CurrAcc = (rc - Wq - Wg - Wc)*g/1000;
    Sta = 0;

%�ƶ�ͣ����Ŀ���ٶ���Ϊ0�����ʵ�ʼ���ʱ�����⣬���Կ��ǰ�Ŀ���ٶ���Ϊ5km/h.
elseif (CurrLoc>CoastPoint(n) && (CurrLoc<=TRAVDIS))
    Sta = 2;
    if CurrLoc < TRAVDIS-0.01
        CurrAcc = -0.5*CurrVelo^2/(TRAVDIS-CurrLoc);
        Wb = 0.5*CurrVelo^2/(TRAVDIS-CurrLoc)*1000/g-Wq-Wg-Wc;
    end
    
    %�г��ƶ�ͣ��ʱͨ���������ļ��ٶ�ֵС�ڻ��������ṩ�ļ��ٶ�ʱ��
    %�ƶ���Ϊ0�����ٶ�Ϊ���������ṩ
    if CurrAcc > cacc 
        CurrAcc = cacc;
    end
    if Wb < 0
        Wb = 0;
    end
    
%�ڶ��е������ʱ��ż����Ϊǣ����������Ϊ����   
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

