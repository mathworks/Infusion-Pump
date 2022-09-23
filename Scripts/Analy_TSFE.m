function [ K_f1, C_f1, K_f2, C_f2] = Analy_TSFE( DataSetName )
clc
% clear
% close all
load(DataSetName)
t_sample = 0.01;
time = 0:t_sample:120;
idx_sec1 = 1:5000;
idx_sec2 = 5500:length(time);
Analy_Force = simOut.get('Result_Force');
idx_init = find(Analy_Force(:,2)<9);
Analy_Force(idx_init,2) = 9;
Analy_Force(:,2) = Analy_Force(:,2)-Analy_Force(idx_init,2);
Analy_Speed = simOut.get('Result_MotorSpeed');
% figure
% subplot(2,1,1)
% plot(Analy_Force(:,1),Analy_Force(:,2))
% xlabel('Time (sec)')
% ylabel('Force (N)')
% grid
% subplot(2,1,2)
% plot(Analy_Speed(:,1),Analy_Speed(:,2))
% xlabel('Time (sec)')
% ylabel('Motor Speed (RPM)')
% grid
Input1  = Analy_Speed(idx_sec1,2)+0*randn(length(idx_sec1),1);
Output1 = Analy_Force(idx_sec1,2)+0*randn(length(idx_sec1),1);
Input2  = Analy_Speed(idx_sec2,2)+0*randn(length(idx_sec2),1);
Output2 = Analy_Force(idx_sec2,2)+0*randn(length(idx_sec2),1);
figure
subplot(2,1,1)
plot(time(idx_sec1),Output1,time(idx_sec2),Output2)
xlabel('Time (sec)')
ylabel('Force (N)')
grid
subplot(2,1,2)
plot(time(idx_sec1),Input1,time(idx_sec2),Input2)
xlabel('Time (sec)')
ylabel('Motor Speed (RPM)')
grid
%%
data1 = iddata(Output1,Input1,t_sample);
data2 = iddata(Output2,Input2,t_sample);
opt = tfestOptions;
opt.InitialCondition = 'estimate';
opt.Initoption.MaxIter = 500;
np = 2;
nz = 1;
%%
sys1 = tfest(data1,np,nz);
sys2 = tfest(data2,np,nz);
%%
K_f1 = sys1.Numerator(2)/sys1.Denominator(3);
C_f1 = sys1.Numerator(1)/sys1.Denominator(2);
K_f2 = sys2.Numerator(2)/sys2.Denominator(3);
C_f2 = sys2.Numerator(1)/sys2.Denominator(2);

end

