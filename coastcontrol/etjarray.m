function [ variable ] = etjarray( CoastArray )
%��Ⱥ���ܺġ�ʱ�䡢���ٶȱ仯�ʼ���
%   Detailed explanation goes here


n = size (CoastArray,1);
variable = zeros(n,3);
a = zeros(1,3);
for i=1:1:n
    [a(1),a(2),a(3)] = etjcalc(CoastArray(i,:));
    variable(i,:) = a;
end

end

