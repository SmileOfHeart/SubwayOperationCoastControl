function [ ObjV ] = objv( variable )
%计算种群在适应度值
%   variable 为一n行3例矩阵，与种群的能耗、时间和加速度变化率一一对应
%   Objv为n行一例矩阵
%   Detailed explanation goes here
%计算目标适应度值

global DESIGNTIM COMFACC;

a = 1000;             %时间惩罚因子            
b = 10;               %舒适性惩罚因子

% n = size(variable,1);
% ObjV = zeros(n,1);
% for i=1:1:n
%     ObjV(i,1) = 1/(variable(i,1)*(1+((variable(i,2)-DESIGNTIM)/DESIGNTIM *a)^2)*(1+((variable(i,3)-COMFACC)/COMFACC*b)^2));
% %     *(1+((variable(i,3)-COMFACC)/COMFACC)^2*10)
% end

% ObjV = 1./variable(:,2);  %惰行控制最小运行时间适应度函数

ObjV = 1./(variable(:,1).*(1+((variable(:,2)-DESIGNTIM)./DESIGNTIM .*a).^2).*(1+((variable(:,3)-COMFACC)./COMFACC.*b).^2));
% ObjV = 1./(variable(:,1).*(1+((variable(:,2)-DESIGNTIM)./DESIGNTIM .*a).^2));
% ObjV = variable(:,1)+abs((variable(:,2)-DESIGNTIM)./DESIGNTIM).*variable(:,1) ;
% ObjV = 1./(variable(:,1).*(1+((variable(:,2)-DESIGNTIM)./DESIGNTIM .*variable(:,1)).^2).*(1+((variable(:,3)-COMFACC)./COMFACC.*b).^2));


end

