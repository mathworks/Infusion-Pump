MagBVec = [1 2 3];
StrokeTimeVec = [1 2 3];
PauseTimeVec  = [5 10]; % 5 10
OcclPctVec       = [0 0.9 0.95 0.99 0.995 0.999 0.9993 0.9995 0.9997 0.9999];
id_accum = 0;
for i = 1:length(MagBVec)
    for j = 1:length(StrokeTimeVec)
        for k = 1:length(PauseTimeVec)
            for l = 1:length(OcclPctVec)
                clc
%                 ['SimuData' num2str(i) num2str(j) num2str(k) num2str(l)]
%                 MagB = MagBVec(i);
                StrokeTimeB = StrokeTimeVec(j);
                PauseTime  = PauseTimeVec(k);
                const_Occl_Pct = OcclPctVec(l);
%                 simOut = sim('InfusionPumpModelV7NoOccDetect','ReturnWorkspaceOutputs','on','FastRestart','on');

                SimIn(i,j,k,l) = Simulink.SimulationInput('InfusionPumpModelV7NoOccDetect');
                SimIn(i,j,k,l) = SimIn(i,j,k,l).setBlockParameter('InfusionPumpModelV7NoOccDetect/CommandGeneration/Constant3','Value',num2str(MagBVec(i)));
                SimIn(i,j,k,l) = SimIn(i,j,k,l).setBlockParameter('InfusionPumpModelV7NoOccDetect/CommandGeneration/Constant12','Value',num2str(StrokeTimeVec(j)));
%                 simOut = parsim(simIn,'ShowSimulationManager','on','UseFastRestart','on');
%                 save(['SimuData' num2str(i) num2str(j) num2str(k) num2str(l)],'simOut')


            end
        end
    end
end
% simOut = sim('InsulinPumpModelV7','ReturnWorkspaceOutputs','on','FastRestart','on');
SimOut = parsim(SimIn,'ShowSimulationManager','on','UseFastRestart','on');