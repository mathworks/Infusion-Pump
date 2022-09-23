cd([CurrentDir '/Data/SimuResultSet2'])
list = dir('.\SimuData*.mat');
%%
Section1Param.Kf = zeros(numel(list),1);
Section1Param.Cf = zeros(numel(list),1);
Section2Param.Kf = zeros(numel(list),1);
Section2Param.Cf = zeros(numel(list),1);
for ii = 1: numel(list)
    DataSetName = list(ii).name;
    [ K_f1, C_f1, K_f2, C_f2] = Analy_TSFE( DataSetName );
    Section1Param.Kf(ii)= K_f1;
    Section1Param.Cf(ii)= C_f1;
    Section2Param.Kf(ii)= K_f2;
    Section2Param.Cf(ii)= C_f2;
    close all
end
%%
idx_temp = find(Section2Param.Kf>0);
close all
figure
plot((Section1Param.Kf(idx_temp).^(1/3)),(Section1Param.Cf(idx_temp).^(1/3)),'.',(Section2Param.Kf(idx_temp).^(1/3)),(Section2Param.Cf(idx_temp).^(1/3)),'o') %,Section2Param.Kf,Section2Param.Cf,'.'
grid
%%
close all
DataClassNorm = real([(Section1Param.Kf(idx_temp)).^(1/3) (Section1Param.Cf(idx_temp)).^(1/3);...
                 (Section2Param.Kf(idx_temp)).^(1/3) (Section2Param.Cf(idx_temp)).^(1/3)]);
figure
plot(DataClassNorm(:,1),DataClassNorm(:,2),'o')
xlabel('Stiffness Factor')
ylabel('Damping Factor')
grid
idx = kmeans(DataClassNorm,3);
idx1 = find(idx==1);
idx2 = find(idx==2);
idx3 = find(idx==3);
figure
plot(DataClassNorm(idx1,1),DataClassNorm(idx1,2),'o',...
    DataClassNorm(idx2,1),DataClassNorm(idx2,2),'*',...
    DataClassNorm(idx3,1),DataClassNorm(idx3,2),'.')
xlabel('Stiffness Factor')
ylabel('Damping Factor')
grid
%%
cd(CurrentDir)