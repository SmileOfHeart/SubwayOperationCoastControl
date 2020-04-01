function genemain()
%遗传算法主程序
%   Detailed explanation goes here

global COADIS TRAVDIS num;

if TRAVDIS < 2048
    PRECI = 11;
    cnum = 2;
elseif TRAVDIS < 4096
    PRECI = 12;
    cnum = 4;
else
    PRECI = 13;
    cnum = 6;
end

NIND = 50;                          %种群数量
MAXGEN = 100;                       %迭代次数
NVAR = cnum;
GGAP = 1.5;                         %交叉选择代沟
trace = zeros(2,MAXGEN);
FieldD = [rep(PRECI,[1,NVAR]);rep([COADIS;TRAVDIS],[1,NVAR]);rep([1;0;1;0],[1,NVAR])];

% 随机生成种群
Chrom = crtbp(NIND,NVAR*PRECI);
Chrom = chromsort(Chrom, FieldD);
Phen = bs2rv(Chrom,FieldD);
SuitChrom = zeros(NIND,NVAR*PRECI);

%初始染色体选取，记录不满足约束条件数目
n = 0;
j = 1;
for i=1:1:NIND
    if testchrom(Phen(i,:))
        SuitChrom(j,:) = Chrom(i,:);
        j = j + 1;
    else
        n = n + 1;
    end
    n
end

%补齐初始种群
while n > 0
    while 1
        chrom = crtbp(1,NVAR*PRECI);
        chrom = chromsort(chrom,FieldD);
        phen = bs2rv(chrom,FieldD);
        % n
        if testchrom(phen)
            SuitChrom(j,:) = chrom;
            j = j + 1;
            break;
        end
    end
    n = n - 1;
    n
end
Chrom = SuitChrom;

gen = 0;
dgen = 0;           %最佳适应度停留不前进的代数和
MRate = 0.02;       %初始变异概率
CoastArray = bs2rv(Chrom,FieldD);
variable = etjarray(CoastArray);    %牵引运行仿真计算
ObjV = objv(variable);

while gen < MAXGEN
%     warning('loop begin');
    FitnV = ranking(-ObjV);
    SelCh = select('sus',Chrom,FitnV,GGAP);
    CRate = 0.9;
    SelCh = xovmp(SelCh,CRate,2,1);
    %     SelCh = recombin('xovsp',SelCh,0.7);
    SelCh = chromsort(SelCh,FieldD);
    
    %交叉重组后对染色体进行符合约束条件的筛选
    n = 0;
    j = 1;
    Phen = bs2rv(SelCh,FieldD);
    SuitChrom = zeros(GGAP*NIND,NVAR*PRECI);
    for i=1:1:GGAP*NIND
        if testchrom(Phen(i,:))
            SuitChrom(j,:) = SelCh(i,:);
            j = j + 1;
        else
            n = n + 1;
        end
    end
    cn = GGAP*NIND - n;
    
    %变异概率
    if cn >=1
        SelCh = SuitChrom(1:cn,:);
        if dgen >= 3
            MRate = MRate + 0.01;
            if MRate >= 0.1
                MRate = 0.1;
            end
        end
        if gen >= MAXGEN*0.8
            MRate = 0.02;
        end
        
        SelCh = mut(SelCh,MRate);
        %SelCh = mut(SelCh);
        SelCh = chromsort(SelCh,FieldD);
        
        %变异操作后对染色体进行符合约束条件的筛选，不足种群大小时以最后一个符合条件的染色体补齐
        n = 0;
        j = 1;
        Phen = bs2rv(SelCh,FieldD);
        SuitChrom = zeros(cn,NVAR*PRECI);
        for i=1:1:cn
            if testchrom(Phen(i,:))
                SuitChrom(j,:) = SelCh(i,:);
                j = j + 1;
            else
                n = n + 1;
            end
        end
        xn = cn - n;
        
        %最优保存策略，重插入概率
        if xn>=1
            SelCh = SuitChrom(1:xn,:);
            ObjVSel = objv(etjarray(bs2rv(SelCh,FieldD)));
            if xn <= NIND*0.8
                IRate = 1;
            else
                
                IRate = NIND*0.8/xn;
            end
            
            [Chrom,ObjV] = reins(Chrom,SelCh,1,[1,IRate],-ObjV,-ObjVSel);
            ObjV = -ObjV;
        end
    end
    gen = gen + 1;
    gen
    
    [~,I] = max(ObjV);
    chrom = Chrom(I,:);
    trace(1,gen) = max(ObjV);
    
    %变异概率调整
    if gen >1
        if 0 == trace(1,gen)-trace(1,gen-1)
            dgen = dgen +1;
        else
            dgen = 0;
            MRate = 0.02;
        end
    end
    trace(2,gen) = mean(ObjV);
 
end

coast = bs2rv(chrom,FieldD);
h = figure(1);
plot(trace(1,:)','.-k');
hold on
plot(trace(2,:)','-.k');
grid;
legend('适应度的变化','平均适应度的变化');
xlabel('迭代次数');
ylabel('适应度值');

%建立输出文件目录，保存算法性能跟踪图形。
% str = ['C:\Users\Tfc\Desktop\profile\' num2str(num) num2str(TRAVDIS)];
% mkdir(str);
% str = [str '\fitness'];
% saveas( h,str,'fig');

[ TravTim, EnerCsm,Jerk ] = veloprof( coast );  %结果输出

TravTim
EnerCsm
Jerk
coast




end

