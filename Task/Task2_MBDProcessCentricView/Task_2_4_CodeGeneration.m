% Task_2_4_Codegeneration
%% Open code generation report and inspect linkage to the model, requirement and different model reference
bdclose('all')
clear
run InitializationInsulinPump
close all
open('InfusionPumpSoftwareModel')
cd Codegen;
slbuild('InfusionPumpSoftwareModel')
cd ../
coder.report.generate('InfusionPumpSoftwareModel');