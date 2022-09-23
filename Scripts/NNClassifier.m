clear all
close all
load NNClassifierData
%% Define Neural Network Basics
net = network;
net.numInputs = 2;
net.numLayers = 5;
net.biasConnect = [1; 1; 1; 1; 1];
net.inputConnect = [1 1; 0 0; 0 0;0 0;0 0];
net.layerConnect = [0 0 0 0 0;...
                    1 0 0 0 0;...
                    0 1 0 0 0;...
                    0 0 1 0 0;...
                    0 0 0 1 0];
net.outputConnect = [0 0 0 0 1];
net.inputs{1}.size = 5;
net.inputs{1}.processFcns = {'removeconstantrows','mapminmax'};
net.inputs{2}.size = 5;
net.inputs{2}.processFcns = {'removeconstantrows','mapminmax'};
%% Layers
% net.layers{1}.size = 15;
% net.layers{1}.transferFcn = 'tansig';
% net.layers{1}.initFcn = 'initnw';
% net.layers{2}.size = 15;
% net.layers{2}.transferFcn = 'logsig';
% net.layers{2}.initFcn = 'initnw';
% net.layers{3}.size = 15;
% net.layers{3}.transferFcn = 'satlins';
% net.layers{3}.initFcn = 'initnw';
% net.layers{4}.size = 15;
% net.layers{4}.transferFcn = 'satlin';
% net.layers{4}.initFcn = 'initnw';
% net.layers{5}.size = 1;
% net.layers{5}.transferFcn = 'poslin';
% net.layers{5}.initFcn = 'initnw';
% view(net)
net.layers{1}.size = 20;
net.layers{1}.transferFcn = 'tansig';
net.layers{1}.initFcn = 'initnw';
net.layers{2}.size = 10;
net.layers{2}.transferFcn = 'logsig';
net.layers{2}.initFcn = 'initnw';
net.layers{3}.size = 10;
net.layers{3}.transferFcn = 'satlins';
net.layers{3}.initFcn = 'initnw';
net.layers{4}.size = 10;
net.layers{4}.transferFcn = 'satlin';
net.layers{4}.initFcn = 'initnw';
net.layers{5}.size = 1;
net.layers{5}.transferFcn = 'softmax';
net.layers{5}.initFcn = 'initnw';
view(net)
%%
% net.trainFcn = 'trainlm';
net.trainFcn = 'trainscg';
net.divideFcn = 'dividerand';
net.divideMode = 'sample';  % Divide up every sample
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
net.performFcn = 'crossentropy';
% net.plotFcns = {'plotperform','plottrainstate','ploterrhist','plotregression'};
net.plotFcns = {'plotperform','plottrainstate','ploterrhist','plotconfusion'};
net = init(net);
X  = {TrainDataStats_Force'; TrainDataStats_Speed';};
T  = {OcclStatus'};
Input = [TrainDataStats_Force'; TrainDataStats_Speed'];
Output = {OcclStatus'};
net = train(net,X,T);