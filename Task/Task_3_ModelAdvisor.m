% Task_2_2 ModelAdvisor
%% Open model advisor and run the audit manually
clc
bdclose('all')
close all
clear
run InitializationInsulinPump
close all
modeladvisor('InfusionPumpSoftwareModel')
%% Automate Check
% CheckIDList = {'mathworks.codegen.PCGSupport'};
fileName = 'IEC62304_MAB.json'
SysList = {'InfusionPumpSoftwareModel'};
SysResultObjArray = ModelAdvisor.run(SysList,'Configuration',fileName);
viewReport(SysResultObjArray{1})