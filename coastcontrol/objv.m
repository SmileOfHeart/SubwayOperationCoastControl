function [ ObjV ] = objv( variable )
%������Ⱥ����Ӧ��ֵ
%   variable Ϊһn��3����������Ⱥ���ܺġ�ʱ��ͼ��ٶȱ仯��һһ��Ӧ
%   ObjvΪn��һ������
%   Detailed explanation goes here
%����Ŀ����Ӧ��ֵ

global DESIGNTIM COMFACC;

a = 1000;             %ʱ��ͷ�����            
b = 10;               %�����Գͷ�����

% n = size(variable,1);
% ObjV = zeros(n,1);
% for i=1:1:n
%     ObjV(i,1) = 1/(variable(i,1)*(1+((variable(i,2)-DESIGNTIM)/DESIGNTIM *a)^2)*(1+((variable(i,3)-COMFACC)/COMFACC*b)^2));
% %     *(1+((variable(i,3)-COMFACC)/COMFACC)^2*10)
% end

% ObjV = 1./variable(:,2);  %���п�����С����ʱ����Ӧ�Ⱥ���

ObjV = 1./(variable(:,1).*(1+((variable(:,2)-DESIGNTIM)./DESIGNTIM .*a).^2).*(1+((variable(:,3)-COMFACC)./COMFACC.*b).^2));
% ObjV = 1./(variable(:,1).*(1+((variable(:,2)-DESIGNTIM)./DESIGNTIM .*a).^2));
% ObjV = variable(:,1)+abs((variable(:,2)-DESIGNTIM)./DESIGNTIM).*variable(:,1) ;
% ObjV = 1./(variable(:,1).*(1+((variable(:,2)-DESIGNTIM)./DESIGNTIM .*variable(:,1)).^2).*(1+((variable(:,3)-COMFACC)./COMFACC.*b).^2));


end

