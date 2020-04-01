function [ variable ] = etjarray( CoastArray )
%种群的能耗、时间、加速度变化率计算
%   Detailed explanation goes here


n = size (CoastArray,1);
variable = zeros(n,3);
a = zeros(1,3);
for i=1:1:n
    [a(1),a(2),a(3)] = etjcalc(CoastArray(i,:));
    variable(i,:) = a;
end

end

