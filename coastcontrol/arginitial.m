function arginitial( )
%相关参数的初始设置，包列车相关参数，线路条件和限速
%   Detailed explanation goes here

global MAXACC MAXBACC INTERDIS TRAINWGH TRAVDIS TRAINLEN COADIS...
    COMFACC DESIGNTIM ...
    SPDLIMARRAY GRAARRAY CURVATARRAY num;
num =100000;
TRAINWGH = 280;                         %列车质量t
MAXACC = 0.8;                           %最大加速度m/s^2
MAXBACC = 1;                            %最大减速度m/s^2
INTERDIS = 1200;                        %站间距m
TRAINLEN = 0;                           %列车长度
TRAVDIS = INTERDIS + TRAINLEN;          %旅行距离

COADIS = 50;                            %最小惰行距离m
COMFACC = 0.5;                          %舒适性加速度变化率(m/s^2)/s
DESIGNTIM = 90;                         %计划运行时间s
SPDLIMARRAY = [0,TRAVDIS;80,80];      %限速km/h
GRAARRAY = [0,TRAVDIS;0,0];             %坡度，千分度
CURVATARRAY = [0,TRAVDIS;0,0];          %曲率

% CURVATARRAY = [0,300,900,TRAVDIS;150,200,300,300];
% SPDLIMARRAY = [0,200,500,800,1000,TRAVDIS;50,50,80,80,80,80];
% SPDLIMARRAY = [0,200,500,800,1000,TRAVDIS;80,80,80,50,50,50];
% SPDLIMARRAY = [0,200,500,800,1000,TRAVDIS;80,80,50,80,80,80];
% GRAARRAY = [0,300,500,1000,1250,1500,1700,1800,2200,TRAVDIS; ...
%             6,-7,3,0,-4,1,7,2,0,0];
        
% GRAARRAY = [0,300,500,1000,1250,1500,1700,1800,2200,TRAVDIS; ...
%             70,70,70,70,70,70,70,70,0,0];
end

