function arginitial( )
%��ز����ĳ�ʼ���ã����г���ز�������·����������
%   Detailed explanation goes here

global MAXACC MAXBACC INTERDIS TRAINWGH TRAVDIS TRAINLEN COADIS...
    COMFACC DESIGNTIM ...
    SPDLIMARRAY GRAARRAY CURVATARRAY num;
num =100000;
TRAINWGH = 280;                         %�г�����t
MAXACC = 0.8;                           %�����ٶ�m/s^2
MAXBACC = 1;                            %�����ٶ�m/s^2
INTERDIS = 1200;                        %վ���m
TRAINLEN = 0;                           %�г�����
TRAVDIS = INTERDIS + TRAINLEN;          %���о���

COADIS = 50;                            %��С���о���m
COMFACC = 0.5;                          %�����Լ��ٶȱ仯��(m/s^2)/s
DESIGNTIM = 90;                         %�ƻ�����ʱ��s
SPDLIMARRAY = [0,TRAVDIS;80,80];      %����km/h
GRAARRAY = [0,TRAVDIS;0,0];             %�¶ȣ�ǧ�ֶ�
CURVATARRAY = [0,TRAVDIS;0,0];          %����

% CURVATARRAY = [0,300,900,TRAVDIS;150,200,300,300];
% SPDLIMARRAY = [0,200,500,800,1000,TRAVDIS;50,50,80,80,80,80];
% SPDLIMARRAY = [0,200,500,800,1000,TRAVDIS;80,80,80,50,50,50];
% SPDLIMARRAY = [0,200,500,800,1000,TRAVDIS;80,80,50,80,80,80];
% GRAARRAY = [0,300,500,1000,1250,1500,1700,1800,2200,TRAVDIS; ...
%             6,-7,3,0,-4,1,7,2,0,0];
        
% GRAARRAY = [0,300,500,1000,1250,1500,1700,1800,2200,TRAVDIS; ...
%             70,70,70,70,70,70,70,70,0,0];
end

