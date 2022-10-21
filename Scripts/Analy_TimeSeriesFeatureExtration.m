clc
clear all
close all
%% Initial Variables And Retrive the List of Data
run InitializationInsulinPump
close all
p = simulinkproject;
projectRoot = p.RootFolder;
cd([projectRoot '/Data/SimuResultSet2'])
list = dir('.\SimuData*.mat');
cd([projectRoot '/work'])
%% Retrive Basic Variables for Single Data Set 
close all
idx_set = 2;
load([list(idx_set).folder '\' list(idx_set).name])
% The data needs to be sampled to certain fixed step
t_sample = 0.01;
time = 0:t_sample:120;
Analy_Force = simOut.get('Result_Force');
idx_init = find(Analy_Force(:,2)<9);
Analy_Force(idx_init,2) = 9;
Analy_Force(:,2) = Analy_Force(:,2)-Analy_Force(idx_init,2);
Analy_Speed = simOut.get('Result_MotorSpeed');
Analy_PistonSpd = Analy_Speed(:,2)/reserv_str.DriveSys.GearRatio*reserv_str.DriveSys.ScrewLead*25.4/60*1000;
idx_sec1 = 1:5000;
idx_sec2 = 5500:length(time);
Input1  = Analy_Speed(idx_sec1,2)+0.05*randn(length(idx_sec1),1);
Output1 = Analy_Force(idx_sec1,2)+0.05*randn(length(idx_sec1),1);
Input2  = Analy_Speed(idx_sec2,2)+0.05*randn(length(idx_sec2),1);
Output2 = Analy_Force(idx_sec2,2)+0.05*randn(length(idx_sec2),1);
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
% figure
% subplot(2,1,1)
% plot(time,Analy_Force(:,2))
% xlabel('Time (sec)')
% ylabel('Force (N)')
% grid
% subplot(2,1,2)
% plot(time, Analy_PistonSpd)
% xlabel('Time (sec)')
% ylabel('Piston Speed (mm/s)')
% grid
%% Load All Data Set
Analy_Force_set = zeros(12001,180);
Analy_Speed_set = zeros(12001,180);
for i = 1: 180
    load([list(i).folder '\' list(i).name])
    Analy_Force = simOut.get('Result_Force');
    Analy_Speed = simOut.get('Result_MotorSpeed');
    Analy_Force_set(:,i) = Analy_Force(:,2);
    Analy_Speed_set(:,i) = Analy_Speed(:,2);
end
%% Pick Training Set
idx = 1;
IdxVec = [2:10 12:20 22:30 32:40 42:50 52:60 ...
           62:70 72:80 82:90 92:100 102:110 112:120 ...
           122:130 132:140 142:150 152:160 162:170 172:180];
Analy_Force_setT = Analy_Force_set(:,IdxVec);
Analy_Speed_setT = Analy_Speed_set(:,IdxVec);
%% Prepare Data for classification Trainer
statfuns = @(x)[max(x) mean(x) min(x) var(x) std(x)];
blocksize = 2500;
TrainDataStats_Force = SingleChannelFeatures(Analy_Force_setT,blocksize);
TrainDataStats_Speed = SingleChannelFeatures(Analy_Speed_setT,blocksize);
TrainDataStats       = [TrainDataStats_Force TrainDataStats_Speed];
OcclStatus = repmat([0 0 1 1 1]',162,1);
TrainDataStats2 = array2table([TrainDataStats OcclStatus]);
TrainDataStats2.Properties.VariableNames = {'maxF';'meanF';'minF';'varF';'stdF'; 'maxS';'meanS';'minS';'varS';'stdS';'Occ'};
% [trainedClassifier, validationAccuracy] = trainClassifier(TrainDataStats2);
% saveCompactModel(trainedClassifier.ClassificationSVM,'SVMModel');
%% Test Classifier
clc
%CompactMdl = loadCompactModel('SVMTest3');
CompactMdl = loadLearnerForCoder('SVMTest3');
% CompactMdl = loadCompactModel('SVMModel');
TestForceStats = statfuns(Analy_Force_setT((1:2500)+2500*2,3));
TestSpeedStats = statfuns(Analy_Speed_setT((1:2500)+2500*2,3));
TestX          = [TestForceStats TestSpeedStats];
prediction = predict(CompactMdl,TestX)
% prediction = trainedClassifierKNN.predictFcn(TestX)
% % %% fft reconstruction
% close all
% a = Output1+2*rand(5000,1);
% fa = fft(a);
% fa(5000:end) = 0;
% reconstr = real(ifft(fa));
% figure
% plot(time(idx_sec1),a,time(idx_sec1),reconstr)
% %% cwt reconstruction
% close all
% [wt,f] = cwt(a,'morse',100);
% xrec = icwt(wt,f,[0.10 20],'morse','SignalMean',mean(a));
% p1 = pcolor(time(idx_sec1),f,abs(wt));
% figure
% plot(time(idx_sec1),a,time(idx_sec1),xrec)
% %%
% close all
% data_paa = paa( a, 500 );
% figure
% plot(time(idx_sec1),a,time(idx_sec1),data_paa)
% %%
% close all
% figure
% subplot(2,1,1)
% plot(Output1(1:2500))
% subplot(2,1,2)
% plot(Output1(2501:5000))
% figure
% dtw(Output1(1:2500),Output1(2501:5000))
% %%
% data1 = iddata(Output1,Input1,t_sample);
% data2 = iddata(Output2,Input2,t_sample);
% opt = tfestOptions;
% opt.InitialCondition = 'estimate';
% opt.Initoption.MaxIter = 500;
% np = 2;
% nz = 1;
% %%
% sys1 = tfest(data1,np,nz);
% sys2 = tfest(data2,np,nz);
% %%
% K_f1 = sys1.Numerator(2)/sys1.Denominator(3);
% C_f1 = sys1.Numerator(1)/sys1.Denominator(2);
% K_f2 = sys2.Numerator(2)/sys2.Denominator(3);
% C_f2 = sys2.Numerator(1)/sys2.Denominator(2);
