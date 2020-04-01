function [ NewChrom ] = chromsort( OldChrom,FieldD )
%Ⱦɫ���л������򣬱�֤���е㰴��������
%   Detailed explanation goes here

n = size(FieldD,2)*FieldD(1,1);                      %Ⱦɫ�峤��

NewChrom = zeros(size(OldChrom,1),n);
[~,IX] = sort(bs2rv(OldChrom,FieldD),2);
[m, n] = size(IX);

for i=1:1:m
    g = 1;
    for j=1:1:n
        for k=1:1:FieldD(1,1)
            NewChrom(i,g) = OldChrom(i,(IX(i,j)-1)*FieldD(1,1)+k);
            g = g + 1;
        end
    end
end

end

