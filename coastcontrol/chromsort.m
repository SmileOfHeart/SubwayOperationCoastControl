function [ NewChrom ] = chromsort( OldChrom,FieldD )
%染色体中基因排序，保证惰行点按升序排列
%   Detailed explanation goes here

n = size(FieldD,2)*FieldD(1,1);                      %染色体长度

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

