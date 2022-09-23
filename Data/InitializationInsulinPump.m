% clear 
close all
%% DC Motor
const.DCMotor.RotorInert = 8.2e-9;  % rotor inertia (kg*m^2) - DC Motor
const.DCMotor.RotorDamp  = 2e-9;    % rotor damping (N*m/(rad/s)) - DC Motor
const.DCMotor.Resist     = 31.4;    % resistance (Ohms)
const.DCMotor.Induct     = 30e-3;   % inductance (H)
const.DCMotor.BEMF       = 4.74e-3; % back EMF constant (V/(rad/s))
const.DCMotor.CalTabVolt = [0 0.25 0.3 0.35 0.355 0.36 0.38 0.4 0.5 1 1.5 2 2.3 2.72 3.5 3.9 4.4 4.6 4.8];
const.DCMotor.CalTabSpd  = [0 0.136 0.170 0.205 1.08 2.58 8.02 12.8 33.8 828.2 1535.4 2171.5 2526 3000 3827.2 4246 4775.6 4991.1 5209.4];
% const.DCMotor.StrokeLim  = 60*15
% figure
% plot(const.DCMotor.CalTabSpd,const.DCMotor.CalTabVolt,'.-')
% xlabel('Speed (RPM)')
% ylabel('Voltage (V)')
% grid
%% Drive System
const.DriveSys.GearRatio = 216;     % gear ratio
const.DriveSys.GearEff   = 0.68;    % gear efficiency
const.DriveSys.ScrewLead = 1/24;    % displacement per revolution (inches)
const.DriveSys.LeadAng   = 2.2;     % lead angle (degrees)
const.DriveSys.AcmeHalfAng = 30;    % acme thread half angle (degrees)
const.DriveSys.FricCoeff = 0.08;    % leadscrew friction coefficient
const.DriveSys.DepdFricCoeff = const.DCMotor.RotorDamp/10;
%% Slide
const.Slide.Mass = 1.585/1000;  % slide mass (kg)
const.Slide.Brkaway = 0.75;
const.Slide.Coulomb = const.Slide.Brkaway*0.8;
const.Slide.ViscFric = 0.5;
const.Slide.TransApproxCoeff = 10/1000;
const.Slide.LinVelThresh = 1e-5/1000;
const.Slide.EMod  = 2.79e9;
const.Slide.CrosA = 2.38e-5;      % slide annulus cross-sectional area (m^2)
const.Slide.InitL = 5/1000;  % initial length of slide (m)
const.Slide.MaxLen = 33/1000;
const.Slide.MinSprRate = const.Slide.EMod*const.Slide.CrosA/const.Slide.MaxLen;
const.Slide.InitDeform = 0;
%% Reservoir 
const.Resvor.PistonMass = 0.417/1000;  % piston mass (kg)
const.Resvor.Brkaway = 1.5;
const.Resvor.Coulomb = const.Resvor.Brkaway*0.8;
const.Resvor.ViscFric = 0.5;
const.Resvor.TransApproxCoeff = 10/1000;
const.Resvor.LinVelThresh = 1e-5/1000;
const.Resvor.Len = 26.575; %% mm
const.Resvor.InDiam = 0.4720;    % inner diameter (inches)
const.Resvor.OutDiam = 0.547; % outer diameter (inches)
const.Resvor.Area = (const.Resvor.InDiam*2.54*10)^2/4*pi; % reservoir cross-sectional area (mm^2)
const.Resvor.Vol  = const.Resvor.Area*const.Resvor.Len;
const.Resvor.InitP = 101325;     % initial pressure (Pa)
%% Needle
const.Needle.Diam = 0.0055; % inch
const.Needle.Ang  = 55;     % deg
const.Needle.Len  = 0.29;   % inch
const.Needle.InitP = 101325;     % initial pressure (Pa)
%% Silicone Septum
const.Septum.Capacity = 6;          % silicone septum capacity (mm^3) - silicone septum Spring-Loaded Accumulator
const.Septum.PreloadP = 5e6;    % silicone septum preload pressure (Pa) - silicone septum Spring-Loaded Accumulator
const.Septum.MaxP = 3e8;    % maximum pressure in spring-loaded accumulator (Pa)
%% Tubing
const.Tubing.Diam = 0.1925*2; % tubing diameter (mm)
const.Tubing.Area = (const.Tubing.Diam/(2*1000))^2*pi;  % tubing cross sectional area (m^2)
const.Tubing.Len = 43;   % length (in) - tubing
const.Tubing.InitP = 101325;     % initial pressure (Pa)
const.Tubing.Compliance = 4e-13;    % static diameter pressure coefficient (m/Pa) - tubing
%% Infusion Septum
const.Infu.Capacity = const.Septum.Capacity/5; % mm^3
const.Infu.PreloadP = const.Septum.PreloadP/5;  % Pa
const.Infu.MaxP = 3e8;    % maximum pressure in spring-loaded accumulator (Pa)
%% Occulusion
const.Occl.Time = 50;
const_Occl_Pct = 0.9999; %
% const.Occl.Pct = 0.99999;
%% Control
DeliveryType = 1;
MagB = 1; % 1 2 3
StrokeTimeB = 1; % 1 2
PauseTime  = 5; % 5 10
NumCyc     = 20;
%% Feedback Bus Object
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'AngularSpeed_RPM';
elems(1).Dimensions = 1;
elems(1).DimensionsMode = 'Fixed';
elems(1).DataType = 'double';
elems(1).Min      = -6000;
elems(1).Max      = 6000;
elems(1).SampleTime = -1;
elems(1).Complexity = 'real';
elems(1).Unit       = 'rpm';

elems(2) = Simulink.BusElement;
elems(2).Name = 'LoadForce_N';
elems(2).Dimensions = 1;
elems(2).DimensionsMode = 'Fixed';
elems(2).DataType = 'double';
elems(2).Min      = 0;
elems(2).Max      = 10^7;
elems(2).SampleTime = -1;
elems(2).Complexity = 'real';
elems(2).Unit       = 'N';

elems(3).Name = 'PistonDisp_mm';
elems(3).Dimensions = 1;
elems(3).DimensionsMode = 'Fixed';
elems(3).DataType = 'double';
elems(3).Min      = -30;
elems(3).Max      = 0;
elems(3).SampleTime = -1;
elems(3).Complexity = 'real';
elems(3).Unit       = 'mm';
FEEDBACK = Simulink.Bus;
FEEDBACK.Elements = elems;
%% Command Bus Object
clear elems;
elems(1) = Simulink.BusElement;
elems(1).Name = 'PowerOn';
elems(1).Dimensions = 1;
elems(1).DimensionsMode = 'Fixed';
elems(1).DataType = 'boolean';
elems(1).Min      = 0;
elems(1).Max      = 1;
elems(1).SampleTime = -1;
elems(1).Complexity = 'real';

elems(2) = Simulink.BusElement;
elems(2).Name = 'BolusType';
elems(2).Dimensions = 1;
elems(2).DimensionsMode = 'Fixed';
elems(2).DataType = 'int8';
elems(2).Min      = 0;
elems(2).Max      = 2;
elems(2).SampleTime = -1;
elems(2).Complexity = 'real';

elems(3) = Simulink.BusElement;
elems(3).Name = 'NumCyc';
elems(3).Dimensions = 1;
elems(3).DimensionsMode = 'Fixed';
elems(3).DataType = 'int8';
elems(3).Min      = 0;
elems(3).Max      = 100;
elems(3).SampleTime = -1;
elems(3).Complexity = 'real';

elems(4) = Simulink.BusElement;
elems(4).Name = 'DeliveryAct';
elems(4).Dimensions = 1;
elems(4).DimensionsMode = 'Fixed';
elems(4).DataType = 'boolean';
elems(4).Min      = 0;
elems(4).Max      = 1;
elems(4).SampleTime = -1;
elems(4).Complexity = 'real';

elems(5) = Simulink.BusElement;
elems(5).Name = 'BolusMag';
elems(5).Dimensions = 1;
elems(5).DimensionsMode = 'Fixed';
elems(5).DataType = 'single';
elems(5).Min      = 0;
elems(5).Max      = 3;
elems(5).SampleTime = -1;
elems(5).Complexity = 'real';

elems(6) = Simulink.BusElement;
elems(6).Name = 'StrokeTimeB';
elems(6).Dimensions = 1;
elems(6).DimensionsMode = 'Fixed';
elems(6).DataType = 'single';
elems(6).Min      = 0.2;
elems(6).Max      = 5;
elems(6).SampleTime = -1;
elems(6).Complexity = 'real';

elems(7) = Simulink.BusElement;
elems(7).Name = 'MagQB';
elems(7).Dimensions = 4;
elems(7).DimensionsMode = 'Fixed';
elems(7).DataType = 'single';
elems(7).Min      = 0;
elems(7).Max      = 3;
elems(7).SampleTime = -1;
elems(7).Complexity = 'real';

elems(8) = Simulink.BusElement;
elems(8).Name = 'StrokeTimeQB';
elems(8).Dimensions = 4;
elems(8).DimensionsMode = 'Fixed';
elems(8).DataType = 'single';
elems(8).Min      = 0.2;
elems(8).Max      = 5;
elems(8).SampleTime = -1;
elems(8).Complexity = 'real';

elems(9) = Simulink.BusElement;
elems(9).Name = 'PauseTime';
elems(9).Dimensions = 1;
elems(9).DimensionsMode = 'Fixed';
elems(9).DataType = 'single';
elems(9).Min      = 0;
elems(9).Max      = 100;
elems(9).SampleTime = -1;
elems(9).Complexity = 'real';

elems(10) = Simulink.BusElement;
elems(10).Name = 'LowLim';
elems(10).Dimensions = 1;
elems(10).DimensionsMode = 'Fixed';
elems(10).DataType = 'single';
elems(10).Min      = 0;
elems(10).Max      = 100;
elems(10).SampleTime = -1;
elems(10).Complexity = 'real';

elems(11) = Simulink.BusElement;
elems(11).Name = 'BasalAct';
elems(11).Dimensions = 1;
elems(11).DimensionsMode = 'Fixed';
elems(11).DataType = 'boolean';
elems(11).Min      = 0;
elems(11).Max      = 1;
elems(11).SampleTime = -1;
elems(11).Complexity = 'real';

elems(12) = Simulink.BusElement;
elems(12).Name = 'MaxBasalRate_unit_hr';
elems(12).Dimensions = 1;
elems(12).DimensionsMode = 'Fixed';
elems(12).DataType = 'single';
elems(12).Min      = 0;
elems(12).Max      = 2;
elems(12).SampleTime = -1;
elems(12).Complexity = 'real';

elems(13) = Simulink.BusElement;
elems(13).Name = 'BasalRate_unit_hr';
elems(13).Dimensions = 1;
elems(13).DimensionsMode = 'Fixed';
elems(13).DataType = 'single';
elems(13).Min      = 0;
elems(13).Max      = 2;
elems(13).SampleTime = -1;
elems(13).Complexity = 'real';

COMMAND = Simulink.Bus;
COMMAND.Elements = elems;
%%
OcclAlgorithmSelect = 1;