% Task_2_5_SILEquivTest
%%
clc
bdclose('all')
close all
clear
sltest.testmanager.view
tfObj = sltest.testmanager.load('InfusionPumpTest.mldatx');
sltest.testmanager.clearResults